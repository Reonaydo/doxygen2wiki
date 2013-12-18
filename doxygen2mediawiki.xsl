<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output pretty="yes" indent="yes" method="xml"/>

<xsl:variable name="newline">
<xsl:text> 
</xsl:text>
</xsl:variable>

<xsl:template match="para">
	<xsl:if test="not(ancestor::simplesect or ancestor::para)">
		<xsl:text>&lt;p&gt;</xsl:text>
	</xsl:if>
		<xsl:apply-templates />
	<xsl:if test="not(ancestor::simplesect or ancestor::para)">
		<xsl:text>&lt;/p&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="referencedby">
	<!--xsl:text></xsl:text-->
</xsl:template>

<xsl:template match="references">
	<!--xsl:text></xsl:text-->
</xsl:template>

<xsl:template match="simplesectsep">
	<xsl:value-of select="$newline"/>
</xsl:template>
<xsl:template match="linebreak">
</xsl:template>

<xsl:template match="text()">
	<xsl:variable name="text">
		<xsl:call-template name="replace-all">
			<xsl:with-param name="text">
				<xsl:call-template name="replace-all">
					<xsl:with-param name="text">
						<xsl:call-template name="replace-all">
							<xsl:with-param name="text">
								<xsl:call-template name="replace-all">
									<xsl:with-param name="text" select="."/>
									<xsl:with-param name="replace" select="' &#38;'"/>
									<xsl:with-param name="by" select="'&#160;&#38;'"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="replace" select="'&lt; '"/>
							<xsl:with-param name="by" select="'&lt;'"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="replace" select="' &gt;'"/>
					<xsl:with-param name="by" select="'&gt;'"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="replace" select="'|'"/>
			<xsl:with-param name="by" select="'&#38;&#35;124;'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--xsl:value-of select="$text"/-->
	<xsl:choose>
		<xsl:when test="(ancestor-or-self::type or ancestor::simplesect)">
			<xsl:call-template name="replace-all">
				<xsl:with-param name="text">
					<xsl:call-template name="replace-all">
						<xsl:with-param name="text">
							<xsl:call-template name="replace-all">
								<xsl:with-param name="text">
									<xsl:value-of select="$text"/>
								</xsl:with-param>
								<xsl:with-param name="replace" select="'&lt;'"/>
								<xsl:with-param name="by" select="'&#38;lt;'"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="replace" select="'&gt;'"/>
						<xsl:with-param name="by" select="'&#38;gt;'"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="replace" select="' '"/>
				<xsl:with-param name="by" select="'&#38;&#35;160;'"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="(name(..)='derivedcompoundref' or name(..)='basecompoundref') and contains($text, '&lt;')">
			<xsl:value-of select="substring-before($text, '&lt;')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--xsl:template match="type[not(text)]">
	<xsl:if test="child::*"></xsl:if>
</xsl:template-->


<xsl:template name="reftype">
	<xsl:param name="type"/>
	<xsl:choose>
		<xsl:when test="$type='class'">
			<xsl:text>Class</xsl:text>
		</xsl:when>
		<xsl:when test="$type='struct'">
			<xsl:text>Struct</xsl:text>
		</xsl:when>
		<xsl:when test="$type='group'">
			<xsl:text>Group</xsl:text>
		</xsl:when>
		<xsl:when test="$type='namespace'">
			<xsl:text>Namespace</xsl:text>
		</xsl:when>
		<xsl:when test="$type='file'">
			<xsl:text>File</xsl:text>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="ref_class">
	<xsl:param name="linktoname" />
	<xsl:param name="type" />
	<xsl:param name="name"/>
	<xsl:variable name="ltype">
		<xsl:call-template name="reftype"><xsl:with-param name="type" select="$type"/></xsl:call-template>
	</xsl:variable>
	<xsl:text>[[</xsl:text><xsl:value-of select="$ltype"/><xsl:text>_</xsl:text>
	<xsl:value-of select="$linktoname" />
	<xsl:text>|</xsl:text>
	<xsl:choose>
		<xsl:when test="$name">
			<xsl:value-of select="$name" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="." />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>]]</xsl:text>
</xsl:template>

<xsl:template name="ref_class_inner">
	<xsl:param name="linktoname" />
	<xsl:param name="parentname" />
	<xsl:param name="type" />
	<xsl:variable name="ltype">
		<xsl:call-template name="reftype"><xsl:with-param name="type" select="$type"/></xsl:call-template>
	</xsl:variable>
	<xsl:text>[[</xsl:text><xsl:value-of select="$ltype"/><xsl:text>_</xsl:text>
	<xsl:value-of select="$parentname" />
	<xsl:text>#</xsl:text>
	<xsl:value-of select="$linktoname" />
	<xsl:text>|</xsl:text>
	<xsl:value-of select="." />
	<xsl:text>]]</xsl:text>
