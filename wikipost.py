#!/usr/bin/env python
#-*- coding: utf8 -*-

'''Tools for uploading pages to mediawiki'''


import wikitools
import sys


class MediaWiki():
	'''Класс для работы c wiki'''

	url = ''
	user = ''
	password = ''
	site = None

	def __init__(self, url, user='admin', password=None):
		'''Конструктор. В нём логинимся'''
		self.url=url
		self.user=user
		self.password=password
		try:
			self.site = wikitools.wiki.Wiki(self.url)
			self.site.login(username=self.user, password=self.password)
		except Exception, e:
			print('Can`t login')
			print(str(e))
			sys.exit(1)


	def getToken(self, pagename, token_type='edit', ):
		'''Получаем токен для редактирования'''
		params = {'action':'query', 'titles':pagename, 'prop':'info|revisions', 'intoken':token_type}
		req = wikitools.api.APIRequest(self.site, params)
		res = req.query(querycontinue=False)
		if not res:
			print('Can`t get token')
			sys.exit(1)
		key = res.get('query').get('pages').keys()[0]
		token = res.get('query').get('pages').get(key).get('edittoken')
		timestamp = res.get('query').get('pages').get(key).get('timestamp')
		if not token:
			print('Token is empty')
			sys.exit(1)
		return token 


	def post(self, pagename, pagetext):
		'''Постим страницу'''
		token = self.getToken(pagename)
		params = {'action':'edit', 'title':pagename, 'text':pagetext, 'recreate':1, 'token':token}
		req = wikitools.api.APIRequest(self.site, params)  
		res = req.query(querycontinue=False)
		if not res:
			print('Response is empty')
			sys.exit(1)
		if not res.get('edit').get('result') == u'Success':
			print(res)
			sys.exit(1)
	
	def delete(self, pagename):
		'''Удаляем страницу'''
		token = self.getToken(pagename, 'delete')
		params = {'action':'delete', 'title':pagename, 'token':token}
		req = wikitools.api.APIRequest(self.site, params)  
		res = req.query(querycontinue=False)
		if not res:
			print('Response is empty')
			sys.exit(1)
		if not res.get('edit').get('result') == u'Success':
			print(res)
			sys.exit(1)

def main():
	'''Функция отправки страницы'''
	pass


if __name__ == '__main__':
	main()
