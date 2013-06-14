Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33731 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3FNB17 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 21:27:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 133E47C069A
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 19:27:59 -0600 (MDT)
Date: Thu, 13 Jun 2013 21:27:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Thomas Koch <thomas@koch.ro>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Stale NFS file handle after power loss
Message-ID: <20130614012756.GF658@localhost.localdomain>
References: <65278856.dWSg6uQ8zb@x121e>
 <20130610130047.GA10307@localhost.localdomain>
 <4263017.nb4SMd4E6p@x121e>
 <201306132145.29326.thomas@koch.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <201306132145.29326.thomas@koch.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 13, 2013 at 01:45:29PM -0600, Thomas Koch wrote:
> Thomas Koch:
> > On Monday, June 10, 2013 09:00:47 AM Josef Bacik wrote:
> > > On Sat, Jun 08, 2013 at 01:14:35PM -0600, Thomas Koch wrote:
> > > > Hi,
> > > > 
> > > > I had a power loss on my btrfs file system during package installation
> > > > and now I found this:
> > > > 
> > > > <code>
> > > > % ls -l /var/lib/dpkg/tmp.ci
> > > > ls: cannot access /var/lib/dpkg/tmp.ci/conffiles: Stale NFS file handle
> > > > ls: cannot access /var/lib/dpkg/tmp.ci/md5sums: Stale NFS file handle
> > > > total 0
> > > > -????????? ? ? ? ?            ? conffiles
> > > > -????????? ? ? ? ?            ? md5sums
> > > > % sudo rm -rf /var/lib/dpkg/tmp.ci/conffiles
> > > > rm: cannot remove ‘/var/lib/dpkg/tmp.ci/conffiles’: Stale NFS file
> > > > handle </code>
> > > > 
> > > > I booted with a live system and ran btrfsck (without --repair!) but
> > > > this did not change the situation. Unfortunately I wasn't clever
> > > > enough to save the output of btrfsck somehow. Do you need it?
> > > > 
> > > > Could you help me to get rid of these bogus files, please?
> > > 
> > > Don't run with --repair, but please capture the output so I can see
> > > what's going wrong.  Thanks,
> > > 
> > > Josef
> > 
> > sudo btrfsck /dev/x121e/root
> > checking extents
> > checking fs roots
> > root 5 inode 9319255 errors 1040
> > root 5 inode 9698560 errors 1000
> > root 5 inode 11591532 errors 2001
> >         unresolved ref dir 11591531 index 2 namelen 9 name conffiles
> > filetype 1 error 4
> > root 5 inode 11591534 errors 2001
> >         unresolved ref dir 11591531 index 4 namelen 7 name md5sums filetype
> > 1 error 4
> > found 270172975104 bytes used err is 1
> > total csum bytes: 261797296
> > total tree bytes: 2063106048
> > total fs tree bytes: 1575575552
> > btree space waste bytes: 561459705
> > file data blocks allocated: 386128334848
> >  referenced 262981738496
> > Btrfs Btrfs v0.19
> 
> Hi Josef,
> 
> do you think that you might find some solution to this problem or should I plan 
> to re-setup my machine?
> 

Yup sorry I just got sidetracked, I'll see what can be done tomorrow, but your
best bet it so pull down the latest btrfs-progs and build it and run

./btrfs-image /dev/whatever blah.img

and put the image up somewhere I can pull it down so I can fix btrfsck to fix
your file system and test it locally before I send you the patch.  Thanks,

Josef
