Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58562 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3CSMJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 08:09:43 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 36EA89A0645
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 06:09:43 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <orzjy0dkz9.fsf@livre.home>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
 <20130318225245.25964.22219@localhost.localdomain>
 <orzjy0dkz9.fsf@livre.home>
Message-ID: <20130319120940.29898.80124@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Tue, 19 Mar 2013 08:09:40 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Alexandre Oliva (2013-03-19 01:20:10)
> On Mar 18, 2013, Chris Mason <chris.mason@fusionio.com> wrote:
> 
> > A few questions.  Does leveldb use O_DIRECT and mmap together?
> 
> No, it doesn't use O_DIRECT at all.  Its I/O interface is very
> simplified: it just opens each new file (database chunks limited to 2MB)
> with O_CREAT|O_RDWR|O_TRUNC, and then uses ftruncate, mmap, msync,
> munmap and fdatasync.  It doesn't seem to modify data once it's written;
> it only appends.  Reading data back from it uses a completely different
> class interface, using separate descriptors and using pread only.
> 
> > (the source of a write being pages that are mmap'd from somewhere
> > else)
> 
> AFAICT the source of the memcpy()s that append to the file are
> malloc()ed memory.
> 
> > That's the most likely place for this kind of problem.  Also, you
> > mention crc errors.  Are those reported by btrfs or are they application
> > level crcs.
> 
> These are CRCs leveldb computes and writes out after each db block.  No
> btrfs CRC errors are reported in this process.

Ok, so we have three moving pieces here.

1) leveldb truncating the files
2) leveldb using mmap to write
3) btrfs snapshots

My guess is the truncate is creating a orphan item that is being
processed inside the snapshot.

Is it possible to create a smaller leveldb unit test that we might use
to exercise all of this?

-chris

