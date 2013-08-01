Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3HAVIL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 17:08:11 -0400
Date: Thu, 1 Aug 2013 23:08:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: fix segfault when listing column OTIME
 on big endian host
Message-ID: <20130801210809.GE24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51F10A50.9010308@cn.fujitsu.com>
 <1374761521-17603-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374761521-17603-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 25, 2013 at 10:12:01PM +0800, Eryu Guan wrote:
> The second btrfs command segfaults on big endian host(ppc64)
> 
> 	btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/snap
> 	btrfs subvolume list -s /mnt/btrfs
> 
> And ltrace shows
> 
> 	localtime(0x10029c482d0)                 = 0
> 	strftime( <no return ...>
> 	--- SIGSEGV (Segmentation fault) ---
> 
> The corresponding code
> 
> btrfs-list.c:
>         case BTRFS_LIST_OTIME:
>                 if (subv->otime)
>                         strftime(tstr, 256, "%Y-%m-%d %X",
>                                  localtime(&subv->otime));
>                 else
>                         strcpy(tstr, "-");
>                 printf("%s", tstr);
>                 break;
> 
> localtime() returned NULL then strftime() got SIGSEGV.
> 
> The reason is that ri->otime.sec is stored as little endian but
> assigned to 't' without conversion.

I've sent fixes to both otime endianity and localtime crashes some days
ago and will keep them in integration branch. The reentrant variant of
localtime is safer, though the fix to otime access might be enough to
fix it.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg25676.html
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg25677.html

david
