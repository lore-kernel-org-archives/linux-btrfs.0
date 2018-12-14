Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6A9C6786C
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 09:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B23920866
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 09:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="jUBOGuUK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B23920866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wpkg.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbeLNJR7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 04:17:59 -0500
Received: from mail.virtall.com ([46.4.129.203]:60970 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbeLNJR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 04:17:59 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 328041E2243
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 09:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1544779071; bh=bmfXG0CWQIWVAle7GpKMmIPXJTRb9aRurUxjC2GNMZY=;
        h=Date:From:To:Subject;
        b=jUBOGuUKjJbQ8WnKW5zv/dlYwpfQZUcRUbP2UOfwpH2U1OLFIMYlUo6I7AWnwsbog
         XARJR/RijttKorHAYwB67IaPDXzWWV1V7dl1MBrFqzeyKI9aahZh5dZkEIfPZgKNoN
         +ZCO9YbZtwx4xuO6EET8aoqJVjh3bFlrUuvQ5bnjwfHtVLZJ/1EnTH9cnhD4+Pj2gl
         hx10iYYZd+RKQW1weQWMvSAgjdPzbx45KjqWx4yM7ELSRfrielimA45DqohxPpKhXr
         IzQy/i9AXT1KltuaVU41/9UFrvmp2+dfnsQor15lV68GQy5Bvp0okOappelwC4YTbd
         fYZh3+VH12wug==
X-Fuglu-Suspect: d81a21edefdd4a21b42ab0d8688d0bbd
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 09:17:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Dec 2018 18:17:48 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: is it safe to run snapshots, btrfs send/receive when doing a scrub?
Message-ID: <000b6a2a1ae223a0e504e88e9ee242e5@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've started a scrub on a btrfs filesystem, then did btrfs send/receive 
a couple of gigabytes, made a few snapshots... Something strange 
happened to the filesystem.

rsync processes I run are hanging, "sync" never returns. Simple writes 
like "date > testfile.txt" work fine.
I've canceled the scrub, but the filesystem didn't "recover".

dmesg showed this:

Dec 13 19:28:09 samsung kernel: [16192.173280] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:28:09 samsung kernel: [16192.173292]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:28:09 samsung kernel: [16192.173296] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:28:09 samsung kernel: [16192.173302] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:28:09 samsung kernel: [16192.173309] Call Trace:
Dec 13 19:28:09 samsung kernel: [16192.173328]  __schedule+0x29e/0x840
Dec 13 19:28:09 samsung kernel: [16192.173336]  schedule+0x2c/0x80
Dec 13 19:28:09 samsung kernel: [16192.173413]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173421]  ? wait_woken+0x80/0x80
Dec 13 19:28:09 samsung kernel: [16192.173482]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173540]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173547]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:28:09 samsung kernel: [16192.173553]  ? __schedule+0x2a6/0x840
Dec 13 19:28:09 samsung kernel: [16192.173560]  ? schedule+0x2c/0x80
Dec 13 19:28:09 samsung kernel: [16192.173566]  ? 
schedule_timeout+0x258/0x360
Dec 13 19:28:09 samsung kernel: [16192.173615]  ? 
btrfs_async_run_delayed_refs+0x125/0x140 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173674]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173730]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173787]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173845]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173853]  ? wait_woken+0x20/0x80
Dec 13 19:28:09 samsung kernel: [16192.173910]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173917]  ? 
_cond_resched+0x19/0x30
Dec 13 19:28:09 samsung kernel: [16192.173975]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:28:09 samsung kernel: [16192.173985]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:28:09 samsung kernel: [16192.173992]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:28:09 samsung kernel: [16192.173997]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:28:09 samsung kernel: [16192.174005]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:28:09 samsung kernel: [16192.174010]  ksys_ioctl+0x67/0x90
Dec 13 19:28:09 samsung kernel: [16192.174015]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:28:09 samsung kernel: [16192.174020]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:28:09 samsung kernel: [16192.174027]  do_syscall_64+0x5a/0x110
Dec 13 19:28:09 samsung kernel: [16192.174032]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:28:09 samsung kernel: [16192.174038] RIP: 0033:0x7fef73dd13c7
Dec 13 19:28:09 samsung kernel: [16192.174051] Code: Bad RIP value.
Dec 13 19:28:09 samsung kernel: [16192.174054] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:28:09 samsung kernel: [16192.174060] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:28:09 samsung kernel: [16192.174062] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:28:09 samsung kernel: [16192.174065] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:28:09 samsung kernel: [16192.174067] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:28:09 samsung kernel: [16192.174070] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:30:09 samsung kernel: [16312.999726] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:30:09 samsung kernel: [16312.999736]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:30:09 samsung kernel: [16312.999739] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:30:09 samsung kernel: [16312.999744] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:30:09 samsung kernel: [16312.999749] Call Trace:
Dec 13 19:30:09 samsung kernel: [16312.999765]  __schedule+0x29e/0x840
Dec 13 19:30:09 samsung kernel: [16312.999772]  schedule+0x2c/0x80
Dec 13 19:30:09 samsung kernel: [16312.999834]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:30:09 samsung kernel: [16312.999841]  ? wait_woken+0x80/0x80
Dec 13 19:30:09 samsung kernel: [16312.999890]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:30:09 samsung kernel: [16312.999937]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:30:09 samsung kernel: [16312.999942]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:30:09 samsung kernel: [16312.999947]  ? __schedule+0x2a6/0x840
Dec 13 19:30:09 samsung kernel: [16312.999952]  ? schedule+0x2c/0x80
Dec 13 19:30:09 samsung kernel: [16312.999957]  ? 
schedule_timeout+0x258/0x360
Dec 13 19:30:09 samsung kernel: [16312.999996]  ? 
btrfs_async_run_delayed_refs+0x125/0x140 [btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000044]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000089]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000135]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000181]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000188]  ? wait_woken+0x20/0x80
Dec 13 19:30:09 samsung kernel: [16313.000234]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000240]  ? 
_cond_resched+0x19/0x30
Dec 13 19:30:09 samsung kernel: [16313.000286]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:30:09 samsung kernel: [16313.000294]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:30:09 samsung kernel: [16313.000300]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:30:09 samsung kernel: [16313.000303]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:30:09 samsung kernel: [16313.000309]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:30:09 samsung kernel: [16313.000314]  ksys_ioctl+0x67/0x90
Dec 13 19:30:09 samsung kernel: [16313.000318]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:30:09 samsung kernel: [16313.000322]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:30:09 samsung kernel: [16313.000328]  do_syscall_64+0x5a/0x110
Dec 13 19:30:09 samsung kernel: [16313.000332]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:30:09 samsung kernel: [16313.000336] RIP: 0033:0x7fef73dd13c7
Dec 13 19:30:09 samsung kernel: [16313.000347] Code: Bad RIP value.
Dec 13 19:30:09 samsung kernel: [16313.000350] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:30:09 samsung kernel: [16313.000354] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:30:09 samsung kernel: [16313.000356] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:30:09 samsung kernel: [16313.000358] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:30:09 samsung kernel: [16313.000360] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:30:09 samsung kernel: [16313.000362] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:32:10 samsung kernel: [16433.830255] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:32:10 samsung kernel: [16433.830267]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:32:10 samsung kernel: [16433.830270] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:32:10 samsung kernel: [16433.830275] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:32:10 samsung kernel: [16433.830282] Call Trace:
Dec 13 19:32:10 samsung kernel: [16433.830299]  __schedule+0x29e/0x840
Dec 13 19:32:10 samsung kernel: [16433.830307]  schedule+0x2c/0x80
Dec 13 19:32:10 samsung kernel: [16433.830375]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830383]  ? wait_woken+0x80/0x80
Dec 13 19:32:10 samsung kernel: [16433.830436]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830488]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830494]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:32:10 samsung kernel: [16433.830499]  ? __schedule+0x2a6/0x840
Dec 13 19:32:10 samsung kernel: [16433.830505]  ? schedule+0x2c/0x80
Dec 13 19:32:10 samsung kernel: [16433.830511]  ? 
schedule_timeout+0x258/0x360
Dec 13 19:32:10 samsung kernel: [16433.830554]  ? 
btrfs_async_run_delayed_refs+0x125/0x140 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830606]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830656]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830706]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830757]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830764]  ? wait_woken+0x20/0x80
Dec 13 19:32:10 samsung kernel: [16433.830815]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830821]  ? 
_cond_resched+0x19/0x30
Dec 13 19:32:10 samsung kernel: [16433.830873]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:32:10 samsung kernel: [16433.830881]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:32:10 samsung kernel: [16433.830888]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:32:10 samsung kernel: [16433.830892]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:32:10 samsung kernel: [16433.830899]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:32:10 samsung kernel: [16433.830904]  ksys_ioctl+0x67/0x90
Dec 13 19:32:10 samsung kernel: [16433.830908]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:32:10 samsung kernel: [16433.830913]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:32:10 samsung kernel: [16433.830919]  do_syscall_64+0x5a/0x110
Dec 13 19:32:10 samsung kernel: [16433.830924]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:32:10 samsung kernel: [16433.830928] RIP: 0033:0x7fef73dd13c7
Dec 13 19:32:10 samsung kernel: [16433.830941] Code: Bad RIP value.
Dec 13 19:32:10 samsung kernel: [16433.830944] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:32:10 samsung kernel: [16433.830948] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:32:10 samsung kernel: [16433.830951] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:32:10 samsung kernel: [16433.830953] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:32:10 samsung kernel: [16433.830955] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:32:10 samsung kernel: [16433.830958] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:35:01 samsung CRON[6452]: (root) CMD (command -v debian-sa1 > 
/dev/null && debian-sa1 1 1)
Dec 13 19:36:12 samsung kernel: [16675.491209] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:36:12 samsung kernel: [16675.491222]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:36:12 samsung kernel: [16675.491226] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:36:12 samsung kernel: [16675.491232] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:36:12 samsung kernel: [16675.491239] Call Trace:
Dec 13 19:36:12 samsung kernel: [16675.491258]  __schedule+0x29e/0x840
Dec 13 19:36:12 samsung kernel: [16675.491266]  schedule+0x2c/0x80
Dec 13 19:36:12 samsung kernel: [16675.491342]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491350]  ? wait_woken+0x80/0x80
Dec 13 19:36:12 samsung kernel: [16675.491410]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491468]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491479]  ? wait_woken+0x80/0x80
Dec 13 19:36:12 samsung kernel: [16675.491527]  ? 
btrfs_block_rsv_check+0x25/0x70 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491585]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491641]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491697]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491754]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491762]  ? wait_woken+0x20/0x80
Dec 13 19:36:12 samsung kernel: [16675.491819]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491826]  ? 
_cond_resched+0x19/0x30
Dec 13 19:36:12 samsung kernel: [16675.491884]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:36:12 samsung kernel: [16675.491894]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:36:12 samsung kernel: [16675.491901]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:36:12 samsung kernel: [16675.491906]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:36:12 samsung kernel: [16675.491913]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:36:12 samsung kernel: [16675.491919]  ksys_ioctl+0x67/0x90
Dec 13 19:36:12 samsung kernel: [16675.491924]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:36:12 samsung kernel: [16675.491930]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:36:12 samsung kernel: [16675.491937]  do_syscall_64+0x5a/0x110
Dec 13 19:36:12 samsung kernel: [16675.491942]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:36:12 samsung kernel: [16675.491947] RIP: 0033:0x7fef73dd13c7
Dec 13 19:36:12 samsung kernel: [16675.491960] Code: Bad RIP value.
Dec 13 19:36:12 samsung kernel: [16675.491964] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:36:12 samsung kernel: [16675.491969] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:36:12 samsung kernel: [16675.491972] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:36:12 samsung kernel: [16675.491974] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:36:12 samsung kernel: [16675.491977] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:36:12 samsung kernel: [16675.491979] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:38:13 samsung kernel: [16796.321667] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:38:13 samsung kernel: [16796.321679]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:38:13 samsung kernel: [16796.321683] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:38:13 samsung kernel: [16796.321689] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:38:13 samsung kernel: [16796.321696] Call Trace:
Dec 13 19:38:13 samsung kernel: [16796.321715]  __schedule+0x29e/0x840
Dec 13 19:38:13 samsung kernel: [16796.321723]  schedule+0x2c/0x80
Dec 13 19:38:13 samsung kernel: [16796.321799]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.321807]  ? wait_woken+0x80/0x80
Dec 13 19:38:13 samsung kernel: [16796.321868]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.321926]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:38:13 samsung kernel: [16796.321937]  ? wait_woken+0x80/0x80
Dec 13 19:38:13 samsung kernel: [16796.321986]  ? 
btrfs_block_rsv_check+0x25/0x70 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322044]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322099]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322156]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322213]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322221]  ? wait_woken+0x20/0x80
Dec 13 19:38:13 samsung kernel: [16796.322278]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322285]  ? 
_cond_resched+0x19/0x30
Dec 13 19:38:13 samsung kernel: [16796.322343]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322353]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:38:13 samsung kernel: [16796.322360]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:38:13 samsung kernel: [16796.322364]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:38:13 samsung kernel: [16796.322372]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:38:13 samsung kernel: [16796.322378]  ksys_ioctl+0x67/0x90
Dec 13 19:38:13 samsung kernel: [16796.322383]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:38:13 samsung kernel: [16796.322389]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:38:13 samsung kernel: [16796.322396]  do_syscall_64+0x5a/0x110
Dec 13 19:38:13 samsung kernel: [16796.322401]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:38:13 samsung kernel: [16796.322406] RIP: 0033:0x7fef73dd13c7
Dec 13 19:38:13 samsung kernel: [16796.322419] Code: Bad RIP value.
Dec 13 19:38:13 samsung kernel: [16796.322422] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:38:13 samsung kernel: [16796.322428] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:38:13 samsung kernel: [16796.322431] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:38:13 samsung kernel: [16796.322434] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:38:13 samsung kernel: [16796.322436] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:38:13 samsung kernel: [16796.322439] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:38:13 samsung kernel: [16796.322452] INFO: task btrfs:6309 
blocked for more than 120 seconds.
Dec 13 19:38:13 samsung kernel: [16796.322458]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:38:13 samsung kernel: [16796.322461] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:38:13 samsung kernel: [16796.322465] btrfs           D    0  
6309   6303 0x00000000
Dec 13 19:38:13 samsung kernel: [16796.322470] Call Trace:
Dec 13 19:38:13 samsung kernel: [16796.322477]  __schedule+0x29e/0x840
Dec 13 19:38:13 samsung kernel: [16796.322484]  schedule+0x2c/0x80
Dec 13 19:38:13 samsung kernel: [16796.322538]  
wait_for_commit+0x5e/0x90 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322545]  ? wait_woken+0x80/0x80
Dec 13 19:38:13 samsung kernel: [16796.322598]  
btrfs_commit_transaction+0x157/0x840 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322658]  
_btrfs_ioctl_set_received_subvol+0x1e9/0x330 [btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322666]  ? 
__check_object_size+0xaa/0x18a
Dec 13 19:38:13 samsung kernel: [16796.322724]  btrfs_ioctl+0x477/0x2ce0 
[btrfs]
Dec 13 19:38:13 samsung kernel: [16796.322729]  ? 
do_filp_open+0xa7/0x100
Dec 13 19:38:13 samsung kernel: [16796.322736]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:38:13 samsung kernel: [16796.322741]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:38:13 samsung kernel: [16796.322747]  ksys_ioctl+0x67/0x90
Dec 13 19:38:13 samsung kernel: [16796.322752]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:38:13 samsung kernel: [16796.322758]  do_syscall_64+0x5a/0x110
Dec 13 19:38:13 samsung kernel: [16796.322763]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:38:13 samsung kernel: [16796.322766] RIP: 0033:0x7f26f297e3c7
Dec 13 19:38:13 samsung kernel: [16796.322772] Code: Bad RIP value.
Dec 13 19:38:13 samsung kernel: [16796.322775] RSP: 
002b:00007ffd664df3a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:38:13 samsung kernel: [16796.322780] RAX: ffffffffffffffda 
RBX: 00007ffd664e1508 RCX: 00007f26f297e3c7
Dec 13 19:38:13 samsung kernel: [16796.322782] RDX: 00007ffd664df3c0 
RSI: 00000000c0c89425 RDI: 0000000000000006
Dec 13 19:38:13 samsung kernel: [16796.322785] RBP: 0000000000000006 
R08: 000055914f417920 R09: 0000000000000000
Dec 13 19:38:13 samsung kernel: [16796.322787] R10: 0000000000000000 
R11: 0000000000000246 R12: 00007ffd664df3c0
Dec 13 19:38:13 samsung kernel: [16796.322789] R13: 00007ffd664e35f8 
R14: 0000000000000000 R15: 0000000000000000
Dec 13 19:40:14 samsung kernel: [16917.152136] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:40:14 samsung kernel: [16917.152149]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:40:14 samsung kernel: [16917.152152] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:40:14 samsung kernel: [16917.152158] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:40:14 samsung kernel: [16917.152166] Call Trace:
Dec 13 19:40:14 samsung kernel: [16917.152185]  __schedule+0x29e/0x840
Dec 13 19:40:14 samsung kernel: [16917.152193]  schedule+0x2c/0x80
Dec 13 19:40:14 samsung kernel: [16917.152269]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152278]  ? wait_woken+0x80/0x80
Dec 13 19:40:14 samsung kernel: [16917.152337]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152395]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152406]  ? wait_woken+0x80/0x80
Dec 13 19:40:14 samsung kernel: [16917.152454]  ? 
btrfs_block_rsv_check+0x25/0x70 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152512]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152567]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152623]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152680]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152688]  ? wait_woken+0x20/0x80
Dec 13 19:40:14 samsung kernel: [16917.152744]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152751]  ? 
_cond_resched+0x19/0x30
Dec 13 19:40:14 samsung kernel: [16917.152809]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.152819]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:40:14 samsung kernel: [16917.152827]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:40:14 samsung kernel: [16917.152831]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:40:14 samsung kernel: [16917.152839]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:40:14 samsung kernel: [16917.152845]  ksys_ioctl+0x67/0x90
Dec 13 19:40:14 samsung kernel: [16917.152850]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:40:14 samsung kernel: [16917.152855]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:40:14 samsung kernel: [16917.152862]  do_syscall_64+0x5a/0x110
Dec 13 19:40:14 samsung kernel: [16917.152867]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:40:14 samsung kernel: [16917.152873] RIP: 0033:0x7fef73dd13c7
Dec 13 19:40:14 samsung kernel: [16917.152886] Code: Bad RIP value.
Dec 13 19:40:14 samsung kernel: [16917.152889] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:40:14 samsung kernel: [16917.152895] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:40:14 samsung kernel: [16917.152898] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:40:14 samsung kernel: [16917.152900] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:40:14 samsung kernel: [16917.152903] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:40:14 samsung kernel: [16917.152905] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40
Dec 13 19:40:14 samsung kernel: [16917.152918] INFO: task btrfs:6309 
blocked for more than 120 seconds.
Dec 13 19:40:14 samsung kernel: [16917.152924]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:40:14 samsung kernel: [16917.152927] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:40:14 samsung kernel: [16917.152932] btrfs           D    0  
6309   6303 0x00000000
Dec 13 19:40:14 samsung kernel: [16917.152936] Call Trace:
Dec 13 19:40:14 samsung kernel: [16917.152944]  __schedule+0x29e/0x840
Dec 13 19:40:14 samsung kernel: [16917.152951]  schedule+0x2c/0x80
Dec 13 19:40:14 samsung kernel: [16917.153004]  
wait_for_commit+0x5e/0x90 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153010]  ? wait_woken+0x80/0x80
Dec 13 19:40:14 samsung kernel: [16917.153063]  
btrfs_commit_transaction+0x157/0x840 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153122]  
_btrfs_ioctl_set_received_subvol+0x1e9/0x330 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153130]  ? 
__check_object_size+0xaa/0x18a
Dec 13 19:40:14 samsung kernel: [16917.153188]  btrfs_ioctl+0x477/0x2ce0 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153193]  ? 
do_filp_open+0xa7/0x100
Dec 13 19:40:14 samsung kernel: [16917.153200]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:40:14 samsung kernel: [16917.153204]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:40:14 samsung kernel: [16917.153211]  ksys_ioctl+0x67/0x90
Dec 13 19:40:14 samsung kernel: [16917.153216]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:40:14 samsung kernel: [16917.153222]  do_syscall_64+0x5a/0x110
Dec 13 19:40:14 samsung kernel: [16917.153227]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:40:14 samsung kernel: [16917.153230] RIP: 0033:0x7f26f297e3c7
Dec 13 19:40:14 samsung kernel: [16917.153236] Code: Bad RIP value.
Dec 13 19:40:14 samsung kernel: [16917.153239] RSP: 
002b:00007ffd664df3a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:40:14 samsung kernel: [16917.153243] RAX: ffffffffffffffda 
RBX: 00007ffd664e1508 RCX: 00007f26f297e3c7
Dec 13 19:40:14 samsung kernel: [16917.153246] RDX: 00007ffd664df3c0 
RSI: 00000000c0c89425 RDI: 0000000000000006
Dec 13 19:40:14 samsung kernel: [16917.153248] RBP: 0000000000000006 
R08: 000055914f417920 R09: 0000000000000000
Dec 13 19:40:14 samsung kernel: [16917.153251] R10: 0000000000000000 
R11: 0000000000000246 R12: 00007ffd664df3c0
Dec 13 19:40:14 samsung kernel: [16917.153253] R13: 00007ffd664e35f8 
R14: 0000000000000000 R15: 0000000000000000
Dec 13 19:40:14 samsung kernel: [16917.153260] INFO: task rsync:6442 
blocked for more than 120 seconds.
Dec 13 19:40:14 samsung kernel: [16917.153265]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:40:14 samsung kernel: [16917.153268] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:40:14 samsung kernel: [16917.153272] rsync           D    0  
6442   6437 0x00000000
Dec 13 19:40:14 samsung kernel: [16917.153276] Call Trace:
Dec 13 19:40:14 samsung kernel: [16917.153283]  __schedule+0x29e/0x840
Dec 13 19:40:14 samsung kernel: [16917.153289]  ? 
ttwu_do_activate+0x67/0x90
Dec 13 19:40:14 samsung kernel: [16917.153296]  schedule+0x2c/0x80
Dec 13 19:40:14 samsung kernel: [16917.153348]  
wait_current_trans+0xd5/0x110 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153354]  ? wait_woken+0x80/0x80
Dec 13 19:40:14 samsung kernel: [16917.153408]  
start_transaction+0x330/0x410 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153461]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153515]  btrfs_create+0x59/0x200 
[btrfs]
Dec 13 19:40:14 samsung kernel: [16917.153521]  lookup_open+0x512/0x760
Dec 13 19:40:14 samsung kernel: [16917.153526]  path_openat+0x54d/0xe70
Dec 13 19:40:14 samsung kernel: [16917.153532]  ? 
generic_update_time+0xb6/0xd0
Dec 13 19:40:14 samsung kernel: [16917.153537]  do_filp_open+0x93/0x100
Dec 13 19:40:14 samsung kernel: [16917.153544]  ? __alloc_fd+0x46/0x140
Dec 13 19:40:14 samsung kernel: [16917.153550]  do_sys_open+0x184/0x210
Dec 13 19:40:14 samsung kernel: [16917.153556]  
__x64_sys_openat+0x20/0x30
Dec 13 19:40:14 samsung kernel: [16917.153562]  do_syscall_64+0x5a/0x110
Dec 13 19:40:14 samsung kernel: [16917.153567]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:40:14 samsung kernel: [16917.153570] RIP: 0033:0x7f841c794c7e
Dec 13 19:40:14 samsung kernel: [16917.153575] Code: Bad RIP value.
Dec 13 19:40:14 samsung kernel: [16917.153577] RSP: 
002b:00007ffece617df0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
Dec 13 19:40:14 samsung kernel: [16917.153582] RAX: ffffffffffffffda 
RBX: 000000000003a2f8 RCX: 00007f841c794c7e
Dec 13 19:40:14 samsung kernel: [16917.153584] RDX: 00000000000000c2 
RSI: 00007ffece61a0b0 RDI: 00000000ffffff9c
Dec 13 19:40:14 samsung kernel: [16917.153587] RBP: 0000000000000000 
R08: 0000000000000070 R09: 0000000000000000
Dec 13 19:40:14 samsung kernel: [16917.153589] R10: 0000000000000180 
R11: 0000000000000246 R12: 00007f841c83dd20
Dec 13 19:40:14 samsung kernel: [16917.153592] R13: 00000000000000c2 
R14: 00007ffece61a120 R15: 8421084210842109
Dec 13 19:42:14 samsung kernel: [17037.982247] INFO: task btrfs:5496 
blocked for more than 120 seconds.
Dec 13 19:42:14 samsung kernel: [17037.982259]       Not tainted 
4.19.9-041909-generic #201812130432
Dec 13 19:42:14 samsung kernel: [17037.982263] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 19:42:14 samsung kernel: [17037.982269] btrfs           D    0  
5496      1 0x00000000
Dec 13 19:42:14 samsung kernel: [17037.982276] Call Trace:
Dec 13 19:42:14 samsung kernel: [17037.982295]  __schedule+0x29e/0x840
Dec 13 19:42:14 samsung kernel: [17037.982303]  schedule+0x2c/0x80
Dec 13 19:42:14 samsung kernel: [17037.982380]  
__scrub_blocked_if_needed+0x79/0xd0 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982388]  ? wait_woken+0x80/0x80
Dec 13 19:42:14 samsung kernel: [17037.982448]  
scrub_pause_off+0x26/0x60 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982506]  scrub_stripe+0xbad/0xee0 
[btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982516]  ? wait_woken+0x80/0x80
Dec 13 19:42:14 samsung kernel: [17037.982565]  ? 
btrfs_block_rsv_check+0x25/0x70 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982622]  scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982677]  ? 
lookup_extent_mapping+0x13/0x20 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982733]  ? scrub_chunk+0xdc/0x140 
[btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982790]  
scrub_enumerate_chunks+0x276/0x5c0 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982798]  ? wait_woken+0x20/0x80
Dec 13 19:42:14 samsung kernel: [17037.982855]  
btrfs_scrub_dev+0x1a2/0x510 [btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982862]  ? 
_cond_resched+0x19/0x30
Dec 13 19:42:14 samsung kernel: [17037.982920]  btrfs_ioctl+0xf95/0x2ce0 
[btrfs]
Dec 13 19:42:14 samsung kernel: [17037.982930]  ? 
kmem_cache_alloc_node+0x1e0/0x210
Dec 13 19:42:14 samsung kernel: [17037.982937]  do_vfs_ioctl+0xa9/0x640
Dec 13 19:42:14 samsung kernel: [17037.982941]  ? 
do_vfs_ioctl+0xa9/0x640
Dec 13 19:42:14 samsung kernel: [17037.982949]  ? 
get_task_io_context+0x46/0x90
Dec 13 19:42:14 samsung kernel: [17037.982955]  ksys_ioctl+0x67/0x90
Dec 13 19:42:14 samsung kernel: [17037.982960]  ? 
__switch_to_asm+0x34/0x70
Dec 13 19:42:14 samsung kernel: [17037.982966]  
__x64_sys_ioctl+0x1a/0x20
Dec 13 19:42:14 samsung kernel: [17037.982973]  do_syscall_64+0x5a/0x110
Dec 13 19:42:14 samsung kernel: [17037.982978]  
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec 13 19:42:14 samsung kernel: [17037.982983] RIP: 0033:0x7fef73dd13c7
Dec 13 19:42:14 samsung kernel: [17037.982997] Code: Bad RIP value.
Dec 13 19:42:14 samsung kernel: [17037.983000] RSP: 
002b:00007fef73cbcd38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Dec 13 19:42:14 samsung kernel: [17037.983006] RAX: ffffffffffffffda 
RBX: 000055559f2582f0 RCX: 00007fef73dd13c7
Dec 13 19:42:14 samsung kernel: [17037.983008] RDX: 000055559f2582f0 
RSI: 00000000c400941b RDI: 0000000000000003
Dec 13 19:42:14 samsung kernel: [17037.983011] RBP: 0000000000000000 
R08: 00007fef73cbd700 R09: 0000000000000000
Dec 13 19:42:14 samsung kernel: [17037.983013] R10: 00007fef73cbd700 
R11: 0000000000000246 R12: 00007ffcfed69cae
Dec 13 19:42:14 samsung kernel: [17037.983016] R13: 00007ffcfed69caf 
R14: 0000000000000000 R15: 00007fef73cbce40