</xsl:template>


<xsl:template name="ref_inner">
	<xsl:param name="linktoname" />
	<xsl:text>[[#</xsl:text>
	<xsl:value-of select="$linktoname" />
	<xsl:text>|</xsl:text>
		<xsl:call-template name="replace-all">
			<xsl:with-param name="text">
				<xsl:call-template name="replace-all">
					<xsl:with-param name="text">
						<xsl:value-of select="."/>
					</xsl:with-param>
					<xsl:with-param name="replace" select="'&lt;'"/>
					<xsl:with-param name="by" select="'&#38;lt;'"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="replace" select="'&gt;'"/>
			<xsl:with-param name="by" select="'&#38;gt;'"/>
		</xsl:call-template>
	<!--xsl:value-of select="." /-->
	<xsl:text>]]</xsl:text>
</xsl:template>

<xsl:template name="slash-replace">
	<xsl:param name="text"/>
	<xsl:choose>
		<xsl:when test="contains($text, '/')">
			<xsl:call-template name="slash-replace">
				<xsl:with-param name="text" select="substring-after($text, '/')" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="replace-all">
	<xsl:param name="text" />
	<xsl:param name="replace" />
	<xsl:param name="by" />
	<xsl:choose>
		<xsl:when test="contains($text, $replace)">
			<xsl:value-of select="substring-before($text, $replace)" />
			<xsl:value-of select="$by" />
			<xsl:call-template name="replace-all">
				<xsl:with-param name="text" select="substring-after($text, $replace)" />
				<xsl:with-param name="replace" select="$replace" />
				<xsl:with-param name="by" select="$by" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="refanchor">
	<xsl:param name="text"/>
	<xsl:variable name="ctext">
		<xsl:call-template name="slash-replace">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:call-template name="replace-all">
		<xsl:with-param name="text" select="$ctext"/>
		<xsl:with-param name="replace" select="'__'"/>
		<xsl:with-param name="by" select="'_'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="ref">
	<xsl:variable name="refid"><xsl:value-of select="@refid" /></xsl:variable>
	<!--xsl:variable name="refanchor"><xsl:value-of select="substring-after(substring-after($refid, '/'), '/')"/></xsl:variable-->
	<xsl:variable name="pclass" select="//*[@id=$refid]/ancestor-or-self::compounddef"/>
	<!--xsl:variable name="refobj" select="$pclass/descendant-or-self::*[@id=$refid]"/-->
	<!--xsl:variable name="compoundname"><xsl:value-of select="$pclass/compoundname"/></xsl:variable-->
	<xsl:choose>
		<xsl:when test="$pclass[@id=$refid]">
			<xsl:call-template name="ref_class">
				<xsl:with-param name="linktoname" select="$pclass/compoundname"/>
				<xsl:with-param name="type" select="$pclass/@kind"/>
			</xsl:call-template>
		</xsl:when>
		<!--xsl:when test="($pclass[@id=$refid]) and $pclass[@kind='namespace']">
			<xsl:call-template name="ref_namespace">
				<xsl:with-param name="linktoname" select="$pclass/compoundname"/>
			</xsl:call-template>
		</xsl:when-->
		<xsl:when test="ancestor::compounddef/@id = $pclass/@id">
			<xsl:call-template name="ref_inner">
				<xsl:with-param name="linktoname">
					<xsl:call-template name="refanchor">
						<xsl:with-param name="text" select="$refid"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="ref_class_inner">
				<xsl:with-param name="linktoname">
					<xsl:call-template name="refanchor">
						<xsl:with-param name="text" select="$refid"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="parentname" select="$pclass/compoundname"/>
				<xsl:with-param name="type" select="$pclass/@kind"/>
			</xsl:call-template>
		</xsl:otherwise>
		<!--xsl:when test="$pclass[@kind='namespace']">
			<xsl:call-template name="ref_namespace_inner">
				<xsl:with-param name="linktoname"><xsl:call-template name="refanchor"><xsl:with-param name="text" select="$refid"/></xsl:call-template></xsl:with-param>
				<xsl:with-param name="parentname" select="$compoundname"/>
			</xsl:call-template>
		</xsl:when-->
	</xsl:choose>
</xsl:template>

