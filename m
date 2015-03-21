Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43168 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbCUDRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 23:17:14 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: syntax for deleting subvolumes?
Date: Sat, 21 Mar 2015 03:17:07 +0000
Cc: linux-btrfs@vger.kernel.org
References: <5509E34F.6010504@graphitesystems.com> <CAJCQCtSrR7tOQMkbKdk5y2FJ7J2nYNAAjowRnic2O13wa3d1PA@mail.gmail.com> <pan$e3d8c$58030454$dbd36547$e1e1c7cd@cox.net>
In-Reply-To: <pan$e3d8c$58030454$dbd36547$e1e1c7cd@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201503210317.07435.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 20 Mar 2015 04:18:38 AM Duncan wrote:
> If cp --reflink=auto was the default, it'd "just work", making a reflink 
> where possible, falling back to a normal copy where not possible to 
> reflink.
> 
> However, I'd be wary of such a change, because admins are used to cp 
> creating a separate copy which may well be intended as a backup, guarding 
> against I/O errors on the original.  Btrfs does do checksum checking to 
> ensure validity, but if that fails, do you really want it failing for 
> BOTH copies, including the one the admin made specifically to AVOID such 

If you have a second copy on the same filesystem then an error on any of the 
metadata that is a parent will corrupt both.  EG if you have 2 copies under 
your home directory then a directory error for /, /home, or /home/$USER will 
make both copies unavailable.

Also any errors on superblocks or other essential filesystem metadata risks 
losing both copies.

If BTRFS was to adopt something equivalent to the ZFS "copies=" feature then 
the sysadmin could specify that certain subtrees would have extra copies of 
data AND each metadata block would have 1 more copy than the data blocks it 
refers to.

In conclusion I think that the ZFS copies= feature is the correct solution to 
this problem.  Until/unless the BFTRFS developers copy that design concept the 
thing to do if you want backups on the same storage hardware is to copy the 
data to a filesystem on a different partition - the NetApp research shows that 
disk read errors tend to be correlated by location on disk.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
