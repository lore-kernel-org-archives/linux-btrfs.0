Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51883 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaHZLOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 07:14:35 -0400
Date: Tue, 26 Aug 2014 19:14:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fuzz testing a 32 bit x86 user mode linux guest brought a BUG in
Message-ID: <20140826111425.GH16865@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <53ED3095.4070004@gmx.de>
 <20140825041213.GD22848@localhost.localdomain>
 <53FB60F1.6080902@gmx.de>
 <20140826081152.GE16865@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20140826081152.GE16865@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 26, 2014 at 04:11:53PM +0800, Liu Bo wrote:
> On Mon, Aug 25, 2014 at 06:14:41PM +0200, Toralf Förster wrote:
> > On 08/25/2014 06:12 AM, Liu Bo wrote:
> > > Could you please elaborate what options of trinity you're using?
> > > 
> > > thanks,
> > > -liubo
> > 
> > $> nice trinity.sh -t "-C 2 -N 100000 -x mremap -x munmap -x madvise -q" -v /mnt/btrfs
> > 
> > So for UML I excluded in the past those 3 syscalls (nowadays no longer necessary), run 2 clients in parallel, the BTRFS fs was created in this manner :
> > 
> > dd if=/dev/zero of=/mnt/ramdisk/btrfs.fs bs=1M count=97 2>/dev/null; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs 1>/dev/null 2>&1; mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/btrfs; chmod 777 /mnt/btrfs
> > 
> 
> How does this trinity.sh handle with "/mnt/btrfs"?
> 
> Is it something like this: 
> 
> cd /mnt/btrfs;
> trinity "-C 2 -N 100000 -x mremap -x munmap -x madvise -q";

FYI, I've reproduced this with a "-V /mnt/btrfs".

thanks,
-liubo
