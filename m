Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay34-dus.antispameurope.com ([94.100.134.234]:49222 "EHLO
	mx-relay34-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbcGFPWw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 11:22:52 -0400
Date: Wed, 6 Jul 2016 17:22:47 +0200
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <antonio@gnu.org>, <ahferroin7@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>, <adilger@dilger.ca>
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
Message-ID: <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
 <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
In-Reply-To: <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > It should be obvious that a file that offers content also has allocated blocks.
> What you mean then is that POSIX _implies_ that this is the case, but 
> does not say whether or not it is required.  There are all kinds of 
> counterexamples to this too, procfs is a POSIX compliant filesystem 
> (every POSIX certified system has it), yet does not display the behavior 
> that you expect, every single file in /proc for example reports 0 for 
> both st_blocks and st_size, and yet all of them very obviously have content.

You are mistaken.

stat /proc/$$/as
  File: `/proc/6518/as'
  Size: 2793472         Blocks: 5456       IO Block: 512    regular file
Device: 5440000h/88342528d      Inode: 7557        Links: 1
Access: (0600/-rw-------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
Access: 2016-07-06 16:33:15.660224934 +0200
Modify: 2016-07-06 16:33:15.660224934 +0200
Change: 2016-07-06 16:33:15.660224934 +0200

stat /proc/$$/auxv
  File: `/proc/6518/auxv'
  Size: 168             Blocks: 1          IO Block: 512    regular file
Device: 5440000h/88342528d      Inode: 7568        Links: 1
Access: (0400/-r--------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
Access: 2016-07-06 16:33:15.660224934 +0200
Modify: 2016-07-06 16:33:15.660224934 +0200
Change: 2016-07-06 16:33:15.660224934 +0200

Any correct implementation of /proc returns the expected numbers in st_size as 
well as in st_blocks.

> In all seriousness though, this started out because stuff wasn't cached 
> to anywhere near the degree it is today, and there was no such thing as 
> delayed allocation.  When you said to write, the filesystem allocated 
> the blocks, regardless of when it actually wrote the data.  IOW, the 
> behavior that GNU tar is relying on is an implementation detail, not an 
> API.  Just like df, this breaks under modern designs, not because they 
> chose to break it, but because it wasn't designed for use with such 
> implementations.

This seems to be a strange interpretation if what a standard is.

> > A new filesystem cannot introduce new rules just because people believe it would
> > save time.
> Saying the file has no blocks when there are no blocks allocated for it 
> is not to 'save time', it's absolutely accurate.  Suppose SVR4 UFS had a 
> way to pack file data into the inode if it was small enough.  In that 
> case, it woulod be perfectly reasonable to return 0 for st_blocks 
> because the inode table in UFS is a fixed pre-allocated structure, and 

Given that inode size is 128, such a change would not break things as the 
heuristics would not imply a sparse file here.

> therefore nothing is allocated to the file itself except the inode.  The 
> same applies in the case of a file packed into it's own metadata block 
> on BTRFS, nothing is allocated to that file beyond the metadata block it 
> has to have to store the inode.  In the case of delayed allocation where 
> the file hasn't been flushed, there is nothing allocated, so st_blocks 
> based on a strict interpretation of it's description in POSIX _should_ 
> be 0, because nothing is allocated yet.

Now you know why BTRFS is still an incomplete filesystem. In a few years when 
it turns 10, this may change. People who implement filesystems of course need 
to learn that they need to hide implementation details from the official user 
space interfaces.

Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.org/private/ http://sourceforge.net/projects/schilytools/files/'
