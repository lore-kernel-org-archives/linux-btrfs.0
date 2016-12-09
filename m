Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34684 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcLICyl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 21:54:41 -0500
Received: by mail-yw0-f195.google.com with SMTP id a10so482982ywa.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 18:54:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161209022647.GE16801@birch.djwong.org>
References: <1481222198.6563.3.camel@scientia.net> <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
 <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
 <59259055.MCA93YCoJj@thetick> <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
 <20161209022647.GE16801@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 8 Dec 2016 19:54:39 -0700
Message-ID: <CAJCQCtSRUmQarebB6rK_sCiVGpBZ-Xcptr17zu_XoJC8EF9BoQ@mail.gmail.com>
Subject: Re: out-of-band dedup status?
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, Marc Joliet <marcec@gmx.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 8, 2016 at 7:26 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Thu, Dec 08, 2016 at 05:45:40PM -0700, Chris Murphy wrote:
>> OK something's wrong.
>>
>> Kernel 4.8.12 and duperemove v0.11.beta4. Brand new file system
>> (mkfs.btrfs -dsingle -msingle, default mount options) and two
>> identical files separately copied.
>>
>> [chris@f25s]$ ls -li /mnt/test
>> total 2811904
>> 260 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
>> Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
>> 259 -rw-r--r--. 1 root root 1439694848 Dec  8 17:26
>> Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
>>
>> [chris@f25s]$ filefrag /mnt/test/*
>> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso: 3 extents found
>> /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2: 2 extents found
>>
>>
>> [chris@f25s duperemove]$ sudo ./duperemove -dv /mnt/test/*
>> Using 128K blocks
>> Using hash: murmur3
>> Gathering file list...
>> Using 4 threads for file hashing phase
>> [1/2] (50.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso
>> [2/2] (100.00%) csum: /mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2
>> Total files:  2
>> Total hashes: 21968
>> Loading only duplicated hashes from hashfile.
>> Using 4 threads for dedupe phase
>> [0xba8400] (00001/10947) Try to dedupe extents with id e47862ea
>> [0xba84a0] (00003/10947) Try to dedupe extents with id ffed44f2
>> [0xba84f0] (00002/10947) Try to dedupe extents with id ffeefcdd
>> [0xba8540] (00004/10947) Try to dedupe extents with id ffe4cf64
>> [0xba8540] Add extent for file
>> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso" at offset
>> 1182924800 (4)
>> [0xba8540] Add extent for file
>> "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso2" at offset
>> 1182924800 (5)
>> [0xba8540] Dedupe 1 extents (id: ffe4cf64) with target: (1182924800,
>> 131072), "/mnt/test/Fedora-Workstation-Live-x86_64-25_Beta-1.1.iso"
>
> Ew, it's deduping these two 1.4GB files 128K at a time, which results in
> 12000 ioctl calls.  Each of those 12000 calls has to lock the two
> inodes, read the file contents, remap the blocks, etc.  instead of
> finding the maximal identical range and making a single call for the
> whole range.
>
> That's probably why it's taking forever to dedupe.

Yes but it looks like it's also heavily fragmenting the files as a
result as well.

-- 
Chris Murphy
