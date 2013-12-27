#!/usr/bin/env python
#-*- coding: utf8 -*-


#WIKI_PASS='2ebrfls93t'
#WIKI_USER='admin'
CONFNAME='doxygen2wiki.conf'

from wikipost import MediaWiki
#import xml.etree.cElementTree as etree
from lxml import etree
import sys, os
import re
from ConfigParser import ConfigParser


def getElemText(tag):
	try:
		text = (tag.text or u'')
		tail = u''
		for e in tag:
			text += etree.tostring(e, encoding='utf-8').decode('utf-8')
			tail = (e.tail or u'')
		return text+tail
	except UnicodeDecodeError:
		text = re.sub('(^<.+?>)|(<\/.+?>)$', '', etree.tostring(tag, encoding='utf-8').decode('utf-8'))
		return text

pagelist = []

config = ConfigParser()
config.optionxform = str
config.read(CONFNAME)

WIKI_PASS = config.get('wiki', 'password')
WIKI_USER = config.get('wiki', 'user')
WIKI_URL = config.get('wiki', 'url')

XSL_FILE = config.get('xml', 'xslfile')
DOXYGEN_ALL_XML = config.get('xml', 'doxygenallxml')
COMPLETED_XML = config.get('xml', 'completedxml')
DOXYGEN_PATH = config.get('xml', 'doxygenxmlpath')
if not XSL_FILE:
	XSL_FILE = 'doxygen2mediawiki.xsl'

transform = etree.XSLT(etree.parse(XSL_FILE))

if COMPLETED_XML:
	result = etree.parse(COMPLETED_XML)
elif DOXYGEN_ALL_XML:
	doc = etree.parse(DOXYGEN_ALL_XML)
	result = transform(doc)
else:
	combine = etree.XSLT(etree.parse(os.path.join(DOXYGEN_PATH, 'combine.xslt')))
	indexdoc = etree.parse(os.path.join(DOXYGEN_PATH, 'index.xml'))
	doc = combine(indexdoc)
	result = transform(doc)
	
#doc = etree.parse(sys.stdin).getroot()
wiki = MediaWiki(WIKI_URL, WIKI_USER, WIKI_PASS)

for page in result.findall('pages/page'):
	title = page.find('title').text.replace('_', ' ').decode('utf8')
	print('Posting page %s' % title)
	wiki.post(page.find('title').text, getElemText(page.find('text')))
	pagelist.append(title)
for title in list(set(wiki.get_list_in_category('autogenerate')) - set(pagelist)):
	if not (u'Категория:' in title or u'Category:' in title):
		print('Deleting page %s' % title)
		wiki.delete(title)
