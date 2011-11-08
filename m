From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/7][V2] btrfs-progs:  The man/btrfs.8.in man page is auto-generated
Date: Tue, 08 Nov 2011 23:12:25 +0100
Message-ID: <2497663.IDYgb5Sg8s@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart7343330.cjL0gPEhXi"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart7343330.cjL0gPEhXi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"



Warn that the man/btrfs.8.in man page is auto-generated

Signed off by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 26bd4f6..d6c840e 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -88,6 +88,11 @@
  * .\"
  * .\" Man page for the "btrfs" tool 
  * .\"
+ * .\" WARNING
+ * .\" WARNING This file is generated automatically. Don't edit, your change
+ * .\" WARNING will be lost. See the file btrfs.c for further information
+ * .\" WARNING 
+ * .\"
  * .SH NAME
  * btrfs \- control a btrfs filesystem
  ****/
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart7343330.cjL0gPEhXi
Content-Disposition: inline; filename="send-via-kmail-attach-27106-1320789397-5248.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-27106-1320789397-5248.msg"

diff --git a/btrfs.c b/btrfs.c
index 26bd4f6..d6c840e 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -88,6 +88,11 @@
  * .\"
  * .\" Man page for the "btrfs" tool 
  * .\"
+ * .\" WARNING
+ * .\" WARNING This file is generated automatically. Don't edit, your change
+ * .\" WARNING will be lost. See the file btrfs.c for further information
+ * .\" WARNING 
+ * .\"
  * .SH NAME
  * btrfs \- control a btrfs filesystem
  ****/
-- 
1.7.7.2

--nextPart7343330.cjL0gPEhXi--