<xsl:template match="basecompoundref | derivedcompoundref">
	<xsl:value-of select="$newline"/>
	<xsl:text>* </xsl:text>
	<xsl:variable name="linktoname">
		<xsl:apply-templates/>
	</xsl:variable>
	<xsl:call-template name="ref_class" select=".">
		<xsl:with-param name="linktoname" select="$linktoname"/>
		<xsl:with-param name="type" select="'class'"/>
	</xsl:call-template>
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="simplesect-table">
	<xsl:param name="sectkind"/>
	<xsl:text>{| class="seealso"</xsl:text><xsl:value-of select="$newline"/>
	<xsl:text>| valign="top" align="left" | '''</xsl:text><xsl:value-of select="$sectkind" /><xsl:text>''' </xsl:text><xsl:value-of select="$newline"/>
	<xsl:text>| </xsl:text><xsl:apply-templates /><xsl:value-of select="$newline"/>
	<xsl:text>|}</xsl:text>
</xsl:template>

<xsl:template match="simplesect">
	<xsl:value-of select="$newline"/>
	<xsl:choose>
		<xsl:when test="@kind = 'attention'">
			<xsl:variable name="kind"><xsl:text>Warning:</xsl:text></xsl:variable>
			<xsl:call-template name="simplesect-table" select=".">
				<xsl:with-param name="sectkind" select="$kind"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@kind = 'see'">
			<xsl:variable name="kind"><xsl:text>See also:</xsl:text></xsl:variable>
			<xsl:call-template name="simplesect-table" select=".">
				<xsl:with-param name="sectkind" select="$kind"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@kind = 'return'">
			<xsl:variable name="kind"><xsl:text>Returned:</xsl:text></xsl:variable>
			<xsl:call-template name="simplesect-table" select=".">
				<xsl:with-param name="sectkind" select="$kind"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@kind = 'par'">
			<xsl:variable name="kind" select="title"/>
			<xsl:call-template name="simplesect-table" select=".">
				<xsl:with-param name="sectkind" select="$kind"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="kind"><xsl:text></xsl:text></xsl:variable>
			<xsl:call-template name="simplesect-table" select=".">
				<xsl:with-param name="sectkind" select="$kind"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	<!--xsl:value-of select="$newline"/-->
</xsl:template>

<xsl:template match="ulink">[<xsl:value-of select="@url"/><xsl:text> </xsl:text><xsl:value-of select="."/>]</xsl:template>

<!--xsl:template match="title">'''<xsl:value-of select="."/>'''</xsl:template-->

<xsl:template match="simplesect/title"></xsl:template>

<xsl:template match="programlisting">
	<xsl:value-of select="$newline"/>
	<xsl:if test="(ancestor::simplesect or ancestor::para) and not (ancestor::simplesect[ancestor::simplesect or ancestor::para])">
		<xsl:text>&lt;/p&gt;</xsl:text>
	</xsl:if>
		<!--xsl:apply-templates /-->
	<xsl:text>&lt;code&gt;</xsl:text>
	<xsl:apply-templates select="codeline"/><xsl:value-of select="$newline"/>
	<xsl:text>&lt;/code&gt;</xsl:text>
	<xsl:if test="(ancestor::simplesect or ancestor::para) and not (ancestor::simplesect[ancestor::simplesect or ancestor::para])">
		<xsl:text>&lt;p&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="codeline">
	<xsl:value-of select="$newline"/><xsl:text> </xsl:text><xsl:apply-templates /><!--xsl:text>&lt;br/&gt;</xsl:text-->
</xsl:template>

<xsl:template match="highlight/sp"><xsl:text> </xsl:text></xsl:template>

<xsl:template match="includes">
	<xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
	<xsl:text> </xsl:text><xsl:text>&lt;code&gt;&lt;nowiki&gt;#include &lt;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&gt;&lt;/nowiki&gt;&lt;/code&gt;</xsl:text>
</xsl:template>

<!--xsl:template match="name">
	<xsl:if test=".!='@0'">
	<xsl:apply-templates /><xsl:text> </xsl:text>
	</xsl:if>
</xsl:template-->

