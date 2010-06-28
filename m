From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] Btrgs-progs: Define _GNU_SOURCE for strndup
Date: Mon, 28 Jun 2010 18:55:15 +0200
Message-ID: <1277744116-7805-1-git-send-regression-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes:

btrfs-list.c: Dans la fonction =C2=ABino_resolve=C2=BB :
btrfs-list.c:511: attention : d=C3=A9claration implicite de la fonction=
 =C2=AB =C2=ABstrndup=C2=BB =C2=BB
btrfs-list.c:511: attention : incompatible implicit declaration of buil=
t-in function =C2=ABstrndup=C2=BB
make: *** [btrfs-list.o] Erreur 1

and:

btrfs.c: Dans la fonction =C2=ABsplit_command=C2=BB :
btrfs.c:168: attention : d=C3=A9claration implicite de la fonction =C2=AB=
 =C2=ABstrndup=C2=BB =C2=BB
btrfs.c:168: attention : incompatible implicit declaration of built-in =
function =C2=ABstrndup=C2=BB
make: *** [btrfs.o] Erreur 1

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 btrfs-list.c |    1 +
 btrfs.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 7741705..9dedb5d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
=20
+#define _GNU_SOURCE
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
diff --git a/btrfs.c b/btrfs.c
index ab5e57f..672ffe2 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -15,6 +15,7 @@
  */
=20
=20
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
