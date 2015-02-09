Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28599 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbbBITHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 14:07:20 -0500
Date: Mon, 9 Feb 2015 14:07:12 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix scrub race leading to use-after-free
To: Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1423508832.26622.2@mail.thefacebook.com>
In-Reply-To: <1422375078-6916-1-git-send-email-fdmanana@suse.com>
References: <1422375078-6916-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Jan 27, 2015 at 11:11 AM, Filipe Manana <fdmanana@suse.com> 
wrote:
> While running a scrub on a kernel with CONFIG_DEBUG_PAGEALLOC=y, I got
> the following trace:

This actually trades one bug for another:

[ 1928.950319] BUG: sleeping function called from invalid context at 
kernel/locking/mutex.c:621^M
[ 1928.967334] in_atomic(): 1, irqs_disabled(): 0, pid: 149670, name: 
fsstress^M
[ 1928.981324] INFO: lockdep is turned off.^M
[ 1928.989244] CPU: 24 PID: 149670 Comm: fsstress Tainted: G        W   
   3.19.0-rc7-mason+ #41^M
[ 1929.006418] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, 
BIOS 1.07 05/10/2012^M
[ 1929.022207]  ffffffff81a22cf8 ffff881076e03b78 ffffffff816b8dd9 
ffff881076e03b78^M
[ 1929.037267]  ffff880d8e828710 ffff881076e03ba8 ffffffff810856c4 
ffff881076e03bc8^M
[ 1929.052315]  0000000000000000 000000000000026d ffffffff81a22cf8 
ffff881076e03bd8^M
[ 1929.067381] Call Trace:^M
[ 1929.072344]  <IRQ>  [<ffffffff816b8dd9>] dump_stack+0x4f/0x6e^M
[ 1929.083968]  [<ffffffff810856c4>] ___might_sleep+0x174/0x230^M
[ 1929.095352]  [<ffffffff810857d2>] __might_sleep+0x52/0x90^M
[ 1929.106223]  [<ffffffff816bb68f>] mutex_lock_nested+0x2f/0x3b0^M
[ 1929.117951]  [<ffffffff810ab37d>] ? trace_hardirqs_on+0xd/0x10^M
[ 1929.129708]  [<ffffffffa05dc838>] scrub_pending_bio_dec+0x38/0x70 
[btrfs]^M
[ 1929.143370]  [<ffffffffa05dd0e0>] scrub_parity_bio_endio+0x50/0x70 
[btrfs]^M
[ 1929.157191]  [<ffffffff812fa603>] bio_endio+0x53/0xa0^M
[ 1929.167382]  [<ffffffffa05f96bc>] rbio_orig_end_io+0x7c/0xa0 
[btrfs]^M
[ 1929.180161]  [<ffffffffa05f97ba>] raid_write_parity_end_io+0x5a/0x80 
[btrfs]^M
[ 1929.194318]  [<ffffffff812fa603>] bio_endio+0x53/0xa0^M
[ 1929.204496]  [<ffffffff8130401b>] blk_update_request+0x1eb/0x450^M
[ 1929.216569]  [<ffffffff81096e58>] ? trigger_load_balance+0x78/0x500^M
[ 1929.229176]  [<ffffffff8144c74d>] scsi_end_request+0x3d/0x1f0^M
[ 1929.240740]  [<ffffffff8144ccac>] scsi_io_completion+0xac/0x5b0^M
[ 1929.252654]  [<ffffffff81441c50>] scsi_finish_command+0xf0/0x150^M
[ 1929.264725]  [<ffffffff8144d317>] scsi_softirq_done+0x147/0x170^M
[ 1929.276635]  [<ffffffff8130ace6>] blk_done_softirq+0x86/0xa0^M
[ 1929.288014]  [<ffffffff8105d92e>] __do_softirq+0xde/0x600^M
[ 1929.298885]  [<ffffffff8105df6d>] irq_exit+0xbd/0xd0^M
[ 1929.308879]  [<ffffffff81034ea5>] 
smp_call_function_single_interrupt+0x35/0x40^M
[ 1929.323455]  [<ffffffff816c126f>] 
call_function_single_interrupt+0x6f/0x80^M
[ 1929.337270]  <EOI>  [<ffffffff811fc745>] ? 
sync_inodes_sb+0x1b5/0x2a0^M
[ 1929.350261]  [<ffffffff811fc728>] ? sync_inodes_sb+0x198/0x2a0^M
[ 1929.361991]  [<ffffffff816badcf>] ? wait_for_completion+0xef/0x120^M
[ 1929.374423]  [<ffffffff812028d0>] ? fdatawrite_one_bdev+0x20/0x20^M
[ 1929.386671]  [<ffffffff812028d0>] ? fdatawrite_one_bdev+0x20/0x20^M
[ 1929.398930]  [<ffffffff812028ed>] sync_inodes_one_sb+0x1d/0x30^M
[ 1929.410668]  [<ffffffff811cf4c6>] iterate_supers+0xb6/0xf0^M
[ 1929.421712]  [<ffffffff81202935>] sys_sync+0x35/0x90^M
[ 1929.431704]  [<ffffffff816bfed2>] system_call_fastpath+0x12/0x17^M

So we'll have to either put in a refcount or a spinlock instead.

-chris

