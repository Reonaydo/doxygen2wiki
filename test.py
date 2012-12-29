#!/usr/bin/env python
#-*- coding: utf-8 -*-

try:
    import xml.etree.cElementTree as etree
except:
    import xml.etree.ElementTree as etree

def content(tag, doc):
	'''Возвращает содержимое XML тэга вместе с его подэлементами, преобразованным в упрощённый вид.
	Параметр text выводит текст только до первого под-тэга
	tag - элемент, чьё содержимое нужно преобразовать
	doc - корневой элемент xml. Используется для поиска ссылок'''
	text = (tag.text or u'')
	link = etree.Element('link')
#	return (tag.text or u'')  + u''.join(etree.tostring(e)+e.tail for e in tag.findall('.//*'))
	ref = tag.find('ref')
	if ref is not None:
		link.text = ref.text
		if doc is not None:
			xpath = './/*[@id="%s"]' % ref.get('refid')
			link.set('type', doc.find(xpath).get('kind'))
			link.tail = ref.tail
#		text += etree.tostring(link)
#		text += ref.tail
	if link.text:
		return { 'text':text, 'link':link }
	else:
		return { 'text':text }

def genClassXml(doc):
	'''Создаётся новый, человекочитаемый и легкопреобразовываемый XML с классами
	Возвращает XML, содержащую классы'''
	wikiclasses = etree.Element('classes')
	classes = doc.findall('compounddef[@kind="class"]')
	for class_elem in classes:
		wiki_class_elem = etree.Element('class', {'name': class_elem.find('compoundname').text})
		briefdescription = class_elem.find('./briefdescription')
		if briefdescription.find('para') is not None:
			short_desc = etree.Element('short_desc')
			cont = content(briefdescription.find('para'), doc)
			short_desc.text = cont['text']
			if 'link' in cont:
				short_desc.append(cont['link'])
			wiki_class_elem.append(short_desc)
		wikiclasses.append(wiki_class_elem)
	return wikiclasses

def prettify(elem):
	"""Return a pretty-printed XML string for the Element. """
	from xml.dom import minidom
	rough_string = etree.tostring(elem, encoding='UTF-8')
	reparsed = minidom.parseString(rough_string)
	return reparsed.toprettyxml(indent="  ")

def main():
	'''Basic func'''
	doc = etree.parse('all.xml').getroot()
	wikidoc = etree.Element('doc')
	wikidoc.append(genClassXml(doc))

	print prettify(wikidoc)
		

if __name__ == '__main__':
	main()

