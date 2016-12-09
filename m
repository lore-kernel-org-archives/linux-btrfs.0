Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33106 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbcLITSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 14:18:48 -0500
Received: by mail-yw0-f193.google.com with SMTP id s68so2621765ywg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Dec 2016 11:18:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161209181618.GK8436@birch.djwong.org>
References: <1481222198.6563.3.camel@scientia.net> <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
 <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
 <59259055.MCA93YCoJj@thetick> <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
 <20161209022647.GE16801@birch.djwong.org> <CAJCQCtSRUmQarebB6rK_sCiVGpBZ-Xcptr17zu_XoJC8EF9BoQ@mail.gmail.com>
 <c992df7d-d58f-1b59-371e-149516bb358e@gmail.com> <20161209181618.GK8436@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Dec 2016 12:18:46 -0700
Message-ID: <CAJCQCtSkzsjxv53XVORhH3e=ExfiOepReO677MaqUtnyJNEKKw@mail.gmail.com>
Subject: Re: out-of-band dedup status?
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Marc Joliet <marcec@gmx.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, mfasheh@versity.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 9, 2016 at 11:16 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> [adding mark fasheh (duperemove maintainer) to cc]
>
> On Fri, Dec 09, 2016 at 07:29:21AM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-12-08 21:54, Chris Murphy wrote:
>> >On Thu, Dec 8, 2016 at 7:26 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> >>On Thu, Dec 08, 2016 at 05:45:40PM -0700, Chris Murphy wrote:
>> >>>OK something's wrong.
>> >>>
>> >>>Kernel 4.8.12 and duperemove v0.11.beta4. Brand new file system
>> >>>(mkfs.btrfs -dsingle -msingle, default mount options) and two
>> >>>identical files separately copied.
>> >>>
>> >>>[chris@f25s]$ ls -li /mnt/test
>> >>>total 2811904
>> >>>260 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
>> >>>Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
>> >>>259 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
>> >>>Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
>> >>>
>> >>>[chris@f25s]$ filefrag /mnt/test/*
>> >>>/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso: 3 extents found
>> >>>/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2: 2 extents found
>> >>>
>> >>>
>> >>>[chris@f25s duperemove]$ sudo ./duperemove -dv /mnt/test/*
>> >>>Using 128K blocks
>> >>>Using hash: murmur3
>> >>>Gathering file list...
>> >>>Using 4 threads for file hashing phase
>> >>>[1/2] (50.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
>> >>>[2/2] (100.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
>> >>>Total files:  2
>> >>>Total hashes: 21968
>> >>>Loading only duplicated hashes from hashfile.
>> >>>Using 4 threads for dedupe phase
>> >>>[0xba8400] (00001/10947) Try to dedupe extents with id e47862ea
>> >>>[0xba84a0] (00003/10947) Try to dedupe extents with id ffed44f2
>> >>>[0xba84f0] (00002/10947) Try to dedupe extents with id ffeefcdd
>> >>>[0xba8540] (00004/10947) Try to dedupe extents with id ffe4cf64
>> >>>[0xba8540] Add extent for file
>> >>>"/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
>> >>>1182924800 (4)
>> >>>[0xba8540] Add extent for file
>> >>>"/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
>> >>>1182924800 (5)
>> >>>[0xba8540] Dedupe 1 extents (id: ffe4cf64) with target: (1182924800,
>> >>>131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
>> >>
>> >>Ew, it's deduping these two 1.4GB files 128K at a time, which results in
>> >>12000 ioctl calls.  Each of those 12000 calls has to lock the two
>> >>inodes, read the file contents, remap the blocks, etc.  instead of
>> >>finding the maximal identical range and making a single call for the
>> >>whole range.
>> >>
>> >>That's probably why it's taking forever to dedupe.
>> >
>> >Yes but it looks like it's also heavily fragmenting the files as a
>> >result as well.
>
> I'm not sure why btrfs has that behavior... XFS doesn't do that, and
> evidently there's a bug in ocfs2 such that it sometimes merges records
> and sometimes does not.  Hmm, I'll have to take a second look at ocfs2.

I don't know if it's a kernel regression or a duperemove regression,
but I'm reasonably certain it's a regression because I used kernel
circa 4.6 and duperemove 0.10 in June and it did not do this; or at
the least it was not this verbose with thousands of entries per file
even with -v. I must've deduped 300GiB inside of 30 minutes. So for
two 1.4GiB ISOs to take more than 10 minutes to dedupe is not at all
what I'd expect.




-- 
Chris Murphy
