Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34993 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3CDITg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 03:19:36 -0500
Received: by mail-lb0-f178.google.com with SMTP id n1so3742120lba.37
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2013 00:19:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 09:19:34 +0100
Message-ID: <CAPsrAuCGwDCuWJ-NUt8vZGOgav779=KaF+32kf4A1bW7pZSF5g@mail.gmail.com>
Subject: WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90
 [btrfs]() [linux 3.8.0]
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I'm running currently a patched linux 3.8.0 kernel (SCST iscsi target
patches and STEC enhanceIO driver support)
I created a btrfs raid10 filesystem with "mkfs.btrfs -m raid10 -d
raid10 /dev/sdf /dev/sdg /dev/sdh /dev/sdi"
On this volume I added a sparse file and shared it over iscsi with
SCST, on the other side I ran an IOmeter test for a couple of hours.
This happened already twice on a new volume, so I guess we can reproduce it.
I've seen similar messages on the mailinglist for kernel 3.7.X and
also we get some CPU stuck messages.

2013-03-02T00:27:33.830960+01:
00 linux-testsan kernel: [29480.367902] WARNING: at
fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90 [btrfs]()
2013-03-02T00:27:33.830963+01:00 linux-testsan kernel: [29480.367910]
Hardware name: Veriton M67WS
2013-03-02T00:27:33.830965+01:00 linux-testsan kernel: [29480.367911]
Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O) enhanceio_lru
enhanceio_fifo enhanceio af_packet cpufreq_conservative cpufreq_use$
2013-03-02T00:27:33.830967+01:00 linux-testsan kernel: [29480.367969]
Pid: 12713, comm: disk010_7 Tainted: G        W  O
3.8.0-server-SCST-enhanceIO-1 #1
2013-03-02T00:27:33.830969+01:00 linux-testsan kernel: [29480.367971]
Call Trace:
2013-03-02T00:27:33.830970+01:00 linux-testsan kernel: [29480.367981]
[<ffffffff81004658>] dump_trace+0x78/0x2c0
2013-03-02T00:27:33.830972+01:00 linux-testsan kernel: [29480.367985]
[<ffffffff8155d276>] dump_stack+0x69/0x6f
2013-03-02T00:27:33.830974+01:00 linux-testsan kernel: [29480.367990]
[<ffffffff81043d29>] warn_slowpath_common+0x79/0xc0
2013-03-02T00:27:33.830975+01:00 linux-testsan kernel: [29480.368002]
[<ffffffffa041e96e>] free_extent_map+0x6e/0x90 [btrfs]
2013-03-02T00:27:33.830981+01:00 linux-testsan kernel: [29480.368083]
[<ffffffffa041bf3b>] btrfs_drop_extent_cache+0x35b/0x430 [btrfs]
2013-03-02T00:27:33.834940+01:00 linux-testsan kernel: [29480.368126]
[<ffffffffa04117c6>] __cow_file_range+0xe6/0x4b0 [btrfs]
2013-03-02T00:27:33.834948+01:00 linux-testsan kernel: [29480.368166]
[<ffffffffa0412755>] cow_file_range+0x95/0xf0 [btrfs]
2013-03-02T00:27:33.834949+01:00 linux-testsan kernel: [29480.368206]
[<ffffffffa0412b15>] run_delalloc_range+0x365/0x3a0 [btrfs]
2013-03-02T00:27:33.834951+01:00 linux-testsan kernel: [29480.368248]
[<ffffffffa0426829>] __extent_writepage+0x319/0x7b0 [btrfs]
2013-03-02T00:27:33.834952+01:00 linux-testsan kernel: [29480.368299]
[<ffffffffa0426f48>]
extent_write_cache_pages.isra.29.constprop.46+0x288/0x370 [btrfs]
2013-03-02T00:27:33.834954+01:00 linux-testsan kernel: [29480.368351]
[<ffffffffa042727c>] extent_writepages+0x4c/0x60 [btrfs]
2013-03-02T00:27:33.834955+01:00 linux-testsan kernel: [29480.368395]
[<ffffffff8110cb29>] __filemap_fdatawrite_range+0x49/0x50
2013-03-02T00:27:33.834971+01:00 linux-testsan kernel: [29480.368399]
[<ffffffff8110cb80>] filemap_write_and_wait_range+0x50/0x70
2013-03-02T00:27:33.834972+01:00 linux-testsan kernel: [29480.368410]
[<ffffffffa041a02b>] btrfs_sync_file+0x5b/0x240 [btrfs]
2013-03-02T00:27:33.834974+01:00 linux-testsan kernel: [29480.368453]
[<ffffffffa041ba15>] btrfs_file_aio_write+0x405/0x5d0 [btrfs]
2013-03-02T00:27:33.834975+01:00 linux-testsan kernel: [29480.368489]
[<ffffffff8116cfb8>] do_sync_readv_writev+0x88/0xc0
2013-03-02T00:27:33.834976+01:00 linux-testsan kernel: [29480.368492]
[<ffffffff8116d29f>] do_readv_writev+0xcf/0x1f0
2013-03-02T00:27:33.834977+01:00 linux-testsan kernel: [29480.368497]
[<ffffffffa05b9a34>] fileio_exec_write+0x284/0x4e0 [scst_vdisk]
2013-03-02T00:27:33.834978+01:00 linux-testsan kernel: [29480.368507]
[<ffffffffa05b43a8>] vdev_do_job+0x18/0xa0 [scst_vdisk]
2013-03-02T00:27:33.834979+01:00 linux-testsan kernel: [29480.368517]
[<ffffffffa0546a95>] scst_do_real_exec+0x55/0x1b0 [scst]
2013-03-02T00:27:33.834980+01:00 linux-testsan kernel: [29480.368525]
[<ffffffffa0548de0>] scst_exec_check_blocking+0xa0/0x100 [scst]
2013-03-02T00:27:33.834982+01:00 linux-testsan kernel: [29480.368535]
[<ffffffffa054957a>] scst_process_active_cmd+0xea/0x1720 [scst]
2013-03-02T00:27:33.834983+01:00 linux-testsan kernel: [29480.368544]
[<ffffffffa054ac04>] scst_do_job_active+0x54/0x70 [scst]
2013-03-02T00:27:33.834984+01:00 linux-testsan kernel: [29480.368554]
[<ffffffffa054ad6d>] scst_cmd_thread+0xfd/0x340 [scst]
2013-03-02T00:27:33.834985+01:00 linux-testsan kernel: [29480.368562]
[<ffffffff81066183>] kthread+0xb3/0xc0
2013-03-02T00:27:33.834986+01:00 linux-testsan kernel: [29480.368566]
[<ffffffff8157047c>] ret_from_fork+0x7c/0xb0
2013-03-02T00:27:33.834987+01:00 linux-testsan kernel: [29480.368569]
---[ end trace 32d79d600d4b3f34 ]---
