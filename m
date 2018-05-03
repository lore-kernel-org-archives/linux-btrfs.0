Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbeECQpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 12:45:55 -0400
Date: Thu, 3 May 2018 18:43:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH] btrfs: qgroup: Fix root item corruption when multiple
 same source snapshiots are created with quota enabled
Message-ID: <20180503164316.GB21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171219074454.2874-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171219074454.2874-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 03:44:54PM +0800, Qu Wenruo wrote:
> When multiple pending snapshots referring the same source subvolume are
> executed, enabled quota will cause root item corruption, where root
> items are using old bytenr (no backref in extent tree).
> 
> This can be triggered by fstests btrfs/152.
> 
> The cause is when source subvolume is still dirty, extra commit
> (simplied transaction commit) of qgroup_account_snapshot() can skip
> dirty roots not recorded in current transaction, making root item of
> source subvolume not updated.
> 
> Fix it by forcing recording source subvolume in current transaction
> before qgroup sub-transaction commit.
> 
> Reported-by: Justin Maggard <jmaggard@netgear.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/transaction.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ddae813c01dd..f645e5de5fa5 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -319,7 +319,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>  	if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>  	    root->last_trans < trans->transid) || force) {
>  		WARN_ON(root == fs_info->extent_root);
> -		WARN_ON(root->commit_root != root->node);
> +		WARN_ON(!force && root->commit_root != root->node);

I see this warning in current misc-next, test btrfs/152. The warning
does not appear with reference master or 'to be sent as next pull
rquest' testing runs.

All the warnings seem to be the same, so I'm pasting the first one:

[ 7910.900575] WARNING: CPU: 3 PID: 12891 at fs/btrfs/transaction.c:303record_root_in_trans+0x40/0xe0 [btrfs]
[ 7910.973625] CPU: 3 PID: 12891 Comm: btrfs Tainted: G        W4.17.0-rc3-1.ge195904-vanilla+ #231
[ 7910.983421] Hardware name: empty empty/S3993, BIOS PAQEX0-302/24/2008
[ 7910.990140] RIP: 0010:record_root_in_trans+0x40/0xe0 [btrfs]
[ 7910.995967] RSP: 0018:ffffbc7b04f1ba50 EFLAGS: 00010202
[ 7911.001345] RAX: ffff963ef63bcd08 RBX: ffff963e069239d8 RCX:ffff963f0a89e7e8
[ 7911.008645] RDX: 0000000000000000 RSI: ffff963f0a89e7e8 RDI:ffff963f0278b028
[ 7911.015940] RBP: ffffbc7b04f1bb70 R08: ffff963e06923a10 R09:0000000000000001
[ 7911.023227] R10: 0000000000200000 R11: 0000000000000000 R12:ffff963f2247c000
[ 7911.030523] R13: ffff963f0b3e0008 R14: ffff963f0f9608c8 R15:ffff963f06561a60
[ 7911.037834] FS:  00007fa037b1d8c0(0000) GS:ffff963f26c00000(0000)knlGS:0000000000000000
[ 7911.047965] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7911.053871] CR2: 00007ffeb64a8000 CR3: 0000000213d7f000 CR4:00000000000006e0
[ 7911.061161] Call Trace:
[ 7911.063780]  create_pending_snapshot+0x1ff/0x1130 [btrfs]
[ 7911.069417]  ? create_pending_snapshots+0xab/0xd0 [btrfs]
[ 7911.075000]  create_pending_snapshots+0xab/0xd0 [btrfs]
[ 7911.080420]  btrfs_commit_transaction+0x2ac/0xa60 [btrfs]
[ 7911.086033]  btrfs_mksubvol+0x5e8/0x650 [btrfs]
[ 7911.090734]  ? mnt_want_write_file+0x3b/0xc0
[ 7911.095210]  btrfs_ioctl_snap_create_transid+0x16f/0x1a0 [btrfs]
[ 7911.101429]  btrfs_ioctl_snap_create_v2+0x102/0x150 [btrfs]
[ 7911.107209]  btrfs_ioctl+0x39b/0x29a0 [btrfs]
[ 7911.111730]  ? __slab_free+0xf9/0x2a0
[ 7911.115562]  ? trace_hardirqs_on_caller+0x105/0x1c0
[ 7911.120623]  ? do_vfs_ioctl+0x91/0x6b0
[ 7911.124511]  do_vfs_ioctl+0x91/0x6b0
[ 7911.128244]  ? kfree+0x259/0x310
[ 7911.131645]  ? syscall_trace_enter+0x1ce/0x3c0
[ 7911.136253]  ksys_ioctl+0x70/0x80
[ 7911.139721]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 7911.144592]  __x64_sys_ioctl+0x16/0x20
[ 7911.148491]  do_syscall_64+0x62/0x1c0
[ 7911.152300]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 7911.157503] RIP: 0033:0x7fa036bba417
[ 7911.161220] RSP: 002b:00007ffeb64ad058 EFLAGS: 00000246 ORIG_RAX:0000000000000010
[ 7911.169028] RAX: ffffffffffffffda RBX: 00007ffeb64c2370 RCX:00007fa036bba417
[ 7911.176316] RDX: 00007ffeb64ad0a0 RSI: 0000000050009417 RDI:0000000000000003
[ 7911.183606] RBP: 0000000000e63020 R08: 000000000000ffff R09:00007fa036e73698
[ 7911.190883] R10: 0000000000000000 R11: 0000000000000246 R12:0000000000e64260
[ 7911.198171] R13: 00007ffeb64ae1d0 R14: 000000000000000e R15:00007ffeb64ad0a0
[ 7911.224866] irq event stamp: 8428
[ 7911.228311] hardirqs last  enabled at (8427): [<ffffffffbd3017a0>]cmpxchg_double_slab.isra.42+0x190/0x1b0
[ 7911.238215] hardirqs last disabled at (8428): [<ffffffffbda011ac>]error_entry+0x6c/0xc0
[ 7911.246530] softirqs last  enabled at (8418): [<ffffffffbdc00452>]__do_softirq+0x452/0x7b4
[ 7911.255112] softirqs last disabled at (8393): [<ffffffffbd0b4043>]irq_exit+0xc3/0xf0
[ 7911.263167] ---[ end trace 0d6ecffc816873c4 ]---
