Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from equinox.linksky122.com ([184.173.222.71]:42344 "EHLO
	equinox.linksky122.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTNWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 09:22:37 -0400
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com> <20130620091622.GL11290@carfax.org.uk> <kpul4f$ei7$1@ger.gmane.org> <20130620103404.GN11290@carfax.org.uk> <kpum9h$ei7$2@ger.gmane.org> <20130620105607.GO11290@carfax.org.uk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130620105607.GO11290@carfax.org.uk>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <FDFB4977-0209-4F58-92CB-EF80E3575873@kevinokelley.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Kevin O'Kelley" <kevin@kevinokelley.com>
Subject: Re: Two identical copies of an image mounted result in changes to both images if only one is modified
Date: Thu, 20 Jun 2013 08:22:12 -0500
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your reply. I appreciate it. Unfortunately this issue is a deal killer for us. The ability to take very fast snapshots and replicate them to another site is key for us. We just can't us Btrfs with this setup. That's too bad. Good luck and thank you.

Sent from my iPhone

On Jun 20, 2013, at 5:56 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Jun 20, 2013 at 10:41:53AM +0000, Gabriel de Perthuis wrote:
>>>> Instead of redirecting to a different block device, Btrfs could and
>>>> should refuse to mount an already-mounted superblock when the block
>>>> device doesn't match, somewhere in or below btrfs_mount.  Registering
>>>> extra, distinct superblocks for an already mounted raid is a different
>>>> matter, but that isn't done through the mount syscall anyway.
>>> 
>>>   The problem here is that you could quite legitimately mount
>>> /dev/sda (with UUID=AA1234) on, say, /mnt/fs-a, and /dev/sdb (with
>>> UUID=AA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb are
>>> both part of the same filesystem. So you can't simply prevent mounting
>>> based on the device that the mount's being done with.
>> 
>> Okay.  The check should rely on a list of known block devices
>> for a given filesystem uuid.
> 
>   And this is where we fail currently -- that list is held by the
> btrfs module in the kernel, and is constructed on the basis of what
> "btrfs dev scan" finds by looking at superblocks on block devices.
> Currently, there's no method implemented for determining whether a
> block device with a legitimate btrfs superblock on it is a duplicate
> of another device, or whether it's a newly-discovered device which is
> part of an as-yet incompletely specified multi-device FS.
> 
>   I think it should be possible to look up the device ID as well, and
> complain (loudly, to the user, and in the kernel) at btrfs dev scan
> time if we see duplicates. That would deal with the problem at the
> earliest point of confusion.
> 
>   Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>                   --- I know of three kinds: hot, ---                   
>                cool,  and what-time-does-the-tune-start?                
