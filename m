Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:38878 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933215AbeBUQsm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 11:48:42 -0500
Message-ID: <1519231718.3834.6.camel@scientia.net>
Subject: Re: BUG: unable to handle kernel paging request at ffff9fb75f827100
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Feb 2018 17:48:38 +0100
In-Reply-To: <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
References: <1519186148.24817.1.camel@scientia.net>
         <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A scrub now gave:
# btrfs scrub start -Br /dev/disk/by-label/system
ERROR: scrubbing /dev/disk/by-label/system failed for device id 1: ret=-1, errno=5 (Input/output error)
scrub canceled for b6050e38-716a-40c3-a8df-fcf1dd7e655d
	scrub started at Wed Feb 21 17:42:39 2018 and was aborted after 00:04:18
	total bytes scrubbed: 116.59GiB with 1 errors
	error details: csum=1
	corrected errors: 0, uncorrectable errors: 0, unverified errors: 0



with that in the kernel log
Feb 21 17:43:09 heisenberg kernel: BTRFS warning (device dm-0): checksum error at logical 16401395712 on dev /dev/mapper/system, sector 32033976, root 1830, inode 42609350, offset 6754201600, length 4096, links 1 (path: var/lib/libvirt/images/subsurface.qcow2)
Feb 21 17:43:09 heisenberg kernel: BTRFS warning (device dm-0): checksum error at logical 16401395712 on dev /dev/mapper/system, sector 32033976, root 257, inode 42609350, offset 6754201600, length 4096, links 1 (path: var/lib/libvirt/images/subsurface.qcow2)
Feb 21 17:43:09 heisenberg kernel: BTRFS error (device dm-0): bdev /dev/mapper/system errs: wr 0, rd 0, flush 0, corrupt 1, gen 0

Feb 21 17:46:13 heisenberg kernel: usb 1-2: USB disconnect, device number 2
Feb 21 17:46:57 heisenberg kernel: btrfs_printk: 128 callbacks suppressed
Feb 21 17:46:57 heisenberg kernel: BTRFS critical (device dm-0): unable to find logical 4503658729209856 length 16384
Feb 21 17:46:57 heisenberg kernel: BTRFS critical (device dm-0): unable to find logical 4503658729209856 length 4096
Feb 21 17:46:57 heisenberg kernel: BTRFS critical (device dm-0): unable to find logical 4503658729209856 length 4096
Feb 21 17:46:57 heisenberg kernel: BTRFS critical (device dm-0): unable to find logical 4503658729209856 length 16384


any idea on what to do?