<xsl:template match="enumvalue">
	<xsl:value-of select="$newline"/>
	<xsl:text>*</xsl:text>
	<!--xsl:text> </xsl:text-->
	<xsl:text>&lt;span id="</xsl:text>
	<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
	<xsl:text>"&gt;&lt;/span&gt;</xsl:text>
	<xsl:text>'''&lt;code&gt;</xsl:text>
	<xsl:apply-templates select="name|initializer"/>
	<xsl:text>&lt;/code&gt;'''</xsl:text>
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="briefdescription/para"/>
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="memberdef[@kind='enum']">
	<xsl:value-of select="$newline"/>
	<xsl:text>&lt;span id="</xsl:text>
	<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
	<xsl:text>"&gt;&lt;/span&gt;</xsl:text>
	<xsl:value-of select="name"/>
	<xsl:text>''' </xsl:text>
	<xsl:apply-templates select="briefdescription/para" />
	<xsl:apply-templates select="detaileddescription/para" />
	<xsl:apply-templates select="enumvalue"/>
</xsl:template>

<xsl:template match="parametername">
	<xsl:text>| width="40" valign="top" align="right" | </xsl:text>
	<xsl:if test="@direction">
		<xsl:text>&#91;''</xsl:text><xsl:value-of select="@direction"/><xsl:text>''&#93; - </xsl:text>
	</xsl:if>
	<xsl:value-of select="$newline"/>
	<xsl:text>| valign="top" | '''</xsl:text><xsl:apply-templates /><xsl:text>''' </xsl:text>
</xsl:template>

<xsl:template match="parameternamelist">
	<xsl:value-of select="$newline"/>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template name="paramlist">
<!--парсим параметры и делаем ссылки-->
	<xsl:for-each select="param">
		<xsl:if test="position()=1">
			<xsl:text>(</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="."/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:for-each>

	<!-- Если параметров нету, то рисуем argsstring. Там скобки пустые, если это функция
		или аргументы, например, если typedef-->
	<xsl:if test="(not(param) or param='') and argsstring">
		<xsl:apply-templates select="argsstring"/>
	</xsl:if>
</xsl:template>

<xsl:template match="parameterlist[@kind='param']">
	<xsl:value-of select="$newline"/>
	<xsl:text>'''Аргументы:'''</xsl:text><xsl:value-of select="$newline"/>
	<xsl:text>{|</xsl:text><xsl:value-of select="$newline"/>
	<xsl:for-each select="parameteritem">
		<xsl:text>|-</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="."/>
		<xsl:value-of select="$newline"/>
	</xsl:for-each>
	<xsl:text>|}</xsl:text>
</xsl:template>

<xsl:template match="listitem">
	<xsl:value-of select="$newline"/>
	<xsl:for-each select="ancestor::listitem">
		<xsl:text>*</xsl:text>
	</xsl:for-each>
	<xsl:text>* </xsl:text>
	<xsl:apply-templates/>
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="itemizedlist">
	<xsl:value-of select="$newline"/>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="memberdef[@kind='function' or @kind='variable' or @kind='typedef' or @kind='define']">
	<xsl:param name="pname" />
	<xsl:value-of select="$newline"/>
	<xsl:text>=== </xsl:text>
	<xsl:if test="@kind='typedef'">''typedef''&#160;</xsl:if>
	<xsl:if test="@kind='define'">
		<xsl:text>#define</xsl:text>
		<xsl:text>&#160;</xsl:text>
	</xsl:if>
	
	<xsl:if test="@virt='pure-virtual' or @virt='virtual'">
		<xsl:text>virtual </xsl:text>
	</xsl:if>

	<xsl:apply-templates select="type"/>
	<xsl:text>&lt;span id="</xsl:text>
	<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
	<xsl:text>"&gt;&lt;/span&gt;</xsl:text>
	<!--xsl:value-of select="ancestor::compounddef/compoundname" />
	<xsl:text>::</xsl:text-->
	<xsl:value-of select="name"/>
	<xsl:text>''' </xsl:text>

	<!--парсим параметры и делаем ссылки-->
	<xsl:call-template name="paramlist"/>

	<xsl:text>'''</xsl:text>

	<xsl:apply-templates select="exceptions"/>
	<!-- Если это define, его тело не постим -->
	<xsl:if test="initializer!='' and @kind!='define'"><xsl:apply-templates select="initializer"/></xsl:if>

	<xsl:text> ===</xsl:text>
	<xsl:value-of select="$newline"/>
	<xsl:if test="@inline='yes'">
		<xsl:value-of select="$newline"/>
		<xsl:text>''Данная функция/метод является inline функцией''</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:if>
	<!--xsl:if test="@virt='pure-virtual' or @virt='virtual'">
		<xsl:value-of select="$newline"/>
		<xsl:text>''Данная функция/метод является virtual функцией''</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:if-->
	<xsl:if test="@prot='private'">
		<xsl:value-of select="$newline"/>
		<xsl:text>''Данный метод является приватным''</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:if>
	<xsl:if test="briefdescription/para">
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="briefdescription/para" />
	</xsl:if>
	<xsl:if test="detaileddescription/para">
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="detaileddescription/para" />
	</xsl:if>
	<!--xsl:apply-templates select="*[not(self::briefdescription/para)]"/-->
</xsl:template>

<xsl:template name="enum-short">
	<xsl:value-of select="$newline"/>
	<xsl:text>'''Перечисление </xsl:text>
	<xsl:text>[[#</xsl:text>
	<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
	<xsl:text>|</xsl:text><xsl:value-of select="name"/>
	<xsl:text>]]''' </xsl:text>
	<xsl:text> { </xsl:text>
	<xsl:for-each select="enumvalue">
		<xsl:text>'''[[#</xsl:text>
		<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
		<xsl:text>|</xsl:text><xsl:value-of select="name"/>
		<xsl:text>]]''' </xsl:text><xsl:value-of select="initializer"/>
		<xsl:text>, </xsl:text>
	</xsl:for-each>
	<xsl:text> }</xsl:text>
	<xsl:if test="briefdescription/para">
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="briefdescription"/>
		<xsl:value-of select="$newline"/>
	</xsl:if>
</xsl:template>

<xsl:template match="defval">
	<xsl:text> = </xsl:text>
	<xsl:apply-templates />
</xsl:template>


<xsl:template match="type">
	<xsl:variable name="typestr"><xsl:value-of select="string()"/></xsl:variable>
	<xsl:if test="$typestr!=''">
		<xsl:variable name="endchar1"><xsl:value-of select="substring-after($typestr, '&amp;')"/></xsl:variable>
		<xsl:variable name="endchar2"><xsl:value-of select="substring-after($typestr, '**')"/></xsl:variable>
		<xsl:apply-templates />
		<!--xsl:call-template name="replace-all">
			<xsl:with-param name="text" select="text()"/>
			<xsl:with-param name="replace" select="' '"/>
			<xsl:with-param name="by" select="'&#160;'"/>
		</xsl:call-template-->
		<!--xsl:value-of select="$endchar1"/>
		<xsl:value-of select="$endchar2"/-->
		<!-- Если тип кончается на имперсанд или **, то не добавляем пробел -->
		<xsl:if test="(not(contains($typestr, '**')) and ($endchar2 = '')) and (not(contains($typestr, '&amp;')) and ($endchar1 = ''))">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="param">
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="type" />
	<xsl:apply-templates select="declname" />
	<xsl:apply-templates select="defval" />
	<xsl:apply-templates select="defname" />
	<xsl:text> </xsl:text>
</xsl:template>

<xsl:template name="short-table-head">
	<xsl:value-of select="$newline"/>
	<xsl:text>| align="right" valign="top" | </xsl:text>
	<xsl:text>   </xsl:text>
</xsl:template>
<xsl:template name="short-table-middle">
	<xsl:value-of select="$newline"/>
	<xsl:text> | width="100%" valign="top" | </xsl:text>
</xsl:template>

<xsl:template match="templateparamlist">
	<xsl:for-each select="param">
		<xsl:text>''</xsl:text>
		<xsl:text>template&#160;&lt;</xsl:text>
		<xsl:call-template name="replace-all">
			<xsl:with-param name="text" select="."/>
			<xsl:with-param name="replace" select="' '"/>
			<xsl:with-param name="by" select="'&#160;'"/>
		</xsl:call-template>
		<xsl:text>&gt;''</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="class-short">
	<xsl:variable name="refid" select="@refid"/>
	<xsl:variable name="pclass" select="//compounddef[@id=$refid]"/>
	<xsl:variable name="ptype" select="$pclass/@kind"/>
	<xsl:call-template name="short-table-head"/>
	<xsl:apply-templates select="templateparamlist"/>
	<xsl:value-of select="$ptype"/><xsl:value-of select="$newline"/>
	<xsl:call-template name="short-table-middle"/>
	<xsl:call-template name="ref_class" select=".">
		<xsl:with-param name="linktoname" select="$pclass/compoundname"/>
		<xsl:with-param name="type" select="$pclass/@kind"/>
	</xsl:call-template>
	<xsl:value-of select="$newline"/>
	<xsl:apply-templates select="$pclass/briefdescription/para" />
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="func-short">
	<xsl:param name="type"/>
	<xsl:call-template name="short-table-head"/>

	<xsl:apply-templates select="templateparamlist"/>

	<xsl:if test="$type='typedef'">
		<xsl:text>''typedef''</xsl:text>
		<xsl:text>&#160;</xsl:text>
	</xsl:if>
	<xsl:if test="$type='define'">
		<xsl:text>#define</xsl:text>
		<xsl:text>&#160;</xsl:text>
	</xsl:if>

	<xsl:if test="$type='function' and (@virt='pure-virtual' or @virt='virtual')">
		<xsl:text>''virtual''</xsl:text>
		<xsl:text>&#160;</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="type"/>
	<xsl:call-template name="short-table-middle"/>
	<xsl:text>'''[[#</xsl:text>
	<xsl:call-template name="refanchor"><xsl:with-param name="text" select="@id"/></xsl:call-template>
	<xsl:text>|</xsl:text><xsl:value-of select="name"/>
	<xsl:text>]]''' </xsl:text>

	<xsl:call-template name="paramlist"/>
	
	<xsl:apply-templates select="exceptions"/>
	<!-- Если это define, его тело не постим -->
	<xsl:if test="initializer!='' and $type!='define'"><xsl:apply-templates select="initializer"/></xsl:if>

	<xsl:value-of select="$newline"/>
	<xsl:if test="briefdescription/para">
		<xsl:apply-templates select="briefdescription/para"/>
	</xsl:if>
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="short-function-table">
	<xsl:param name="type"/>
	<xsl:param name="selectdef"/>
	<!--xsl:value-of select="$selectdef"/>
	<xsl:for-each select="sectiondef/memberdef[@kind=$type and @prot='public']"-->
	
	<xsl:for-each select="$selectdef">
		<xsl:if test="position()=1">
			<xsl:text>{| width="100%" border="0" cellspacing=10</xsl:text>
			<xsl:value-of select="$newline"/>
		</xsl:if>
		<xsl:text>|-</xsl:text>
		<xsl:choose>
			<xsl:when test="$type='class'">
				<xsl:call-template name="class-short"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="func-short">
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">
			<xsl:text>----</xsl:text>
			<xsl:value-of select="$newline"/>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>|}</xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<xsl:template match="/doxygen">
<doc><pages type="Classes">
<!--xsl:for-each select="(compounddef[@kind='class' or @kind='namespace' or @kind='struct' or @kind='group' or @kind='file'][compoundname='isp_api::ExtTableNameListAction' or compoundname='module.h'])"-->
<xsl:for-each select="compounddef[@kind='class' or @kind='namespace' or @kind='struct' or @kind='group' or @kind='file']">
	<xsl:variable name="name"><xsl:value-of select="compoundname"/></xsl:variable>
	<xsl:variable name="classname">
		<xsl:choose>
			<xsl:when test="contains($name, '::')">
				<xsl:value-of select="substring-after($name, '::')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<page>
	<title>
	<xsl:choose>
		<xsl:when test="@kind='class'">
			<xsl:text>Class_</xsl:text><xsl:value-of select="$name"/>
		</xsl:when>
		<xsl:when test="@kind='namespace'">
			<xsl:text>Namespace_</xsl:text><xsl:value-of select="$name"/>
		</xsl:when>
		<xsl:when test="@kind='group'">
			<xsl:text>Group_</xsl:text><xsl:value-of select="$name"/>
		</xsl:when>
		<xsl:when test="@kind='struct'">
			<xsl:text>Struct_</xsl:text><xsl:value-of select="$name"/>
		</xsl:when>
		<xsl:when test="@kind='file'">
			<xsl:text>File_</xsl:text><xsl:value-of select="$name"/>
		</xsl:when>
	</xsl:choose>
	</title>
	<text>
	<xsl:choose>
		<xsl:when test="@kind='class' and not(templateparamlist)">
			<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
			<xsl:variable name="parentgroup" select="//compounddef[@kind='group' and innerclass[@refid=$id]]"/>
			<xsl:if test="$parentgroup!=''">
				<xsl:call-template name="ref_class">
					<xsl:with-param name="name" select="$parentgroup/title"/>
					<xsl:with-param name="linktoname" select="$parentgroup/compoundname"/>
					<xsl:with-param name="type" select="'group'"/>
				</xsl:call-template>
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="$newline"/>
			</xsl:if>
			<xsl:text>'''Класс </xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
			<xsl:if test="@abstract='yes'">
				<xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
				<xsl:text>''Данный класс является абстрактным''</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="@kind='class' and templateparamlist!=''">
			<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
			<xsl:variable name="parentgroup" select="//compounddef[@kind='group' and innerclass[@refid=$id]]"/>
			<xsl:if test="$parentgroup!=''">
				<xsl:call-template name="ref_class">
					<xsl:with-param name="name" select="$parentgroup/title"/>
					<xsl:with-param name="linktoname" select="$parentgroup/compoundname"/>
					<xsl:with-param name="type" select="'group'"/>
				</xsl:call-template>
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="$newline"/>
			</xsl:if>
			<xsl:text>'''Шаблон класса </xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
			<xsl:if test="@abstract='yes'">
				<xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
				<xsl:text>''Данный класс является абстрактным''</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="@kind='namespace'">
			<xsl:text>'''Пространство имён </xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='group'">
			<xsl:text>'''</xsl:text><xsl:value-of select="title"/><xsl:text>'''</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='struct'">
			<xsl:text>'''Структура </xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='struct'">
			<xsl:text>'''Файл </xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
	<xsl:if test="briefdescription/para">
		<xsl:apply-templates select="briefdescription/para" />
		<xsl:if test="includes"><xsl:apply-templates select="includes"/></xsl:if>
	</xsl:if>

	<!-- Выбираем нужные секции -->
	<!-- Перечисления -->
	<xsl:variable name="enums" select="sectiondef/memberdef[@kind='enum' and @prot='public']"/>

	<!-- Типы -->
	<xsl:variable name="types" select="sectiondef/memberdef[@kind='typedef' and @prot='public']"/>

	<!-- Аттрибуты -->
	<xsl:variable name="attribs" select="sectiondef[@kind='public-attrib']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='variable' and @prot='public' and (not(@static='yes'))]"/>

	<!-- Статические аттрибуты -->
	<xsl:variable name="stattribs" select="sectiondef[@kind='public-attrib' or @kind='public-static-attrib']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='variable' and @prot='public' and @static='yes']"/>

	<!-- Переменные -->
	<xsl:variable name="vars" select="sectiondef[@kind='var']/memberdef[(briefdescription!='' or detaileddescription!='') and @prot='public']"/>

	<!-- Классы -->
	<xsl:variable name="classes" select="innerclass | innergroup | innernamespace"/>

	<!-- Конструкторы -->
	<xsl:variable name="constructs" select="sectiondef[@kind='public-func']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='function'][(substring-after(name,'~')=$classname) or (name=$classname)]"/>


	<!--xsl:choose>
		<xsl:when test="@kind='group'">
			<xsl:variable name="functions" select="sectiondef[@kind='user-defined' or @kind='func' or @kind='public-func']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='function' and @prot='public']"/>
		</xsl:when>
		<xsl:when test="@kind='class'">
			
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="functions" select="sectiondef[@kind='user-defined' or @kind='func' or @kind='public-func']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='function' and @prot='public'][(substring-after(name,'~')!=$classname) and (name!=$classname)]"/>
		</xsl:otherwise>
	</xsl:choose-->

	<!-- Методы/функции -->
	<xsl:variable name="functions" select="sectiondef[@kind='user-defined' or @kind='func' or @kind='public-func']/memberdef[(briefdescription!='' or detaileddescription!='') and @kind='function' and @prot='public'][(ancestor::compounddef[@kind!='group'] and (substring-after(name,'~')!=$classname) and (name!=$classname)) or (ancestor::compounddef[@kind='group'])]"/>
	

	<!-- Данные -->
	<xsl:variable name="data" select="sectiondef/memberdef[(briefdescription!='' or detaileddescription!='') and @prot='public' and (@kind='variable')]"/>

	<!-- Макросы -->
	<xsl:variable name="define" select="sectiondef/memberdef[@prot='public' and (@kind='define')]"/>

	<xsl:if test="@kind='class' or detaileddescription/para">
		<xsl:value-of select="$newline"/><xsl:text>'''Описание:'''</xsl:text><xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
			<xsl:if test="templateparamlist">
				<xsl:apply-templates select="templateparamlist"/>
			</xsl:if>
			<xsl:value-of select="@kind"/>
			<xsl:text> '''</xsl:text><xsl:value-of select="$name"/><xsl:text>'''</xsl:text>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="detaileddescription/para" />
	</xsl:if>

	<!-- Родители -->
	<xsl:variable name="parents" select="basecompoundref"/>

	<!-- Потомки -->
	<xsl:variable name="children" select="derivedcompoundref"/>

	<xsl:if test="$parents">
		<xsl:value-of select="$newline"/><xsl:text>'''Родители:'''</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$parents"/>
		<xsl:value-of select="$newline"/>
	</xsl:if>

	<xsl:if test="$children">
		<xsl:value-of select="$newline"/><xsl:text>'''Потомки:'''</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$children"/>
		<xsl:value-of select="$newline"/>
	</xsl:if>

	<xsl:if test="$define">
		<xsl:value-of select="$newline"/><xsl:text>== Макросы ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'define'"/>
			<xsl:with-param name="selectdef" select="$define"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$classes">
		<xsl:value-of select="$newline"/><xsl:text>== Классы ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'class'"/>
			<xsl:with-param name="selectdef" select="$classes"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$types">
		<xsl:value-of select="$newline"/><xsl:text>== Открытые типы (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'typedef'"/>
			<xsl:with-param name="selectdef" select="$types"/>
		</xsl:call-template>
	</xsl:if>


	<xsl:if test="$enums">
		<xsl:value-of select="$newline"/><xsl:text>== Перечисления (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:for-each select="$enums">
			<xsl:call-template name="enum-short" />
			<!--xsl:if test="position() != last()"><xsl:value-of select="$newline"/><xsl:text>-1-1-1-</xsl:text><xsl:value-of select="$newline"/></xsl:if-->
		</xsl:for-each>
	</xsl:if>

	<xsl:if test="$attribs">
		<xsl:value-of select="$newline"/><xsl:text>== Открытые аттрибуты (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'variable'"/>
			<xsl:with-param name="selectdef" select="$attribs"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="sectiondef[@kind='public-func' or @kind='func']">
		<xsl:value-of select="$newline"/><xsl:text>== Открытые члены (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'function'"/>
			<xsl:with-param name="selectdef" select="sectiondef[@kind='public-func' or @kind='func']/memberdef[(briefdescription!='' or detaileddescription!='') and @prot='public']"/>
		</xsl:call-template>
		<xsl:for-each select="sectiondef[@kind='user-defined']">
			<xsl:value-of select="$newline"/><xsl:text>=== </xsl:text><xsl:value-of select="header"/><xsl:text> ===</xsl:text><xsl:value-of select="$newline"/>
			<xsl:apply-templates select="description"/>
			<xsl:value-of select="$newline"/>
			<xsl:call-template name="short-function-table">
				<xsl:with-param name="type" select="'function'"/>
				<xsl:with-param name="selectdef" select="memberdef[(briefdescription!='' or detaileddescription!='') and @kind='function' and @prot='public']"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:if>

	<xsl:if test="sectiondef[@kind='private-func']">
		<xsl:value-of select="$newline"/><xsl:text>== Приватные члены (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
			<xsl:with-param name="type" select="'function'"/>
			<xsl:with-param name="selectdef" select="sectiondef[@kind='private-func']/memberdef[@prot='private' and @virt='virtual' and (briefdescription!='' or detaileddescription!='')]"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$stattribs">
		<xsl:value-of select="$newline"/><xsl:text>== Статические открытые данные (кратко) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:call-template name="short-function-table">
				<xsl:with-param name="types" select="'variable'"/>
				<xsl:with-param name="selectdef" select="$stattribs"/>
		</xsl:call-template>
	</xsl:if>


	<xsl:if test="$enums">
		<xsl:value-of select="$newline"/><xsl:text>== Перечисления (подробно) ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:for-each select="$enums">
			<xsl:apply-templates select="."/>
			<xsl:if test="position() != last()"><xsl:value-of select="$newline"/><xsl:text>----</xsl:text><xsl:value-of select="$newline"/></xsl:if>
		</xsl:for-each>
	</xsl:if>


	<xsl:if test="$constructs">
		<xsl:value-of select="$newline"/><xsl:text>== Конструкторы ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$constructs" />
	</xsl:if>

	<xsl:if test="$functions or sectiondef[@kind='private-func']">
		<xsl:value-of select="$newline"/>
		<xsl:choose>
			<xsl:when test="@kind='class'">
				<xsl:text>== Методы ==</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>== Функции ==</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$functions"/>
		<xsl:apply-templates select="sectiondef[@kind='private-func']/memberdef[@prot='private' and @virt='virtual' and (briefdescription!='' or detaileddescription!='')]"/>
	</xsl:if>

	<!--xsl:if test="((sectiondef[@kind='public-attrib']) or (sectiondef[@kind='public-static-attrib']))">
		<xsl:value-of select="$newline"/><xsl:text>== Данные ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="sectiondef[@kind='public-attrib']/memberdef" />
		<xsl:apply-templates select="sectiondef[@kind='public-static-attrib']/memberdef" />
	</xsl:if-->

	<xsl:if test="$data">
		<xsl:value-of select="$newline"/><xsl:text>== Данные ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$data" />
	</xsl:if>

	<xsl:if test="$types">
		<xsl:value-of select="$newline"/><xsl:text>== Типы ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$types" />
	</xsl:if>

	<xsl:if test="$define">
		<xsl:value-of select="$newline"/><xsl:text>== Макросы ==</xsl:text><xsl:value-of select="$newline"/>
		<xsl:apply-templates select="$define" />
	</xsl:if>

	<xsl:value-of select="$newline"/>
	<xsl:text>[[Category:</xsl:text>
	<xsl:choose>
		<xsl:when test="@kind='class'">
			<xsl:text>Классы</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='namespace'">
			<xsl:text>Пространства имён</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='group'">
			<xsl:text>Группы</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='struct'">
			<xsl:text>Классы</xsl:text>
		</xsl:when>
		<xsl:when test="@kind='file'">
			<xsl:text>Файлы</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:text>]]</xsl:text>
	<xsl:text>[[Category:autogenerate]]</xsl:text>
	</text>
    </page>
  </xsl:for-each>
  </pages></doc>
</xsl:template>


<xsl:strip-space elements="* parameternamelist para linebreak/"/>
<xsl:preserve-space elements="type"/>

</xsl:stylesheet> 
