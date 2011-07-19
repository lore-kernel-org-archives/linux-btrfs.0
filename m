From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 3/6] helpextract: tool to extract the info for the help from
	the source.
Date: Tue, 19 Jul 2011 18:12:11 +0200
Message-ID: <20110719161211.3210.54842.stgit@venice.bhome>
References: <20110719161049.3210.54794.stgit@venice.bhome>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110719161049.3210.54794.stgit@venice.bhome>
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

It is created the file helpextract.c, which is the source for the tool
"helpextract". This program extract the info showed in the man page and
the help command from the sources comments.
---
 helpextract.c |  435 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 435 insertions(+), 0 deletions(-)
 create mode 100644 helpextract.c

diff --git a/helpextract.c b/helpextract.c
new file mode 100644
index 0000000..9489ea0
--- /dev/null
+++ b/helpextract.c
@@ -0,0 +1,435 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+
+#define PREFIX_MAN	"/**** man: "
+#define PREFIX_TEXT	"/**** text: "
+#define PREFIX_END 	" ****"
+#define PREFIX_SKIP	" * "
+
+#define LINEBUF		1024
+
+char **msgs=0;
+int nmsg=0;
+
+static char *xstrdup(char *str){
+	char	*new = strdup(str);
+	if(!new){
+		fprintf(stderr,"*** Memory allocation fail ! (xstrdup)\n");
+		exit(101);
+	}
+	return new;
+}
+
+static void *xrealloc(void *ptr, int newsize){
+	void *new = realloc(ptr, newsize);
+	if(!new){
+		fprintf(stderr,"*** Memory allocation fail ! (xrealloc)\n");
+		exit(101);
+	}
+	return new;
+
+
+}
+
+static char *xstrip(char *s){
+
+	char *last=NULL;
+	char *first;
+
+	while(*s && isspace(*s) ) s++;
+
+	first=s;
+
+	while(*s){
+		if(isspace(*s)) last=s;
+		s++;
+	}
+
+	if(last) *last=0;
+	return first;
+
+
+}
+
+static void addtuple(char *key, char *cmdline, char *short_help, 
+		char *long_help){
+
+	msgs = (char**)xrealloc(msgs, sizeof(char *)*(nmsg+1)*4);
+	
+	key = xstrip(key);
+
+	if( !long_help || !strcmp(long_help,"\n"))
+		long_help = short_help;
+	else if(!short_help || !strcmp(short_help, "\n"))
+		short_help = long_help;
+
+	msgs[nmsg*4] = key;
+	msgs[nmsg*4+1] = cmdline;
+	msgs[nmsg*4+2] = short_help;
+	msgs[nmsg*4+3] = long_help;
+	nmsg++;
+}
+
+
+static int search_in_file(char *nf){
+	char	buf[LINEBUF+1];
+	FILE	*fp;
+	int	status; 
+	char	*key=NULL;
+	char	*cmdline=NULL;
+	char	*short_help=NULL;
+	char	*long_help=NULL;
+
+	fp = fopen(nf,"r");
+	if(!fp){
+		int	e=errno;
+		fprintf(stderr, "*** Cannot open '%s'; error = %d - '%s'\n",
+			nf, e, strerror(e));
+		return -1;
+	}
+
+	status = 0;
+	while(fgets(buf,LINEBUF,fp)){
+	//	printf("status = %d, buf=%s",status, buf);
+	
+		if(status == 0){
+			if(!strncmp(buf,PREFIX_MAN, strlen(PREFIX_MAN)) ){
+				key = xstrdup(buf+strlen(PREFIX_MAN));
+				status++;
+			}else if(!strncmp(buf,PREFIX_TEXT, 
+					strlen(PREFIX_TEXT))){
+				key = xstrdup(buf+strlen(PREFIX_TEXT));
+				status=5;
+			}
+			continue;
+
+		}
+
+		if( !strncmp(buf,PREFIX_END, strlen(PREFIX_END)) || 
+				strncmp(buf, PREFIX_SKIP,2)){
+
+			addtuple(key, cmdline, short_help, long_help);
+			key = cmdline = short_help = long_help = 0;
+			status = 0;
+
+			continue;
+		} 
+		if( status == 2){
+			if(strlen(buf)>strlen(PREFIX_SKIP))
+				cmdline = xstrdup(buf+strlen(PREFIX_SKIP));
+			status++;
+			continue;
+		}
+		if( status == 4){
+			int len;
+			int len2;
+			char *p;
+
+			if(strlen(buf)<=strlen(PREFIX_SKIP)){
+				status++;
+				continue;
+			}
+			p=buf+3;
+			while(isspace(*p) && *p ) p++;
+			if(!*p){
+				status++;
+				continue;
+			}
+
+			len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+			if(short_help)
+				len = strlen(short_help);
+			else
+				len = 0;
+			short_help = (char*)xrealloc(short_help, len+len2+1);
+			strcpy(short_help+len,buf+strlen(PREFIX_SKIP));
+			continue;
+		}
+		if( status == 5){
+			int len;
+			int len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+			if(long_help)
+				len = strlen(long_help);
+			else
+				len = 0;
+			long_help = (char*)xrealloc(long_help, len+len2+1);
+			strcpy(long_help+len,buf+strlen(PREFIX_SKIP));
+			continue;
+		}
+		if( status == 1 || status == 3 ){
+			status++;
+			continue;
+		}
+
+		fprintf(stderr,"*** Internal error: status = %d\n",status);
+		exit(100);
+
+	}
+
+	if( status != 0 ){
+		fprintf(stderr,"*** Parse error: file = '%s', "
+				"status = %d at the end of file\n",
+				nf, status);
+		exit(100);
+
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
+/* remove all the escape sequence excepet \\ */
+static char * my_escape(char *src, char *filters[] ){
+
+	static char buffer[LINEBUF*5];
+
+	int	i=0;
+	while(*src){
+		int 	j;
+		int	next_char = *(src+1);
+		if(*src != '\\'){
+			buffer[i++]=*src++;
+			continue;
+		}
+		if(!next_char){
+			buffer[i++]=*src++;
+			continue;
+		}
+		if( !filters ){
+			src +=2;
+			continue;
+		}
+
+		j=0;
+		while(filters[j]){
+			if(filters[j][0] == next_char ){
+				strcpy(buffer+i, filters[j]+2);
+				i+=strlen(filters[j]+2);
+				break;
+			}
+			j++;
+		}
+		if(!filters[j]){
+			char *p=src;
+			int l=40;
+			fprintf(stderr, 
+				"Unknow escape sequence '\%c' in [\"",
+				next_char);
+			while(*p && l--) fputc(*p++, stderr);
+			fprintf(stderr, "\"...]\n");
+		}
+		src += 2;
+
+	}
+
+	buffer[i]=0;
+	return buffer;
+
+}
+
+static char * escape_c_array(char *src ){
+	static char *filters[]={
+
+		/* remove the all know esc-sequence */
+
+		"B ",	/* bold */
+		"b ",	/* end bold */
+		"I ",	/* italic */
+		"i ",	/* end italic */
+		"c ",	/* comment */
+		"P ",	/* start paragraph */
+		"p ",	/* indented paragraph */
+		"h ",	/* header */
+		"d ",	/* bold regular */
+		"e ",	/* bold */
+		"t ",	/* indented paragraph */
+		"w ",	/* move the left margin */
+		"q ",	/* move the left margin back */
+
+		"\\ \\\\",
+		"- -",
+
+		0
+	};
+
+	return my_escape(src, filters);
+}
+
+static char *escape_man_page(char *src){
+	/* from Gnu troff manual */
+	static char *filters[]={
+		"B \\fB",	/* bold */
+		"b \\fP",	/* end bold */
+		"I \\fI",	/* italic */
+		"i \\fP",	/* end italic */
+		"c .\\\"",	/* comment */
+		"P .PP",	/* start paragraph */
+		"p .TP",	/* indented paragraph */
+		"h .SH",	/* header */
+		"d .BR",	/* bold regular */
+		"e .B",		/* bold */
+		"t .IP",	/* indented paragraph */
+		"w .RS",	/* move the left margin */
+		"q .RE",	/* move the left margin back */
+
+		"- \\-",	/* escape the minus sign */
+		"\\ \\",
+
+		0
+	};
+
+	return my_escape(src, filters);
+}
+	
+
+static void dump_c_array(){
+
+	int	i;
+
+	printf("{");
+	for(i=0; i < nmsg*4 ; i++){
+		char *c = msgs[i];
+		int begin;
+
+		if(!(i%4) && strncmp(c,"btrfs ",5)){
+			i+=3;
+			continue;
+		}
+
+		if(i>0){
+			putchar(',');
+			if(!(i%4)) putchar('\n');
+		}
+
+		if(!c){
+			printf("\n  NULL");
+			continue;
+		}
+
+		c = escape_c_array(c);
+
+		begin = 1;
+		while( *c ){
+			if(begin)
+				printf("\n  \"");
+			begin = 0;
+			if( *c == '\n' ){
+				printf("\\n\"");
+				begin = 1;
+			}else if( *c == '"' ){
+				printf("\\\"");
+			}else{
+				putchar(*c);
+			}
+
+			c++;
+		}
+		if(!begin) putchar('"');
+	}
+	printf(",\n\n  ");
+	for(i=0; i < 4; i++){
+		if(i>0) putchar(',');
+		printf("NULL");
+	}
+	printf("\n}\n");
+
+}
+
+static int my_sort_cmp(const void *p1, const void *p2){
+	return strcmp(*(char**)p1, *(char **)p2);
+}
+
+static void my_sort(){
+	qsort(msgs, nmsg, sizeof(char*)*4, my_sort_cmp);
+}
+
+static int find_section(char *key){
+	int 	i;
+	for(i = 0 ; i < nmsg ; i++ )
+		if(!strcmp( msgs[i*4],key) )	return i;
+	
+	return -1;
+}
+
+static void dump_man_page(){
+
+	int	i, fmt;
+
+	i = find_section("man btrfs header");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	i = find_section("man btrfs synopsis");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	fmt = find_section("man btrfs synopsis format");
+	for(i = 0; i < nmsg && fmt>=0; i++ ){
+		if( strncmp("btrfs ",msgs[i*4], 6) ||
+		    !strcmp("btrfs introduction", msgs[i*4] ) ||
+		    !strcmp("btrfs notes", msgs[i*4] ) )
+		    		continue;
+
+		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]));
+	}
+
+	i = find_section("btrfs introduction");
+	if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+	
+	i = find_section("man btrfs commands");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	fmt = find_section("man btrfs command format");
+	for(i = 0; i < nmsg && fmt>=0; i++ ){
+
+		char big2[LINEBUF*5];
+		if( strncmp("btrfs ",msgs[i*4], 6) ||
+		    !strcmp("btrfs introduction", msgs[i*4] ) ||
+		    !strcmp("btrfs notes", msgs[i*4] ) )
+		    		continue;
+		
+		strcpy(big2, escape_man_page(msgs[i*4+3]));
+		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]), big2);
+
+	}
+
+	i = find_section("man btrfs notes");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	i = find_section("btrfs notes");
+	if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+
+	i = find_section("man btrfs footer");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+}
+
+static void usage(char *np){
+	printf("usage: %s --man-page|--c-array <file> [<file> [...]]\n", np);
+}
+
+int main(int argc, char **argv ){
+
+	int	i;
+	if( argc < 3 || ( strcmp(argv[1],"--man-page") && 
+			  strcmp(argv[1],"--c-array") )){
+		usage(argv[0]);
+		return 0;
+	}
+
+	for(i=2; i < argc ; i++)
+		search_in_file(argv[i]);
+
+	my_sort();
+
+	if(!strcmp(argv[1], "--man-page"))
+		dump_man_page();
+	else if (!strcmp(argv[1], "--c-array"))
+		dump_c_array();
+
+	return 0;
+
+}

