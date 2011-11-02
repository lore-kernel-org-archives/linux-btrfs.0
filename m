From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROG][PATCH 2/7] helpextract.c: removed some static buffer
Date: Wed, 02 Nov 2011 22:23:10 +0100
Message-ID: <1538956.XgfiHE93Xx@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1887117.PrdS3ecU69"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1887117.PrdS3ecU69
Content-Type: multipart/mixed; boundary="nextPart1889778.LG8BkpJ9W1"
Content-Transfer-Encoding: 7Bit


--nextPart1889778.LG8BkpJ9W1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Removed some static buffer, and replaced by a dynamic memory allocation
in order to support bigger text.

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 helpextract.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/helpextract.c b/helpextract.c
index a729074..e708b9e 100644
--- a/helpextract.c
+++ b/helpextract.c
@@ -9,7 +9,7 @@
 #define PREFIX_END 	" ****"
 #define PREFIX_SKIP	" * "
 
-#define LINEBUF		1024
+#define LINEBUF		4024
 
 char **msgs=0;
 int nmsg=0;
@@ -188,7 +188,9 @@ static int search_in_file(char *nf){
 /* remove all the escape sequence except \\ */
 static char * my_escape(char *src, char *filters[] ){
 
-	static char buffer[LINEBUF*5];
+	char *buffer=NULL;
+
+	buffer = xrealloc(buffer, strlen(src)*2+1);
 
 	int	i=0;
 	while(*src){
@@ -387,14 +389,15 @@ static void dump_man_page(){
 	fmt = find_section("man btrfs command format");
 	for(i = 0; i < nmsg && fmt>=0; i++ ){
 
-		char big2[LINEBUF*5];
+		char *big2;
 		if( strncmp("btrfs ",msgs[i*4], 6) ||
 		    !strcmp("btrfs introduction", msgs[i*4] ) ||
 		    !strcmp("btrfs notes", msgs[i*4] ) )
 		    		continue;
 		
-		strcpy(big2, escape_man_page(msgs[i*4+3]));
+		big2 = xstrdup(escape_man_page(msgs[i*4+3]));
 		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]), big2);
+		free(big2);
 
 	}
 

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1889778.LG8BkpJ9W1
Content-Disposition: inline; filename="send-via-kmail-attach-3522-1320267550-26913.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-3522-1320267550-26913.msg"

diff --git a/helpextract.c b/helpextract.c
index a729074..e708b9e 100644
--- a/helpextract.c
+++ b/helpextract.c
@@ -9,7 +9,7 @@
 #define PREFIX_END 	" ****"
 #define PREFIX_SKIP	" * "
 
-#define LINEBUF		1024
+#define LINEBUF		4024
 
 char **msgs=0;
 int nmsg=0;
@@ -188,7 +188,9 @@ static int search_in_file(char *nf){
 /* remove all the escape sequence except \\ */
 static char * my_escape(char *src, char *filters[] ){
 
-	static char buffer[LINEBUF*5];
+	char *buffer=NULL;
+
+	buffer = xrealloc(buffer, strlen(src)*2+1);
 
 	int	i=0;
 	while(*src){
@@ -387,14 +389,15 @@ static void dump_man_page(){
 	fmt = find_section("man btrfs command format");
 	for(i = 0; i < nmsg && fmt>=0; i++ ){
 
-		char big2[LINEBUF*5];
+		char *big2;
 		if( strncmp("btrfs ",msgs[i*4], 6) ||
 		    !strcmp("btrfs introduction", msgs[i*4] ) ||
 		    !strcmp("btrfs notes", msgs[i*4] ) )
 		    		continue;
 		
-		strcpy(big2, escape_man_page(msgs[i*4+3]));
+		big2 = xstrdup(escape_man_page(msgs[i*4+3]));
 		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]), big2);
+		free(big2);
 
 	}
 


--nextPart1889778.LG8BkpJ9W1--

--nextPart1887117.PrdS3ecU69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbS+vwTxYT3FBRIRAqh8AJ9EkkzYhwsJKeV6bq7WH6ZYK50EZwCeMeYn
UlMAYrseZs3vWeOU6D6B4Mk=
=UfOs
-----END PGP SIGNATURE-----

--nextPart1887117.PrdS3ecU69--

