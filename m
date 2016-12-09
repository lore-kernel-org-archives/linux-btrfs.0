Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47328 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbcLISQa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 13:16:30 -0500
Date: Fri, 9 Dec 2016 10:16:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Marc Joliet <marcec@gmx.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, mfasheh@versity.com
Subject: Re: out-of-band dedup status?
Message-ID: <20161209181618.GK8436@birch.djwong.org>
References: <1481222198.6563.3.camel@scientia.net>
 <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
 <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
 <59259055.MCA93YCoJj@thetick>
 <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
 <20161209022647.GE16801@birch.djwong.org>
 <CAJCQCtSRUmQarebB6rK_sCiVGpBZ-Xcptr17zu_XoJC8EF9BoQ@mail.gmail.com>
 <c992df7d-d58f-1b59-371e-149516bb358e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c992df7d-d58f-1b59-371e-149516bb358e@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[adding mark fasheh (duperemove maintainer) to cc]

On Fri, Dec 09, 2016 at 07:29:21AM -0500, Austin S. Hemmelgarn wrote:
> On 2016-12-08 21:54, Chris Murphy wrote:
> >On Thu, Dec 8, 2016 at 7:26 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >>On Thu, Dec 08, 2016 at 05:45:40PM -0700, Chris Murphy wrote:
> >>>OK something's wrong.
> >>>
> >>>Kernel 4.8.12 and duperemove v0.11.beta4. Brand new file system
> >>>(mkfs.btrfs -dsingle -msingle, default mount options) and two
> >>>identical files separately copied.
> >>>
> >>>[chris@f25s]$ ls -li /mnt/test
> >>>total 2811904
> >>>260 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
> >>>Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
> >>>259 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
> >>>Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
> >>>
> >>>[chris@f25s]$ filefrag /mnt/test/*
> >>>/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso: 3 extents found
> >>>/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2: 2 extents found
> >>>
> >>>
> >>>[chris@f25s duperemove]$ sudo ./duperemove -dv /mnt/test/*
> >>>Using 128K blocks
> >>>Using hash: murmur3
> >>>Gathering file list...
> >>>Using 4 threads for file hashing phase
> >>>[1/2] (50.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
> >>>[2/2] (100.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
> >>>Total files:  2
> >>>Total hashes: 21968
> >>>Loading only duplicated hashes from hashfile.
> >>>Using 4 threads for dedupe phase
> >>>[0xba8400] (00001/10947) Try to dedupe extents with id e47862ea
> >>>[0xba84a0] (00003/10947) Try to dedupe extents with id ffed44f2
> >>>[0xba84f0] (00002/10947) Try to dedupe extents with id ffeefcdd
> >>>[0xba8540] (00004/10947) Try to dedupe extents with id ffe4cf64
> >>>[0xba8540] Add extent for file
> >>>"/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> >>>1182924800 (4)
> >>>[0xba8540] Add extent for file
> >>>"/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> >>>1182924800 (5)
> >>>[0xba8540] Dedupe 1 extents (id: ffe4cf64) with target: (1182924800,
> >>>131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> >>
> >>Ew, it's deduping these two 1.4GB files 128K at a time, which results in
> >>12000 ioctl calls.  Each of those 12000 calls has to lock the two
> >>inodes, read the file contents, remap the blocks, etc.  instead of
> >>finding the maximal identical range and making a single call for the
> >>whole range.
> >>
> >>That's probably why it's taking forever to dedupe.
> >
> >Yes but it looks like it's also heavily fragmenting the files as a
> >result as well.

I'm not sure why btrfs has that behavior... XFS doesn't do that, and
evidently there's a bug in ocfs2 such that it sometimes merges records
and sometimes does not.  Hmm, I'll have to take a second look at ocfs2.

> This kind of reinforces what I've been telling people recently, namely that
> while generic batch deduplication generally works, it's quite often better
> to do a custom tool that understands your data-set and knows how to handle
> it efficiently.
> 
> As an example, one of the cases where I use deduplication is on a set of
> directories that are disjoint sets of a larger tree.  So, the directories
> look something like this:
> + a
> | + file1
> | \ file2
> + b
> | + file3
> | \ file2
> \ c
>   + file1
>   \ file3
> 
> In this case, I know that if a/file1 and c/file1 have the same mtime and
> size, they're (supposed to be) copies of the same file.  Given this, the
> tool I use for this just checks for duplicate names with the same size and
> mtime, and then counts on the ioctl's check to verify that the files are
> actually identical (and throws a warning if they aren't), and does some
> special stuff to submit things such that any given file both has the fewest
> possible number of extents and all the extents are roughly the same size.
> On average, even with the fancy extent size calculation logic, this still
> takes less than a quarter of the time that duperemove took on the same
> data-set.

It sure would be nice if duperemove could group all the files that are
the same size and perform whole-file dedupe on the identical ones
instead of doing everything chunk by chunk, particularly since all three
filesystems can actually handle that case.

--D
