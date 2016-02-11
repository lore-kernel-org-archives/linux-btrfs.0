Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcBKTSn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 14:18:43 -0500
Date: Thu, 11 Feb 2016 11:18:30 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160211191741.GA4762@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
 <CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
 <CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
 <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 10, 2016 at 02:23:00PM -0700, Chris Murphy wrote:
> On Wed, Feb 10, 2016 at 1:39 PM, Михаил Гаврилов
> <mikhail.v.gavrilov@gmail.com> wrote:
> 
> 
> >
> > Here full log: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocked-2.txt
> >
> > I am so sorry if this log is useless.
> 
> Looks good to me. The blocked task happens out of no where with
> nothing reported for almost an hour before the blocking. And I see the
> sysrq: SysRq : Show Blocked State was issued and lots of information
> is in the file.
> 
> > If "sysrq" is needed enabled before hang then I need set this
> > permanently because as I said I not having exactly reproducing this.
> 
> echo 1 > /proc/sys/kernel/sysrq can happen anytime, it just enables
> sysrq triggering functions which on Fedora kernels is not enabled by
> default. The main thing is that the echo w to the sysrq trigger needs
> to happen at the time of the problem to show the state. You did that.
> Let's see what Liu Bo has to say about it.

Really appreciate for collecting these, it should be helpful.

Unfortunately I still could not figure out who's holding fs tree's root WRITE_LOCK so that others are blocked.

A possible bug in log code (the follwing patch addressed it),

- log_new_dir_dentries() is holding log tree's leaf READ_LOCK and may try
  to get fs tree's READ_LOCK via btrfs_iget() -> btrfs_lookup().
  (This is shown in the backtrac)

- btrfs_log_inode() can call btrfs_search_forward() to get fs tree's
  leaf READ_LOCK and then call copy_items() -> btrfs_insert_empty_items()
  to acquire WRITE_LOCK of log tree's leaf and leaf's parent.  
  (In the backtrace, this is blocked by item 1 because log_new_dir_dentries is
  holding a log tree leaf's READ_LOCK() which happens to be sibling to
  the leaf that btrfs_insert_empty_items() is accessing, when doing
  split_leaf() it needs to get the sibling's WRITE_LOCK(). )

Thanks,

-liubo

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 323e12c..4a64fdd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4956,6 +4956,7 @@ process_leaf:
 			if (di_key.type == BTRFS_ROOT_ITEM_KEY)
 				continue;
 
+			btrfs_release_path(path);
 			di_inode = btrfs_iget(root->fs_info->sb, &di_key,
 					      root, NULL);
 			if (IS_ERR(di_inode)) {
@@ -4971,7 +4972,6 @@ process_leaf:
 			ctx->log_new_dentries = false;
 			if (type == BTRFS_FT_DIR)
 				log_mode = LOG_INODE_ALL;
-			btrfs_release_path(path);
 			ret = btrfs_log_inode(trans, root, di_inode,
 					      log_mode, 0, LLONG_MAX, ctx);
 			iput(di_inode);


