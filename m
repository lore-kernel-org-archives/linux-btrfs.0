Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:49527 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3CSR3M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 13:29:12 -0400
Date: Tue, 19 Mar 2013 10:29:11 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <clmason@fusionio.com>
cc: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
In-Reply-To: <20130319120940.29898.80124@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1303191027320.4850@cobra.newdream.net>
References: <orhak8fm0u.fsf@livre.home> <20130318225245.25964.22219@localhost.localdomain> <orzjy0dkz9.fsf@livre.home> <20130319120940.29898.80124@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 19 Mar 2013, Chris Mason wrote:
> Quoting Alexandre Oliva (2013-03-19 01:20:10)
> > On Mar 18, 2013, Chris Mason <chris.mason@fusionio.com> wrote:
> > 
> > > A few questions.  Does leveldb use O_DIRECT and mmap together?
> > 
> > No, it doesn't use O_DIRECT at all.  Its I/O interface is very
> > simplified: it just opens each new file (database chunks limited to 2MB)
> > with O_CREAT|O_RDWR|O_TRUNC, and then uses ftruncate, mmap, msync,
> > munmap and fdatasync.  It doesn't seem to modify data once it's written;
> > it only appends.  Reading data back from it uses a completely different
> > class interface, using separate descriptors and using pread only.
> > 
> > > (the source of a write being pages that are mmap'd from somewhere
> > > else)
> > 
> > AFAICT the source of the memcpy()s that append to the file are
> > malloc()ed memory.
> > 
> > > That's the most likely place for this kind of problem.  Also, you
> > > mention crc errors.  Are those reported by btrfs or are they application
> > > level crcs.
> > 
> > These are CRCs leveldb computes and writes out after each db block.  No
> > btrfs CRC errors are reported in this process.
> 
> Ok, so we have three moving pieces here.
> 
> 1) leveldb truncating the files
> 2) leveldb using mmap to write
> 3) btrfs snapshots
> 
> My guess is the truncate is creating a orphan item that is being
> processed inside the snapshot.
> 
> Is it possible to create a smaller leveldb unit test that we might use
> to exercise all of this?

There is a set of unit tests in the leveldb source tree that ought to do 
the trick:

	git clone https://code.google.com/p/leveldb/

sage
