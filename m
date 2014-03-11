Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbaCKDAP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 23:00:15 -0400
Message-ID: <1394505491.6207.4.camel@localhost.localdomain>
Subject: Re: Building a brtfs filesystem < 70M?
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Saul Wold <sgw@linux.intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 11 Mar 2014 10:38:11 +0800
In-Reply-To: <531E4A02.5010404@linux.intel.com>
References: <531E4A02.5010404@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-03-10 at 16:25 -0700, Saul Wold wrote:
> Hi There
> 
> There seems to be an issue if we try to build a btrfs based FS that is 
> less than 70M, we get the following assertion failure:
> 
> mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion `!(ret)' 
> failed.
> 
> I tried to do a search on this and did not find anything obvious.
> 
> Further, if I do build a 70M image, it will not mount until I get to I 
> increase  the about 100M!
> 
> # mount -o loop -v rootfs.btrfs mnt
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>         missing codepage or helper program, or other error
> 
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> 
> I can provide a small rootfs (~4M) example if needed
> 
> Builds and mounts correct:
> mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs
> 
> Builds, but does not mount:
> mkfs.btrfs -b 73400320 -r rootfs rootfs.btrfs
> 
> Does not build, gives the above assertion error:
> mkfs.btrfs -b 10889216 -r rootfs rootfs.btrfs
> 
> 
> Thanks
> 
Hi Saul,
Sorry, I'm not able to reproduce your problem...
Are you running the latest btrfs-progs from david's branch?

Thanks,
Gui


