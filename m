Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab2GENPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 09:15:36 -0400
Message-ID: <4FF595D8.6040509@cn.fujitsu.com>
Date: Thu, 05 Jul 2012 21:25:44 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device
 dm-0): Aborting unused transaction
References: <20120626193637.GA27856@merlins.org> <20120626193637.GA27856@merlins.org> <20120627013818.GA3556@merlins.org> <20120627052012.GA32533@merlins.org> <20120629123624.GS7472@merlins.org> <20120702195820.GA10655@merlins.org> <4FF3DB87.5090405@cn.fujitsu.com> <20120704151556.GD6807@merlins.org>
In-Reply-To: <20120704151556.GD6807@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2012 11:15 PM, Marc MERLIN wrote:

> On Wed, Jul 04, 2012 at 01:58:31PM +0800, Liu Bo wrote:
>> > The dmesg log, sysrq log and stack dump info can usually be very helpful.
>> > 
>> > From your report, we can see the csum error and hang on log,
>> > 'no csum' is not that bad while hanging-on is serious and dangerous.
>> > 
>> > so can you please get any 'sysrq + w' log in the hanging-on case and paste them here,
>> > and the log may tell us who blocks other threads.
> 
> Hi, thanks for the answer.
>  
> I dumped all sysrq data, that was in my original Email. Here are two
> different sysrq+w runs, as well as aborted transaction messages from that
> Email. 
> Sorry that the original was a bit long and contained a bunch of sysrq output.
> 
>>From doing further testing since then, it does seem that the code just start
> doing bad things, including the file corruption I saw, when I'm running low
> on free space.
> 
> Anything else that would help?
> 
> Thanks,
> Marc
> 


I'd expect to get some info from the following one, but I fails.

Is it reproducible on your box?

thanks,
liubo

> 
> Back to 3.2.16, I'm now seeing this:
> [  840.516733] INFO: task VirtualBox:6818 blocked for more than 120 seconds.
> [  840.516735] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  840.516736] VirtualBox      D ffff8801fd134080     0  6818   6758 0x00000080
> [  840.516740]  ffff8801fd134080 0000000000000086 0000000000000050 ffff880202e7f100
> [  840.516744]  0000000000013580 ffff8801c6f0dfd8 ffff8801c6f0dfd8 ffff8801fd134080
> [  840.516748]  ffff8801c6f0da68 ffff8801c6f0da68 ffff88020a4e22f0 ffff88023bc13e08
> [  840.516752] Call Trace:
> [  840.516755]  [<ffffffff810b5c67>] ? __lock_page+0x66/0x66
> [  840.516758]  [<ffffffff8134aea4>] ? io_schedule+0x58/0x6f
> [  840.516761]  [<ffffffff810b5c6d>] ? sleep_on_page+0x6/0xa
> [  840.516764]  [<ffffffff8134b1e5>] ? __wait_on_bit_lock+0x3c/0x85
> [  840.516767]  [<ffffffff810b5c62>] ? __lock_page+0x61/0x66
> [  840.516770]  [<ffffffff81060051>] ? autoremove_wake_function+0x2a/0x2a
> [  840.516785]  [<ffffffffa01838d7>] ? extent_write_cache_pages.isra.13.constprop.22+0xf6/0x278 [btrfs]
> [  840.516789]  [<ffffffff810ec9cb>] ? __cache_free.isra.40+0x19/0x1a7
> [  840.516792]  [<ffffffff8134ed52>] ? sub_preempt_count+0x83/0x94
> [  840.516795]  [<ffffffff8134c2dd>] ? _raw_spin_unlock+0x24/0x30
> [  840.516811]  [<ffffffffa0183c4b>] ? extent_writepages+0x40/0x57 [btrfs]
> [  840.516826]  [<ffffffffa0177f5f>] ? __btrfs_buffered_write+0x2bb/0x2dc [btrfs]
> [  840.516841]  [<ffffffffa016e88a>] ? uncompress_inline.isra.44+0x116/0x116 [btrfs]
> [  840.516844]  [<ffffffff810b6aaf>] ? __filemap_fdatawrite_range+0x4b/0x50
> [  840.516847]  [<ffffffff810b6ad9>] ? filemap_write_and_wait_range+0x25/0x4d
> [  840.516863]  [<ffffffffa01782ce>] ? btrfs_file_aio_write+0x34e/0x490 [btrfs]
> [  840.516866]  [<ffffffff8103e092>] ? get_parent_ip+0x9/0x1b
> [  840.516882]  [<ffffffffa0177f80>] ? __btrfs_buffered_write+0x2dc/0x2dc [btrfs]
> [  840.516886]  [<ffffffff8112f19c>] ? aio_rw_vect_retry+0x70/0x18e
> [  840.516888]  [<ffffffff8112f12c>] ? aio_fsync+0x22/0x22
> [  840.516891]  [<ffffffff8112fbc7>] ? aio_run_iocb+0x72/0x11c
> [  840.516894]  [<ffffffff81130d9a>] ? do_io_submit+0x6a4/0x7f9
> [  840.516898]  [<ffffffff813508d2>] ? system_call_fastpath+0x16/0x1b
> [ 1187.553635] btrfs: unlinked 8 orphans
> 

