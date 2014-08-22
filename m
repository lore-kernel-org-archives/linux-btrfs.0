Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47583 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaHVBwT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 21:52:19 -0400
Date: Thu, 21 Aug 2014 18:52:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Mihail Zaporozhets <kamheric@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs restore
Message-ID: <20140822015216.GE3875@merlins.org>
References: <loom.20140821T061503-238@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20140821T061503-238@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 05:52:01AM +0000, Mihail Zaporozhets wrote:
> # btrfs-zero-log /dev/sda1                         
> warning devid 5 not found already
> Check tree block failed, want=16845270495232, have=0
> read block failed check_tree_block
> Couldn't read tree root

You may be hitting the same problem I was a week back. See the thread
that says "btrfs-zero-log fails, can't mount FS"

Download the source for btrfs-progs, and apply this patch from Chris:

diff --git a/disk-io.c b/disk-io.c
index 8db0335..d9a8e19 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -911,13 +911,13 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
                        return -EIO;
        }
        fs_info->csum_root->track_dirty = 1;
-
+#if 0
        ret = find_and_setup_log_root(root, fs_info, sb);
        if (ret) {
                printk("Couldn't setup log root tree\n");
                return -EIO;
        }
-
+#endif
        fs_info->generation = generation;
        fs_info->last_trans_committed = generation;
        if (extent_buffer_uptodate(fs_info->extent_root->node) &&


Or if you're desparate and want a binary, I'll Email you one directly
(not that you should run a binary you got from someone via Email as
root, so it's only if you're desperate)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
