Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17939 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933000AbcLIC1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 21:27:04 -0500
Date: Thu, 8 Dec 2016 18:26:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marc Joliet <marcec@gmx.de>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: out-of-band dedup status?
Message-ID: <20161209022647.GE16801@birch.djwong.org>
References: <1481222198.6563.3.camel@scientia.net>
 <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
 <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
 <59259055.MCA93YCoJj@thetick>
 <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 05:45:40PM -0700, Chris Murphy wrote:
> OK something's wrong.
> 
> Kernel 4.8.12 and duperemove v0.11.beta4. Brand new file system
> (mkfs.btrfs -dsingle -msingle, default mount options) and two
> identical files separately copied.
> 
> [chris@f25s]$ ls -li /mnt/test
> total 2811904
> 260 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
> Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
> 259 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
> Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
> 
> [chris@f25s]$ filefrag /mnt/test/*
> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso: 3 extents found
> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2: 2 extents found
> 
> 
> [chris@f25s duperemove]$ sudo ./duperemove -dv /mnt/test/*
> Using 128K blocks
> Using hash: murmur3
> Gathering file list...
> Using 4 threads for file hashing phase
> [1/2] (50.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
> [2/2] (100.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
> Total files:  2
> Total hashes: 21968
> Loading only duplicated hashes from hashfile.
> Using 4 threads for dedupe phase
> [0xba8400] (00001/10947) Try to dedupe extents with id e47862ea
> [0xba84a0] (00003/10947) Try to dedupe extents with id ffed44f2
> [0xba84f0] (00002/10947) Try to dedupe extents with id ffeefcdd
> [0xba8540] (00004/10947) Try to dedupe extents with id ffe4cf64
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 1182924800 (4)
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 1182924800 (5)
> [0xba8540] Dedupe 1 extents (id: ffe4cf64) with target: (1182924800,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"

Ew, it's deduping these two 1.4GB files 128K at a time, which results in
12000 ioctl calls.  Each of those 12000 calls has to lock the two
inodes, read the file contents, remap the blocks, etc.  instead of
finding the maximal identical range and making a single call for the
whole range.

That's probably why it's taking forever to dedupe.

--D

> [0xba8540] (00004/10947) Try to dedupe extents with id ffe4cf64
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 543293440 (4)
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 543293440 (5)
> [0xba84a0] Dedupe 1 extents (id: ffed44f2) with target: (543293440,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 1182924800 (5)
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 1182924800 (4)
> [0xba8540] Dedupe 1 extents (id: ffe4cf64) with target: (1182924800,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2"
> [0xba84a0] (00003/10947) Try to dedupe extents with id ffed44f2
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 543293440 (5)
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 543293440 (4)
> [0xba84a0] Dedupe 1 extents (id: ffed44f2) with target: (543293440,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2"
> [0xba84f0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 101580800 (4)
> [0xba84f0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 101580800 (5)
> [0xba84f0] Dedupe 1 extents (id: ffeefcdd) with target: (101580800,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> [0xba84a0] (00005/10947) Try to dedupe extents with id ffe24eaf
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 171835392 (4)
> [0xba84a0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 171835392 (5)
> [0xba84a0] Dedupe 1 extents (id: ffe24eaf) with target: (171835392,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> [0xba84f0] (00002/10947) Try to dedupe extents with id ffeefcdd
> [0xba8540] (00006/10947) Try to dedupe extents with id ffe116c8
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 52035584 (4)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 52035584 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 52166656 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60030976 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60162048 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60293120 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60424192 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60555264 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 60686336 (5)
> 
> [...snip...]
> 
> 10 minutes later...
> 
> [0xba84f0] (06233/10947) Try to dedupe extents with id 703ebf5c
> [0xba8400] (06234/10947) Try to dedupe extents with id 70367565
> [0xba8540] (06230/10947) Try to dedupe extents with id 704776dc
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 485490688 (5)
> [0xba8540] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 485490688 (4)
> [0xba8540] Dedupe 1 extents (id: 704776dc) with target: (485490688,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2"
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 1361051648 (4)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 1361051648 (5)
> [0xba8400] Dedupe 1 extents (id: 70367565) with target: (1361051648,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> [0xba84a0] (06235/10947) Try to dedupe extents with id 702c1b6b
> [0xba84f0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 623771648 (4)
> [0xba84f0] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 623771648 (5)
> [0xba84f0] Dedupe 1 extents (id: 703ebf5c) with target: (623771648,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
> [0xba8400] (06234/10947) Try to dedupe extents with id 70367565
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
> 1361051648 (5)
> [0xba8400] Add extent for file
> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
> 1361051648 (4)
> [0xba8400] Dedupe 1 extents (id: 70367565) with target: (1361051648,
> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2"
> ^C
> [chris@f25s duperemove]$
> 
> Cancelled this after 10 minutes. It should not take this long to
> dedupe two files.
> 
> 
> [chris@f25s]$ filefrag /mnt/test/*
> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso: 43 extents found
> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2: 5522 extents found
> 
> 
> I don't understand what's going on.
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
