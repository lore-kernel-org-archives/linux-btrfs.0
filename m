Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46893 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934133AbcATPQk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 10:16:40 -0500
Date: Wed, 20 Jan 2016 10:16:27 -0500
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
Message-ID: <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2016 at 03:46:26PM +0800, Zhao Lei wrote:
> reada create 2 works for each level of tree in recursion.
> 
> In case of a tree having many levels, the number of created works
> is 2^level_of_tree.
> Actually we don't need so many works in parallel, this patch limit
> max works to BTRFS_MAX_MIRRORS * 2.

Hi,

I don't think you end up calling atomic_dec() for every time that
reada_start_machine() is called.  Also, I'd rather not have a global
static variable to limit the parallel workers, when we have more than
one FS mounted it'll end up limiting things too much.

With this patch applied, I'm seeing deadlocks during btrfs/066.    You
have to run the scrub tests as well, basically we're just getting
fsstress run alongside scrub.

I'll run a few more times with it reverted to make sure, but I think
it's the root cause.

-----
stack summary

6 hits: 
[<ffffffff813ec92a>] wait_current_trans+0xca/0x140
[<ffffffff813ee248>] start_transaction+0x278/0x5b0
[<ffffffff813eea97>] btrfs_attach_transaction_barrier+0x27/0x60
[<ffffffff813b4835>] btrfs_sync_fs+0x85/0x1d0
[<ffffffff8122bcf0>] sync_fs_one_sb+0x20/0x30
[<ffffffff811f579f>] iterate_supers+0xaf/0xe0
[<ffffffff8122c1e5>] sys_sync+0x55/0x90
[<ffffffff819c00c7>] tracesys_phase2+0x84/0x89
[<ffffffffffffffff>] 0xffffffffffffffff

-----
1 hit:
[<ffffffff813ec92a>] wait_current_trans+0xca/0x140
[<ffffffff813ee248>] start_transaction+0x278/0x5b0
[<ffffffff813ee597>] btrfs_attach_transaction+0x17/0x20
[<ffffffff813e6b27>] transaction_kthread+0x1b7/0x290
[<ffffffff81082e09>] kthread+0xe9/0x110
[<ffffffff819c02ff>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff

-----
[<ffffffff814506cf>] btrfs_scrub_pause+0xdf/0x150
[<ffffffff813ed2f4>] btrfs_commit_transaction+0x3b4/0xc70
[<ffffffff81424724>] create_subvol+0x504/0x8d0
[<ffffffff81424c63>] btrfs_mksubvol+0x173/0x510
[<ffffffff8142511e>] btrfs_ioctl_snap_create_transid+0x11e/0x1a0
[<ffffffff814251fe>] btrfs_ioctl_snap_create+0x5e/0x80
[<ffffffff8142dbbb>] btrfs_ioctl+0xc6b/0x1190
[<ffffffff8120624a>] do_vfs_ioctl+0x8a/0x560
[<ffffffff812067b2>] SyS_ioctl+0x92/0xa0
[<ffffffff819c00c7>] tracesys_phase2+0x84/0x89
[<ffffffffffffffff>] 0xffffffffffffffff

-----
[<ffffffff81458d36>] btrfs_reada_wait+0x86/0xf0
[<ffffffff81456dc4>] scrub_stripe+0x274/0x1180
[<ffffffff81457de9>] scrub_chunk+0x119/0x160
[<ffffffff814581b7>] scrub_enumerate_chunks+0x387/0x730
[<ffffffff81458740>] btrfs_scrub_dev+0x1e0/0x620
[<ffffffff8142b7d1>] btrfs_ioctl_scrub+0xb1/0x120
[<ffffffff8142d970>] btrfs_ioctl+0xa20/0x1190
[<ffffffff8120624a>] do_vfs_ioctl+0x8a/0x560
[<ffffffff812067b2>] SyS_ioctl+0x92/0xa0
[<ffffffff819c00c7>] tracesys_phase2+0x84/0x89
[<ffffffffffffffff>] 0xffffffffffffffff

