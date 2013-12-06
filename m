Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37549 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3LFMqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 07:46:36 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so275976bkb.20
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Dec 2013 04:46:35 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Date: Fri, 06 Dec 2013 13:46:10 +0100
Message-ID: <14005207.4jWyJLzXAX@linux-suse.hu>
In-Reply-To: <20131206060419.GA20595@localhost.localdomain>
References: <1531404.tFNCiHaLVH@linux-suse.hu> <2467502.UPcdayreHd@linux-suse.hu> <20131206060419.GA20595@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A következőt írtad ekkor: 2013. december 6. 14:04:19
> Could you please try the following and show me the output of dmesg?
> 
> thanks,
> -liubo

The following happened:
- I upgraded to 3.13.0-rc2-6.ge7c00d8 (since the original 3.12 kernel with 
SUSE patches is not available anymore)
- Patched it and booted from that, compiled the NVIDIA driver
- and suddenly everything started to work fine. Now I don't have to wait 6 
minutes for the [btrfs-ino-cache] process.

One thing I noticed: before any logging would start, kernel prints out some 
(initramfs?) messages, like:
"Waiting for device /dev/disk/... to appear
[...]
fsck succeeded Mounting root read-write
Mounting root /dev/disk/...
mount -o rw,compress=lzo,space_cache,noatime,inode_cache /dev/... /root"

And logging starts from this point.

The interesting point is the initramfs mounting options: with the stock 3.12 
kernel I had only the following: rw,compress=lzo,space_cache. But now it's 
rw,compress=lzo,space_cache,noatime,inode_cache. In /etc/fstab the options are 
intact for a month now. Maybe I should have regenerated the initrd when I 
added the fstab mount options noatime and inode_cache?

I searched for your extra kernel messages in dmesg, but I didn't find them, 
although here is the dmesg output: http://paste.opensuse.org/30797527

Thank you,

Ákos
