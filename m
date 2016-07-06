Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay14-dus.antispameurope.com ([94.100.134.214]:39045 "EHLO
	mx-relay14-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbcGFQdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 12:33:24 -0400
Date: Wed, 6 Jul 2016 18:33:13 +0200
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <antonio@gnu.org>, <ahferroin7@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>, <adilger@dilger.ca>
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
Message-ID: <577d32c9.TRqyIACgL+Y5Fmyj%Joerg.Schilling@fokus.fraunhofer.de>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
 <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
 <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de>
 <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com>
In-Reply-To: <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> On 2016-07-06 11:22, Joerg Schilling wrote:
> > "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> >
> >>> It should be obvious that a file that offers content also has allocated blocks.
> >> What you mean then is that POSIX _implies_ that this is the case, but
> >> does not say whether or not it is required.  There are all kinds of
> >> counterexamples to this too, procfs is a POSIX compliant filesystem
> >> (every POSIX certified system has it), yet does not display the behavior
> >> that you expect, every single file in /proc for example reports 0 for
> >> both st_blocks and st_size, and yet all of them very obviously have content.
> >
> > You are mistaken.
> >
> > stat /proc/$$/as
> >   File: `/proc/6518/as'
> >   Size: 2793472         Blocks: 5456       IO Block: 512    regular file
> > Device: 5440000h/88342528d      Inode: 7557        Links: 1
> > Access: (0600/-rw-------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
> > Access: 2016-07-06 16:33:15.660224934 +0200
> > Modify: 2016-07-06 16:33:15.660224934 +0200
> > Change: 2016-07-06 16:33:15.660224934 +0200
> >
> > stat /proc/$$/auxv
> >   File: `/proc/6518/auxv'
> >   Size: 168             Blocks: 1          IO Block: 512    regular file
> > Device: 5440000h/88342528d      Inode: 7568        Links: 1
> > Access: (0400/-r--------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
> > Access: 2016-07-06 16:33:15.660224934 +0200
> > Modify: 2016-07-06 16:33:15.660224934 +0200
> > Change: 2016-07-06 16:33:15.660224934 +0200
> >
> > Any correct implementation of /proc returns the expected numbers in st_size as
> > well as in st_blocks.
> Odd, because I get 0 for both values on all the files in /proc/self and 
> all the top level files on all kernels I tested prior to sending that 

I tested this with an official PROCFS-2 implementation that was written by 
the inventor of the PROC filesystem (Roger Faulkner) who as a sad news pased 
away last weekend.

You may have done your tests on an inofficial procfs implementation....

> > Now you know why BTRFS is still an incomplete filesystem. In a few years when
> > it turns 10, this may change. People who implement filesystems of course need
> > to learn that they need to hide implementation details from the official user
> > space interfaces.
> So in other words you think we should be lying about how much is 
> actually allocated on disk and thus violating the standard directly (and 
> yes, ext4 and everyone else who does this with delayed allocation _is_ 
> strictly speaking violating the standard, because _nothing_ is allocated 
> yet)?

If it returns 0, it would be lying or it would be wrong anyway as it did not 
check fpe available space.

Also note that I mentioned already that the priciple availability of SEEK_HOLE 
does not help as there is e.g. NFS...

Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.org/private/ http://sourceforge.net/projects/schilytools/files/'
