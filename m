Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:63446 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbcCRB0c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 21:26:32 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 12BF0AC0418
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:26:23 +0900 (JST)
Subject: [PATCH 1/5] btrfs-progs: "sub get-default" doesn't work
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56EB5937.8070208@jp.fujitsu.com>
Date: Fri, 18 Mar 2016 10:26:15 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/17 3:29, David Sterba wrote:
> Hi,
>
> btrfs-progs 4.5-rc1 have been released. The ETA for final release is this
> Friday, so please test and report if you find problems. Small fixes or
> documentation updates are welcome.

Please apply this patchset. Especially [1/5]~[4/5] fix
the regressions caused by the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

I read whole this commit carefully and probably fixed
all problems in this commit by 1a521af, c742deb,
and this patchset.

Satoru

---
"sub get-default" does't work from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

* actual result

   ==================================================
   # ./btrfs sub get-default /btrfs
   btrfs subvolume get-default: too few arguments
   usage: btrfs subvolume get-default <path>

       Get the default subvolume of a filesystem
   ==================================================

* expected result

   ==================================================
   # btrfs sub get-default /btrfs
   ID 5 (FS_TREE)
   ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel branch (commit: 40dc7c504cf0)
---
  cmds-subvolume.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 32caaa5..3953d7c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -790,7 +790,7 @@ static int cmd_subvol_get_default(int argc, char **argv)

  	clean_args_no_options(argc, argv, cmd_subvol_get_default_usage);

-	if (check_argc_exact(argc - optind, 2))
+	if (check_argc_exact(argc - optind, 1))
  		usage(cmd_subvol_get_default_usage);

  	subvol = argv[1];
-- 
2.7.0
