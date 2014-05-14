Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59600 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbaENM0r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 08:26:47 -0400
Message-ID: <5373616E.9070409@fb.com>
Date: Wed, 14 May 2014 08:28:30 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15rc5 deadlock
References: <20140514114027.GA32301@merlins.org>
In-Reply-To: <20140514114027.GA32301@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2014 07:40 AM, Marc MERLIN wrote:
> Got this soon after boot:
> 
> [  720.086389] INFO: task pidgin:11330 blocked for more than 120 seconds.
> [  720.086402]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
> [  720.086406] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  720.086411] pidgin          D 0000000000000004     0 11330   5187 0x00000080
> [  720.086423]  ffff8803d7233c30 0000000000000082 ffff8803d7233c00 ffff8803d7233fd8
> [  720.086433]  ffff8804066345d0 00000000000141c0 ffff88041e3141c0 ffff8804066345d0
> [  720.086441]  ffff8803d7233cd0 0000000000000002 ffffffff810fda1a ffff8803d7233c40
> [  720.086450] Call Trace:
> [  720.086468]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
> [  720.086494]  [<ffffffff8161c816>] schedule+0x73/0x75
> [  720.086502]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
> [  720.086510]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
> [  720.086519]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
> [  720.086528]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
> [  720.086536]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
> [  720.086544]  [<ffffffff81240c41>] lock_page+0x1e/0x21
> [  720.086553]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
> [  720.086562]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
> [  720.086573]  [<ffffffff813159e0>] ? debug_smp_processor_id+0x17/0x19
> [  720.086581]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
> [  720.086592]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
> [  720.086602]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
> [  720.086611]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
> [  720.086620]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
> [  720.086628]  [<ffffffff8123883d>] btrfs_sync_file+0x8b/0x2b3
> [  720.086636]  [<ffffffff8132042f>] ? __percpu_counter_add+0x8c/0xa6
> [  720.086647]  [<ffffffff81157087>] ? __sb_end_write+0x2d/0x5b
> [  720.086657]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
> [  720.086663]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
> [  720.086670]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
> [  720.086678]  [<ffffffff8117a5e2>] SyS_fsync+0x10/0x14
> [  720.086686]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f

I think Filipe fixed this one:

https://patchwork.kernel.org/patch/4143821/

-chris
