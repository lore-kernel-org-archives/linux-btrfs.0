From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/4] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Mon, 30 Apr 2012 18:41:39 +0200
Message-ID: <20120430164139.GB6740@twin.jikos.cz>
References: <4F98B9BC.7010905@gmail.com>
 <20120426114456.GN20982@twin.jikos.cz>
 <4F9A7B11.1020400@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>, miaox@cn.fujitsu.com,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>
To: Miao Xie <miaoxie1984@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F9A7B11.1020400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2012 at 06:55:13PM +0800, Miao Xie wrote:
> But I found you add a trylock for ->s_umount in cleaner_kthread(), this method
> can fix the deadlock problem, I think. It may be introduced by the other patch,
> could you send that patch to me? I found if we fail to trylock ->cleaner_mutex,
> we will forget to unlock ->s_umount.

the unlock was not visible within the diff context, the full patch is:

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1578,11 +1578,13 @@ static int cleaner_kthread(void *arg)
                vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);

                if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
+                       down_read_trylock(&root->fs_info->sb->s_umount) &&
                    mutex_trylock(&root->fs_info->cleaner_mutex)) {
                        btrfs_run_delayed_iputs(root);
                        btrfs_clean_old_snapshots(root);
                        mutex_unlock(&root->fs_info->cleaner_mutex);
                        btrfs_run_defrag_inodes(root->fs_info);
+                       up_read(&root->fs_info->sb->s_umount);
                }

                if (freezing(current)) {
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3413,7 +3413,9 @@ static int shrink_delalloc(struct btrfs_
                         max_reclaim >> PAGE_CACHE_SHIFT);
        while (loops < 1024) {
                /* have the flusher threads jump in and do some IO */
-               smp_mb();
+               if (btrfs_fs_closing(root->fs_info))
+                       return -EAGAIN;
+
                nr_pages = min_t(unsigned long, nr_pages,
                       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
                writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
---

after close_tree starts the "fs_closing" check will prevent further
calls to writeback. I don't remember from who the patch acutally comes
from (via irc), it was noted as a workaround for the cleaner deadlock
until it gets fully solved (re your patches
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg13897.html
and reference to balance and scrub:
http://www.spinics.net/lists/linux-btrfs/msg14056.html
)


david
