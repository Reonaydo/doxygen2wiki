#!/usr/bin/env python
#-*- coding: utf8 -*-


WIKI_PASS='2ebrfls93t'
WIKI_USER='admin'
WIKI_URL='http://wiki.reonaydo.org/api.php'

from wikipost import WikiPost
import xml.etree.cElementTree as etree
import sys
import re

doc = etree.parse(sys.stdin).getroot()
wiki = WikiPost(WIKI_URL, WIKI_USER, WIKI_PASS)

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


for page in doc.findall('pages/page'):
	if page.find('title').text not in [
		'Class_mgr_proc::Execute', 'Namespace_mgr_proc', 'Class_ResHandle', 'Struct_mgr_dns::ConnectionParams', 
		'Namespace_mgr_db', 'Class_mgr_db::Cache', 'Group_mgr_db' 
		]:
		continue

	print('Posting page %s' % page.find('title').text)
	wiki.post(page.find('title').text, getElemText(page.find('text')))