echo w > /proc/sysrq-trigger is showing this:



[65510.644705] sysrq: SysRq : Show Blocked State
[65510.644711]   task                        PC stack   pid father
[65510.644835] rsync           D    0  7683   7680 0x00000000
[65510.644838] Call Trace:
[65510.644845]  __schedule+0x29e/0x840
[65510.644847]  schedule+0x2c/0x80
[65510.644850]  io_schedule+0x16/0x40
[65510.644853]  wait_on_page_bit+0xf7/0x140
[65510.644855]  ? page_cache_tree_insert+0xe0/0xe0
[65510.644879]  prepare_pages+0x24a/0x260 [btrfs]
[65510.644894]  btrfs_buffered_write.isra.28+0x257/0x760 [btrfs]
[65510.644909]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.644912]  __vfs_write+0x131/0x190
[65510.644914]  vfs_write+0xab/0x1b0
[65510.644916]  ksys_write+0x55/0xc0
[65510.644917]  __x64_sys_write+0x1a/0x20
[65510.644919]  do_syscall_64+0x5a/0x110
[65510.644921]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.644923] RIP: 0033:0x7fcccfa40fd4
[65510.644927] Code: Bad RIP value.
[65510.644928] RSP: 002b:00007ffe8b6282e8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.644929] RAX: ffffffffffffffda RBX: 0000000000000024 RCX: 
00007fcccfa40fd4
[65510.644930] RDX: 0000000000000024 RSI: 00005650816d57b0 RDI: 
0000000000000001
[65510.644930] RBP: 00005650816d57b0 R08: 00007fcccfb1d8c0 R09: 
00007fcccf935b80
[65510.644931] R10: 000000000000000a R11: 0000000000000246 R12: 
00007fcccfb1c760
[65510.644932] R13: 0000000000000024 R14: 00007fcccfb182a0 R15: 
00007fcccfb17760
[65510.644936] rsync           D    0  9021   9017 0x00000000
[65510.644938] Call Trace:
[65510.644940]  __schedule+0x29e/0x840
[65510.644942]  ? insert_work+0x6c/0x80
[65510.644943]  schedule+0x2c/0x80
[65510.644945]  schedule_timeout+0x157/0x360
[65510.644948]  ? __next_timer_interrupt+0xd0/0xd0
[65510.644950]  io_schedule_timeout+0x1e/0x50
[65510.644952]  balance_dirty_pages+0x42c/0xd80
[65510.644955]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.644978]  btrfs_buffered_write.isra.28+0x4c7/0x760 [btrfs]
[65510.644994]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.644996]  __vfs_write+0x131/0x190
[65510.644998]  vfs_write+0xab/0x1b0
[65510.645000]  ksys_write+0x55/0xc0
[65510.645002]  __x64_sys_write+0x1a/0x20
[65510.645003]  do_syscall_64+0x5a/0x110
[65510.645005]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.645005] RIP: 0033:0x7f5562ba4fd4
[65510.645007] Code: Bad RIP value.
[65510.645008] RSP: 002b:00007fff273547b8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.645009] RAX: ffffffffffffffda RBX: 0000000000000039 RCX: 
00007f5562ba4fd4
[65510.645010] RDX: 0000000000000039 RSI: 000055930bfad8d0 RDI: 
0000000000000001
[65510.645010] RBP: 000055930bfad8d0 R08: 00007f5562c818c0 R09: 
00007f5562a99b80
[65510.645011] R10: 000000000000000a R11: 0000000000000246 R12: 
00007f5562c80760
[65510.645012] R13: 0000000000000039 R14: 00007f5562c7c2a0 R15: 
00007f5562c7b760
[65510.645017] rsync           D    0 19637  19635 0x00000000
[65510.645018] Call Trace:
[65510.645020]  __schedule+0x29e/0x840
[65510.645022]  schedule+0x2c/0x80
[65510.645023]  io_schedule+0x16/0x40
[65510.645025]  wait_on_page_bit+0xf7/0x140
[65510.645027]  ? page_cache_tree_insert+0xe0/0xe0
[65510.645042]  prepare_pages+0x24a/0x260 [btrfs]
[65510.645058]  btrfs_buffered_write.isra.28+0x257/0x760 [btrfs]
[65510.645074]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.645076]  __vfs_write+0x131/0x190
[65510.645078]  vfs_write+0xab/0x1b0
[65510.645079]  ksys_write+0x55/0xc0
[65510.645081]  __x64_sys_write+0x1a/0x20
[65510.645083]  do_syscall_64+0x5a/0x110
[65510.645084]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.645085] RIP: 0033:0x7feda0c00fd4
[65510.645086] Code: Bad RIP value.
[65510.645087] RSP: 002b:00007ffd4d030768 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.645088] RAX: ffffffffffffffda RBX: 0000000000000043 RCX: 
00007feda0c00fd4
[65510.645089] RDX: 0000000000000043 RSI: 00005562289b3640 RDI: 
0000000000000001
[65510.645089] RBP: 00005562289b3640 R08: 00007feda0cdd8c0 R09: 
00007feda0af5b80
[65510.645090] R10: 000000000000000a R11: 0000000000000246 R12: 
00007feda0cdc760
[65510.645091] R13: 0000000000000043 R14: 00007feda0cd82a0 R15: 
00007feda0cd7760
[65510.645095] rsync           D    0 20340  20338 0x00000000
[65510.645096] Call Trace:
[65510.645098]  __schedule+0x29e/0x840
[65510.645099]  ? insert_work+0x6c/0x80
[65510.645100]  schedule+0x2c/0x80
[65510.645102]  schedule_timeout+0x157/0x360
[65510.645104]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645106]  io_schedule_timeout+0x1e/0x50
[65510.645108]  balance_dirty_pages+0x42c/0xd80
[65510.645124]  ? insert_state+0xc2/0x110 [btrfs]
[65510.645127]  ? percpu_counter_add_batch+0x4b/0x60
[65510.645129]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645144]  btrfs_buffered_write.isra.28+0x4c7/0x760 [btrfs]
[65510.645160]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.645162]  ? sock_read_iter+0x90/0xe0
[65510.645164]  __vfs_write+0x131/0x190
[65510.645166]  vfs_write+0xab/0x1b0
[65510.645168]  ksys_write+0x55/0xc0
[65510.645170]  __x64_sys_write+0x1a/0x20
[65510.645171]  do_syscall_64+0x5a/0x110
[65510.645173]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.645173] RIP: 0033:0x7f42f5251fd4
[65510.645175] Code: Bad RIP value.
[65510.645176] RSP: 002b:00007fff421346f8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.645177] RAX: ffffffffffffffda RBX: 00007f42f1793010 RCX: 
00007f42f5251fd4
[65510.645177] RDX: 0000000000040000 RSI: 00007f42f1793010 RDI: 
0000000000000005
[65510.645178] RBP: 0000000000000000 R08: 0000000000000000 R09: 
00007f42f17ce5c0
[65510.645179] R10: 00000000ab1bc659 R11: 0000000000000246 R12: 
0000000000000005
[65510.645179] R13: 0000000000008030 R14: 0000000000004a47 R15: 
0000000000004a47
[65510.645184] rsync           D    0 20882  20880 0x00000000
[65510.645185] Call Trace:
[65510.645187]  __schedule+0x29e/0x840
[65510.645189]  ? insert_work+0x6c/0x80
[65510.645190]  schedule+0x2c/0x80
[65510.645192]  schedule_timeout+0x157/0x360
[65510.645194]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645196]  io_schedule_timeout+0x1e/0x50
[65510.645197]  balance_dirty_pages+0x42c/0xd80
[65510.645213]  ? insert_state+0xc2/0x110 [btrfs]
[65510.645216]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645231]  btrfs_buffered_write.isra.28+0x4c7/0x760 [btrfs]
[65510.645247]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.645249]  __vfs_write+0x131/0x190
[65510.645251]  vfs_write+0xab/0x1b0
[65510.645253]  ksys_write+0x55/0xc0
[65510.645255]  __x64_sys_write+0x1a/0x20
[65510.645256]  do_syscall_64+0x5a/0x110
[65510.645258]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.645258] RIP: 0033:0x7f7c9f13cfd4
[65510.645260] Code: Bad RIP value.
[65510.645261] RSP: 002b:00007ffe8f6a6ba8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.645262] RAX: ffffffffffffffda RBX: 00007f7c9bc14010 RCX: 
00007f7c9f13cfd4
[65510.645262] RDX: 0000000000040000 RSI: 00007f7c9bc14010 RDI: 
0000000000000005
[65510.645263] RBP: 0000000000000000 R08: 0000000000000000 R09: 
00007f7c9bc4bc80
[65510.645264] R10: 000000003fd6d4ca R11: 0000000000000246 R12: 
0000000000000005
[65510.645264] R13: 0000000000009eb8 R14: 00000000000083a0 R15: 
00000000000083a0
[65510.645268] kworker/u16:0   D    0 21171      2 0x80000000
[65510.645286] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.645287] Call Trace:
[65510.645289]  __schedule+0x29e/0x840
[65510.645290]  ? insert_work+0x6c/0x80
[65510.645292]  schedule+0x2c/0x80
[65510.645293]  schedule_timeout+0x157/0x360
[65510.645295]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645297]  io_schedule_timeout+0x1e/0x50
[65510.645299]  balance_dirty_pages+0x42c/0xd80
[65510.645300]  ? __schedule+0x2a6/0x840
[65510.645301]  ? ttwu_do_activate+0x67/0x90
[65510.645314]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.645317]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645331]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.645345]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.645360]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.645375]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.645391]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.645407]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.645408]  process_one_work+0x20f/0x410
[65510.645410]  worker_thread+0x34/0x400
[65510.645412]  kthread+0x120/0x140
[65510.645414]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.645415]  ? kthread_bind+0x40/0x40
[65510.645416]  ret_from_fork+0x35/0x40
[65510.645418] kworker/u16:7   D    0 21176      2 0x80000000
[65510.645435] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.645436] Call Trace:
[65510.645438]  __schedule+0x29e/0x840
[65510.645439]  ? insert_work+0x6c/0x80
[65510.645440]  schedule+0x2c/0x80
[65510.645442]  schedule_timeout+0x157/0x360
[65510.645444]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645446]  io_schedule_timeout+0x1e/0x50
[65510.645447]  balance_dirty_pages+0x42c/0xd80
[65510.645449]  ? __schedule+0x2a6/0x840
[65510.645462]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.645464]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645478]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.645492]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.645507]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.645522]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.645538]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.645554]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.645555]  process_one_work+0x20f/0x410
[65510.645556]  worker_thread+0x34/0x400
[65510.645558]  kthread+0x120/0x140
[65510.645559]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.645561]  ? kthread_bind+0x40/0x40
[65510.645562]  ret_from_fork+0x35/0x40
[65510.645564] kworker/u16:8   D    0 21193      2 0x80000000
[65510.645580] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.645581] Call Trace:
[65510.645583]  __schedule+0x29e/0x840
[65510.645584]  ? insert_work+0x6c/0x80
[65510.645585]  schedule+0x2c/0x80
[65510.645587]  schedule_timeout+0x157/0x360
[65510.645589]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645591]  io_schedule_timeout+0x1e/0x50
[65510.645592]  balance_dirty_pages+0x42c/0xd80
[65510.645594]  ? __schedule+0x2a6/0x840
[65510.645595]  ? ttwu_do_activate+0x67/0x90
[65510.645608]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.645610]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645624]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.645638]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.645653]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.645668]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.645684]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.645700]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.645701]  process_one_work+0x20f/0x410
[65510.645702]  worker_thread+0x34/0x400
[65510.645704]  kthread+0x120/0x140
[65510.645705]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.645707]  ? kthread_bind+0x40/0x40
[65510.645708]  ret_from_fork+0x35/0x40
[65510.645711] kworker/u16:10  D    0 21213      2 0x80000000
[65510.645727] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.645728] Call Trace:
[65510.645730]  __schedule+0x29e/0x840
[65510.645731]  ? insert_work+0x6c/0x80
[65510.645733]  schedule+0x2c/0x80
[65510.645734]  schedule_timeout+0x157/0x360
[65510.645736]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645738]  io_schedule_timeout+0x1e/0x50
[65510.645740]  balance_dirty_pages+0x42c/0xd80
[65510.645741]  ? __schedule+0x2a6/0x840
[65510.645742]  ? ttwu_do_activate+0x67/0x90
[65510.645755]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.645758]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645772]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.645786]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.645801]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.645816]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.645831]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.645847]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.645849]  process_one_work+0x20f/0x410
[65510.645850]  worker_thread+0x34/0x400
[65510.645852]  kthread+0x120/0x140
[65510.645853]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.645854]  ? kthread_bind+0x40/0x40
[65510.645856]  ret_from_fork+0x35/0x40
[65510.645858] kworker/u16:19  D    0 21231      2 0x80000000
[65510.645874] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.645875] Call Trace:
[65510.645877]  __schedule+0x29e/0x840
[65510.645878]  ? insert_work+0x6c/0x80
[65510.645879]  schedule+0x2c/0x80
[65510.645881]  schedule_timeout+0x157/0x360
[65510.645883]  ? __next_timer_interrupt+0xd0/0xd0
[65510.645885]  io_schedule_timeout+0x1e/0x50
[65510.645886]  balance_dirty_pages+0x42c/0xd80
[65510.645888]  ? __schedule+0x2a6/0x840
[65510.645889]  ? ttwu_do_activate+0x67/0x90
[65510.645901]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.645904]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.645918]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.645932]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.645947]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.645962]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.645977]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.645993]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.645994]  process_one_work+0x20f/0x410
[65510.645996]  worker_thread+0x34/0x400
[65510.645997]  kthread+0x120/0x140
[65510.645999]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.646000]  ? kthread_bind+0x40/0x40
[65510.646009]  ret_from_fork+0x35/0x40
[65510.646010] kworker/u16:24  D    0 21236      2 0x80000000
[65510.646026] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[65510.646027] Call Trace:
[65510.646028]  __schedule+0x29e/0x840
[65510.646029]  ? insert_work+0x6c/0x80
[65510.646031]  schedule+0x2c/0x80
[65510.646032]  schedule_timeout+0x157/0x360
[65510.646034]  ? __next_timer_interrupt+0xd0/0xd0
[65510.646036]  io_schedule_timeout+0x1e/0x50
[65510.646037]  balance_dirty_pages+0x42c/0xd80
[65510.646038]  ? __schedule+0x2a6/0x840
[65510.646050]  ? block_rsv_release_bytes+0x37/0x300 [btrfs]
[65510.646053]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.646066]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.646079]  btrfs_btree_balance_dirty_nodelay+0x10/0x20 [btrfs]
[65510.646093]  btrfs_finish_ordered_io+0x202/0x7a0 [btrfs]
[65510.646107]  finish_ordered_fn+0x15/0x20 [btrfs]
[65510.646122]  normal_work_helper+0xbd/0x2f0 [btrfs]
[65510.646137]  btrfs_endio_write_helper+0x12/0x20 [btrfs]
[65510.646138]  process_one_work+0x20f/0x410
[65510.646139]  worker_thread+0x34/0x400
[65510.646141]  kthread+0x120/0x140
[65510.646142]  ? pwq_unbound_release_workfn+0xd0/0xd0
[65510.646143]  ? kthread_bind+0x40/0x40
[65510.646144]  ret_from_fork+0x35/0x40
[65510.646149] rsync           D    0 21295  21293 0x00000000
[65510.646150] Call Trace:
[65510.646152]  __schedule+0x29e/0x840
[65510.646153]  ? insert_work+0x6c/0x80
[65510.646154]  schedule+0x2c/0x80
[65510.646156]  schedule_timeout+0x157/0x360
[65510.646158]  ? __next_timer_interrupt+0xd0/0xd0
[65510.646159]  io_schedule_timeout+0x1e/0x50
[65510.646161]  balance_dirty_pages+0x42c/0xd80
[65510.646162]  ? __schedule+0x2a6/0x840
[65510.646163]  ? ttwu_do_activate+0x67/0x90
[65510.646166]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.646179]  __btrfs_btree_balance_dirty+0x4e/0x60 [btrfs]
[65510.646193]  btrfs_btree_balance_dirty+0x13/0x20 [btrfs]
[65510.646207]  btrfs_create+0x105/0x200 [btrfs]
[65510.646208]  lookup_open+0x512/0x760
[65510.646210]  path_openat+0x54d/0xe70
[65510.646211]  do_filp_open+0x93/0x100
[65510.646214]  ? __alloc_fd+0x46/0x140
[65510.646215]  do_sys_open+0x184/0x210
[65510.646217]  __x64_sys_openat+0x20/0x30
[65510.646218]  do_syscall_64+0x5a/0x110
[65510.646219]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.646220] RIP: 0033:0x7f4768f4ec7e
[65510.646222] Code: Bad RIP value.
[65510.646222] RSP: 002b:00007fff99d6d6e0 EFLAGS: 00000246 ORIG_RAX: 
0000000000000101
[65510.646223] RAX: ffffffffffffffda RBX: 000000000003a2f8 RCX: 
00007f4768f4ec7e
[65510.646224] RDX: 00000000000000c2 RSI: 00007fff99d6f9a0 RDI: 
00000000ffffff9c
[65510.646225] RBP: 0000000000000000 R08: 0000000000000011 R09: 
0000000000000000
[65510.646225] R10: 0000000000000180 R11: 0000000000000246 R12: 
00007f4768ff7d20
[65510.646226] R13: 00000000000000c2 R14: 00007fff99d6f9b1 R15: 
8421084210842109
[65510.646231] rsync           D    0 21556  21539 0x00000000
[65510.646232] Call Trace:
[65510.646234]  __schedule+0x29e/0x840
[65510.646235]  ? insert_work+0x6c/0x80
[65510.646236]  schedule+0x2c/0x80
[65510.646238]  schedule_timeout+0x157/0x360
[65510.646240]  ? __next_timer_interrupt+0xd0/0xd0
[65510.646241]  io_schedule_timeout+0x1e/0x50
[65510.646243]  balance_dirty_pages+0x42c/0xd80
[65510.646246]  balance_dirty_pages_ratelimited+0x2c6/0x3c0
[65510.646260]  btrfs_buffered_write.isra.28+0x4c7/0x760 [btrfs]
[65510.646275]  btrfs_file_write_iter+0x3f6/0x590 [btrfs]
[65510.646277]  ? lru_cache_add_active_or_unevictable+0x39/0xb0
[65510.646279]  __vfs_write+0x131/0x190
[65510.646280]  vfs_write+0xab/0x1b0
[65510.646282]  ksys_write+0x55/0xc0
[65510.646284]  __x64_sys_write+0x1a/0x20
[65510.646285]  do_syscall_64+0x5a/0x110
[65510.646286]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.646287] RIP: 0033:0x7f1712f27fd4
[65510.646288] Code: Bad RIP value.
[65510.646289] RSP: 002b:00007ffcc20792a8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[65510.646290] RAX: ffffffffffffffda RBX: 0000000000000020 RCX: 
00007f1712f27fd4
[65510.646291] RDX: 0000000000000020 RSI: 0000558f42db2500 RDI: 
0000000000000001
[65510.646291] RBP: 0000558f42db2500 R08: 00007f17130048c0 R09: 
00007f1712e1cb80
[65510.646292] R10: 000000000000000a R11: 0000000000000246 R12: 
00007f1713003760
[65510.646293] R13: 0000000000000020 R14: 00007f1712fff2a0 R15: 
00007f1712ffe760
[65510.646295] sync            D    0 21598  21090 0x00000000
[65510.646296] Call Trace:
[65510.646298]  __schedule+0x29e/0x840
[65510.646299]  ? __switch_to_asm+0x40/0x70
[65510.646300]  schedule+0x2c/0x80
[65510.646302]  io_schedule+0x16/0x40
[65510.646303]  wait_on_page_bit_common+0xd8/0x160
[65510.646305]  ? page_cache_tree_insert+0xe0/0xe0
[65510.646306]  __filemap_fdatawait_range+0x100/0x160
[65510.646309]  filemap_fdatawait_keep_errors+0x1e/0x40
[65510.646311]  sync_inodes_sb+0x204/0x290
[65510.646314]  sync_inodes_one_sb+0x15/0x20
[65510.646315]  iterate_supers+0xaa/0x100
[65510.646316]  ? default_file_splice_write+0x30/0x30
[65510.646318]  ksys_sync+0x42/0xb0
[65510.646319]  __ia32_sys_sync+0xe/0x20
[65510.646320]  do_syscall_64+0x5a/0x110
[65510.646322]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[65510.646322] RIP: 0033:0x7fafc724e1e7
[65510.646324] Code: Bad RIP value.
[65510.646324] RSP: 002b:00007ffd03f81c68 EFLAGS: 00000246 ORIG_RAX: 
00000000000000a2
[65510.646325] RAX: ffffffffffffffda RBX: 00007ffd03f81d98 RCX: 
00007fafc724e1e7
[65510.646326] RDX: 00007fafc7324001 RSI: 0000000000000000 RDI: 
00007fafc72e94ad
[65510.646327] RBP: 0000000000000001 R08: 0000000000000000 R09: 
0000000000000000
[65510.646327] R10: 00007fafc72b7b10 R11: 0000000000000246 R12: 
0000000000000000
[65510.646328] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000000

