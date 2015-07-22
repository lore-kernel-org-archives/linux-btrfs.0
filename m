Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63279 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882AbbGVHCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 03:02:40 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Taeha Kim'" <kthguru@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <loom.20150722T071610-642@post.gmane.org>
In-Reply-To: <loom.20150722T071610-642@post.gmane.org>
Subject: RE: resize: File too large
Date: Wed, 22 Jul 2015 15:01:25 +0800
Message-ID: <044601d0c44c$39cb7ca0$ad6275e0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Taeha Kim

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Taeha Kim
> Sent: Wednesday, July 22, 2015 1:20 PM
> To: linux-btrfs@vger.kernel.org
> Subject: resize: File too large
> 
> Hello,
> 
> I met a problem when resize btrfs as follows. The btrfs related sysinfo is
> attached at the end of this mail[1].
> 
> $ dd if=/dev/zero of=btrfs_5gb.img bs=1024 count=5000000
> 
> $ mkfs.btrfs btrfs_5gb.img
> 
> $ sudo mkdir -p /mnt/btrfs_5gb
> 
> $ mount -t btrfs btrfs_5gb.img /mnt/btrfs_5gb
> 
> $ btrfs filesystem resize +10g /mnt/btrfs_5gb Resize '/mnt/btrfs_5gb' of '+10g'
> ERROR: unable to resize '/mnt/btrfs_5gb' - File too large
> 

Thanks for reporting above problem.

> Is it a misuse case of resize?
> 

Kernel return -EFBIG in this case(dev not big enouth),
and btrfs-progs output corresponding standard error message for this return value:
"File too large"

This message is almost right for most case, but not for resize.

> And I expected not the message "File too large" but different error message.
> 

Good suggestion, I will change it to some accurate description.

Thanks
Zhaolei

> Thanks.
> 
> 
> Sincerely yours,
> Taeha Kim,
> Senior Engineer, Samsung Electronics
> 
> 
> [1] The btrfs related sysinfo
> 
> $ btrfs --version
> btrfs-progs v4.1.2
> 
> $ uname -r
> 4.0.8-300.fc22.x86_64
> 
> $ btrfs fi show /mnt/btrfs_5g
> btrfs-progs v4.1
> 
> $ btrfs fi df /mnt/btrfs_5g
> Data, single: total=8.00MiB, used=64.00KiB System, DUP: total=8.00MiB,
> used=16.00KiB System, single: total=4.00MiB, used=0.00B Metadata, DUP:
> total=244.12MiB, used=112.00KiB Metadata, single: total=8.00MiB,
> used=0.00B GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> $ dmesg | grep BTRFS
> BTRFS info (device loop0): disk space caching is enabled
> BTRFS: has skinny extents
> BTRFS: flagging fs with big metadata feature
> BTRFS: creating UUID tree
> BTRFS info (device loop0): disk space caching is enabled
> BTRFS: has skinny extents.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

