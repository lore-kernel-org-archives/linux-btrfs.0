From: Atila <atila.alr@dpf.gov.br>
Subject: [PATCH]Re: The first character disappears
Date: Thu, 27 Aug 2009 14:44:20 -0300
Message-ID: <4A96C5F4.4000500@dpf.gov.br>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com> <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com> <20090824115232.GC15449@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090824115232.GC15449@think>
List-ID: <linux-btrfs.vger.kernel.org>

Should be rstrip instead of strip.

Atila


Signed-off-by: Atila <atila.alr@dpf.gov.br>
---
  bcp |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bcp b/bcp
index 5729e91..7c6b351 100755
--- a/bcp
+++ b/bcp
@@ -107,7 +107,7 @@ if src_args > 1:
          exit(1)

  for srci in xrange(0, src_args):
-    src = args[srci]
+    src = args[srci].rstrip('/')
      if os.path.isfile(src):
          statinfo = os.lstat(src)
          force_name = None
@@ -136,7 +136,7 @@ for srci in xrange(0, src_args):
              srcname = os.path.join(dirpath, x)
              statinfo = os.lstat(srcname)

-            if srcname.startswith(src):
+            if srcname.startswith(src + '/'):
                  part = srcname[len(src) + 1:]

              if stat.S_ISLNK(statinfo.st_mode):
@@ -152,7 +152,7 @@ for srci in xrange(0, src_args):

          for f in filenames:
              srcname = os.path.join(dirpath, f)
-            if srcname.startswith(src):
+            if srcname.startswith(src + '/'):
                  part = srcname[len(src) + 1:]

              statinfo = os.lstat(srcname)
-- 
1.6.4

*

