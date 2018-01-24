Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12723 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752223AbeAXDdO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 22:33:14 -0500
Date: Wed, 24 Jan 2018 11:33:08 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: remove spurious WARN_ON(ref->count < 0) in
 find_parent_nodes
Message-ID: <20180124033308.GF532@fnst.localdomain>
References: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
 <20180124032203.3dszkkof5f36qpmf@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180124032203.3dszkkof5f36qpmf@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 10:22:09PM -0500, Zygo Blaxell wrote:
>Until v4.14, this warning was very infrequent:
>
>	WARNING: CPU: 3 PID: 18172 at fs/btrfs/backref.c:1391 find_parent_nodes+0xc41/0x14e0
>	Modules linked in: [...]
>	CPU: 3 PID: 18172 Comm: bees Tainted: G      D W    L  4.11.9-zb64+ #1
>	Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, BIOS 2101    12/02/2014
>	Call Trace:
>	 dump_stack+0x85/0xc2
>	 __warn+0xd1/0xf0
>	 warn_slowpath_null+0x1d/0x20
>	 find_parent_nodes+0xc41/0x14e0
>	 __btrfs_find_all_roots+0xad/0x120
>	 ? extent_same_check_offsets+0x70/0x70
>	 iterate_extent_inodes+0x168/0x300
>	 iterate_inodes_from_logical+0x87/0xb0
>	 ? iterate_inodes_from_logical+0x87/0xb0
>	 ? extent_same_check_offsets+0x70/0x70
>	 btrfs_ioctl+0x8ac/0x2820
>	 ? lock_acquire+0xc2/0x200
>	 do_vfs_ioctl+0x91/0x700
>	 ? __fget+0x112/0x200
>	 SyS_ioctl+0x79/0x90
>	 entry_SYSCALL_64_fastpath+0x23/0xc6
>	 ? trace_hardirqs_off_caller+0x1f/0x140
>
>Starting with v4.14 (specifically 86d5f9944252 ("btrfs: convert prelimary
>reference tracking to use rbtrees")) the WARN_ON occurs three orders of
>magnitude more frequently--almost once per second while running workloads
>like bees.
>
>Replace the WARN_ON() with a comment rationale for its removal.
>The rationale is paraphrased from an explanation by Edmund Nadolski
><enadolski@suse.de> on the linux-btrfs mailing list.
>
>Fixes: 8da6d5815c59 ("Btrfs: added btrfs_find_all_roots()")
>Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>---
>v2: 
>	Replace WARN_ON with rationale instead of merely deleting it.
>	Trim irrelevant detail from the backtrace.  Add Fixes reference.
>	Fix subject line (missing "< 0").
>
> fs/btrfs/backref.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
>diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>index 7d0dc100a09a..06597c5f9f4b 100644
>--- a/fs/btrfs/backref.c
>+++ b/fs/btrfs/backref.c
>@@ -1263,7 +1263,16 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
> 	while (node) {
> 		ref = rb_entry(node, struct prelim_ref, rbnode);
> 		node = rb_next(&ref->rbnode);
>-		WARN_ON(ref->count < 0);
>+		/*
>+		 * ref->count < 0 can happen here if there are delayed
>+		 * refs with a node->action of BTRFS_DROP_DELAYED_REF.
>+		 * prelim_ref_insert() relies on this when merging
>+		 * identical refs to keep the overall count correct.
>+		 * prelim_ref_insert() will merge only those refs
>+		 * which compare identically.  Any refs having
>+		 * e.g. different offsets would not be merged,
>+		 * and would retain their original ref->count < 0.
>+		 */
> 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
> 			if (sc && sc->root_objectid &&
> 			    ref->root_id != sc->root_objectid) {
>-- 
>2.11.0
>




