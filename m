Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161214Ab3LFNao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 08:30:44 -0500
Date: Fri, 6 Dec 2013 21:30:34 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Message-ID: <20131206133033.GC20595@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1531404.tFNCiHaLVH@linux-suse.hu>
 <2467502.UPcdayreHd@linux-suse.hu>
 <20131206060419.GA20595@localhost.localdomain>
 <14005207.4jWyJLzXAX@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <14005207.4jWyJLzXAX@linux-suse.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 06, 2013 at 01:46:10PM +0100, Szőts Ákos wrote:
> A következőt írtad ekkor: 2013. december 6. 14:04:19
> > Could you please try the following and show me the output of dmesg?
> > 
> > thanks,
> > -liubo
> 
> The following happened:
> - I upgraded to 3.13.0-rc2-6.ge7c00d8 (since the original 3.12 kernel with 
> SUSE patches is not available anymore)
> - Patched it and booted from that, compiled the NVIDIA driver
> - and suddenly everything started to work fine. Now I don't have to wait 6 
> minutes for the [btrfs-ino-cache] process.
> 
> One thing I noticed: before any logging would start, kernel prints out some 
> (initramfs?) messages, like:
> "Waiting for device /dev/disk/... to appear
> [...]
> fsck succeeded Mounting root read-write
> Mounting root /dev/disk/...
> mount -o rw,compress=lzo,space_cache,noatime,inode_cache /dev/... /root"
> 
> And logging starts from this point.
> 
> The interesting point is the initramfs mounting options: with the stock 3.12 
> kernel I had only the following: rw,compress=lzo,space_cache. But now it's 
> rw,compress=lzo,space_cache,noatime,inode_cache. In /etc/fstab the options are 
> intact for a month now. Maybe I should have regenerated the initrd when I 
> added the fstab mount options noatime and inode_cache?
> 
> I searched for your extra kernel messages in dmesg, but I didn't find them, 
> although here is the dmesg output: http://paste.opensuse.org/30797527

It seems that we should owe credit to the updated 3.13 kernel, could you
please try again 3.13 kernel without the patch?

thanks,
-liubo
