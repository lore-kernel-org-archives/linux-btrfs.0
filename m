Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64069 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaHYQOo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 12:14:44 -0400
Message-ID: <53FB60F1.6080902@gmx.de>
Date: Mon, 25 Aug 2014 18:14:41 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: fuzz testing a 32 bit x86 user mode linux guest brought a BUG
 in
References: <53ED3095.4070004@gmx.de> <20140825041213.GD22848@localhost.localdomain>
In-Reply-To: <20140825041213.GD22848@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2014 06:12 AM, Liu Bo wrote:
> Could you please elaborate what options of trinity you're using?
> 
> thanks,
> -liubo

$> nice trinity.sh -t "-C 2 -N 100000 -x mremap -x munmap -x madvise -q" -v /mnt/btrfs

So for UML I excluded in the past those 3 syscalls (nowadays no longer necessary), run 2 clients in parallel, the BTRFS fs was created in this manner :

dd if=/dev/zero of=/mnt/ramdisk/btrfs.fs bs=1M count=97 2>/dev/null; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs 1>/dev/null 2>&1; mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/btrfs; chmod 777 /mnt/btrfs


-- 
Toralf
pgp key: 0076 E94E

