Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59898 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaISIqA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 04:46:00 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 522F03EE0BB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:45:59 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 69D86AC06F7
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:45:58 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 135BE1DB8032
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:45:58 +0900 (JST)
Message-ID: <541BED3D.5020803@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 17:45:49 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/4] btrfs: correct empty compression property behavior
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

In the current implementation, compression property == "" has
the two different meanings: one is with BTRFS_INODE_NOCOMPRESS,
and the other is without this flag.

So, even if the two files a and b have the same compression
property, "", and the same contents, one file seems to be
compressed and the other is not. It's difficult to understand
for users and also confuses them.

Here is the real example. Let assume the following two cases.

  a) A file created freshly (under a directory without both
     COMPRESS and NOCOMPRESS flag.)

  b) A existing file which is explicitly set ""
     to compression property.

In addition, here is the command log (I attached the source of
"getflags" program in this patch.)

=======
$ rm -f a b; touch a b
$ btrfs prop set b compression ""
 # both a and b have the same compression property: ""
$ btrfs prop get a compression
$ btrfs prop get b compression
 # but ... let's take a look at inode flags
$ ./getflags a
0x0
$ ./getflags b
0x400             # 0x400 (FS_NOCOMP_FL) corresponds to BTRFS_INODE_NOCOMPRESS
=======

So both these two files have their compression property == "",
but have different NOCOMPRESS flag state leading to different
behavior.

case | BTRFS_INODE_NOCOMPRESS | behavior
=====+========================+=========================
   a | unset                  | might be compressed
   b | set                    | never be compressed

I consider that we should not expect users to remember
whether their files are case a or b and should introduce
another value for compress property anyway.

getflags.c:
===================
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <linux/fs.h>

int main(int argc, char const* argv[])
{
  const char *name = argv[1];
  int fd = open(name, O_RDONLY);
  long x;
  ioctl(fd, FS_IOC_GETFLAGS, &x);
  printf("0x%lx\n", x);
  return 0;
}
===================

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/props.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 129b1dd..bf005f4 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -393,8 +393,8 @@ static int prop_compression_apply(struct inode *inode,
 	int type;
 
 	if (len == 0) {
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
-		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
+		BTRFS_I(inode)->flags &=
+			~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
 
 		return 0;
-- 1.8.3.1 

