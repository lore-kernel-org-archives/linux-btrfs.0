Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay34-dus.antispameurope.com ([94.100.134.234]:37695 "EHLO
	mx-relay34-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbcGFLts (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 07:49:48 -0400
Date: Wed, 6 Jul 2016 13:49:37 +0200
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <praiskup@redhat.com>, <ahferroin7@gmail.com>, <adilger@dilger.ca>
CC: <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
Message-ID: <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
In-Reply-To: <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > A broken filesystem is a broken filesystem.
> >
> > If you try to change gtar to work around a specific problem, it may fail in
> > other situations.
> The problem with this is that tar is assuming things that are not 
> guaranteed to be true.  There is absolutely nothing that says that 
> st_blocks has to be non-zero if there's data in the file.  In fact, the 

This is not true: POSIX requires st_blocks to be != 0 in case that the file 
contains data.

> behavior that BTRFS used to have of reporting st_blocks to be 0 for 
> files entirely inlined in the metadata is absolutely correct given the 
> description of the field by POSIX, because there _are_ no blocks 
> allocated to the file (because the metadata block is technically 
> equivalent to the inode, which isn't counted by st_blocks).  This is yet 
> another example of an old interface (in this case, sparse file 
> detection) being short-sighted (read in this case as non-existent).

The internal state of a file system is irrelevant. The only thing that counts 
is the user space view and if a file contains data (read succeeds in user 
space), it needs to report st_blocks != 0.

> The proper fix for this is that tar (and anything else that handles 
> sparse files differently) should be parsing the file regardless.  It has 
> to anyway for a normal sparse file to figure out where the sparse 
> regions are, and optimizing for a file that's completely sparse (and 
> therefore probably pre-allocated with fallocate) is not all that 
> reasonable considering that this is going to be a very rare case in 
> normal usage.

This does not help.

Even on a decent OS (e.g. Solaris since Summer 2005) and a decent tar 
implementation (star) that supports SEEK_HOLE since Summer 2005, this method 
will not work for all filesystems as there may be old filesystem 
implementations and as there may be NFS...

For this reason, star still checks st_blocks in case that SEEK_HOLE did not 
work.

Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.org/private/ http://sourceforge.net/projects/schilytools/files/'
