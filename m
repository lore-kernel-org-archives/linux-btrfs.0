From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROG][PATCH 1/7] Correct xstrip() function
Date: Wed, 02 Nov 2011 22:22:41 +0100
Message-ID: <1341299.kzfvzJ2fHp@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3874831.byIZ0vWVvh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: Hugo Mills <hugo@carfax.org.uk>, chris.mason@oracle.com,
	Arne Jansen <sensille@gmx.net>,
	Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3874831.byIZ0vWVvh
Content-Type: multipart/mixed; boundary="nextPart1540718.x5ZeP1y64k"
Content-Transfer-Encoding: 7Bit


--nextPart1540718.x5ZeP1y64k
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi all,

this is the first of 7 patches, which improve the man page of the btrfs 
command.
I added some basic text fro the man page for the "filesystem restriper *" and 
the "quota/qgroup *" commands. I put in CC the writer hoping that they will 
care to maintain aligned the documentation with the code.

These patches are base on the latest "Hugo Mills" integration branch.

This patch correct a bug in the xstrip() function, which prevented to erase the
 unneeded spaces.

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 helpextract.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/helpextract.c b/helpextract.c
index 9489ea0..a729074 100644
--- a/helpextract.c
+++ b/helpextract.c
@@ -38,20 +38,21 @@ static char *xstrip(char *s){
 
 	char *last=NULL;
 	char *first;
+	char prev;
 
 	while(*s && isspace(*s) ) s++;
 
 	first=s;
-
+	prev=*s;
 	while(*s){
-		if(isspace(*s)) last=s;
+		if(!isspace(prev) && isspace(*s)) last=s;
+		prev=*s;
 		s++;
 	}
 
 	if(last) *last=0;
 	return first;
 
-
 }
 
 static void addtuple(char *key, char *cmdline, char *short_help, 
@@ -184,7 +185,7 @@ static int search_in_file(char *nf){
 	return 0;
 }
 
-/* remove all the escape sequence excepet \\ */
+/* remove all the escape sequence except \\ */
 static char * my_escape(char *src, char *filters[] ){
 
 	static char buffer[LINEBUF*5];

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1540718.x5ZeP1y64k
Content-Disposition: attachment; filename="send-via-kmail-attach-32256-1320267544-26873.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-32256-1320267544-26873.msg"

diff --git a/helpextract.c b/helpextract.c
index 9489ea0..a729074 100644
--- a/helpextract.c
+++ b/helpextract.c
@@ -38,20 +38,21 @@ static char *xstrip(char *s){
 
 	char *last=NULL;
 	char *first;
+	char prev;
 
 	while(*s && isspace(*s) ) s++;
 
 	first=s;
-
+	prev=*s;
 	while(*s){
-		if(isspace(*s)) last=s;
+		if(!isspace(prev) && isspace(*s)) last=s;
+		prev=*s;
 		s++;
 	}
 
 	if(last) *last=0;
 	return first;
 
-
 }
 
 static void addtuple(char *key, char *cmdline, char *short_help, 
@@ -184,7 +185,7 @@ static int search_in_file(char *nf){
 	return 0;
 }
 
-/* remove all the escape sequence excepet \\ */
+/* remove all the escape sequence except \\ */
 static char * my_escape(char *src, char *filters[] ){
 
 	static char buffer[LINEBUF*5];


--nextPart1540718.x5ZeP1y64k--

--nextPart3874831.byIZ0vWVvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbShvwTxYT3FBRIRAiV4AKCDAEHfbMlrsIsIhGcP/nZHL/itEACcCf1J
qR3NPnq+69YqouCZmHNqhxY=
=jWcW
-----END PGP SIGNATURE-----

--nextPart3874831.byIZ0vWVvh--

