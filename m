Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56528 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaAYNLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 08:11:22 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 14:11:19 +0100
Message-ID: <1730344.q7ECaAgUWV@merkaba>
In-Reply-To: <t5uara-vp4.ln1@hurikhan77.spdns.de>
References: <52E19667.6090005@gmail.com> <t5uara-vp4.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 24. Januar 2014, 21:14:21 schrieben Sie:
> KC <conrad.francois.artus@googlemail.com> schrieb:
> > I was wondering about whether using options like "autodefrag" and
> > "inode_cache" on SSDs.
> >
> > 
> >
> > On one hand, one always hears that defragmentation of SSD is a no-no,
> > does that apply to BTRFS's autodefrag?
> > Also, just recently, I heard something similar about "inode_cache".
> >
> > 
> >
> > On the other hand, Arch BTRFS wiki recommends to use both options on SSDs
> >
> >   http://wiki.archlinux.org/index.php/Btrfs#Mount_options
> > 
> >
> > So to clear things up, I ask at the source where people should know best.
> >
> > 
> >
> > Does using those options on SSDs gives any benefits and causes
> > non-negligible increase in SSD wear?
> 
> I'm not an expert, but I wondered myself. And while I still have not SSD
> yet  I would prefer turning autodefrag on even for SSD - at least when I
> have no big write-intensive files on the device (but you should plan your
> FS to not have those on a SSD anyways) because btrfs may rewrite large
> files on SSD just for the purpose of autodefragging. I hope that will
> improve soon, maybe by only defragging parts of the file given some sane
> thresholds.
> 
> Why I decided I would turn it on? Well, heavily fragmented files give a 
> performance overhead, and btrfs tends to fragment files fast (except for
> the  nodatacow mount flag with its own downsides). An adaptive online
> defrag ensures you gain no performance loss due to very scattert extents.
> And: Fragmented files (or let's better say fragmented free space) increases
> write-amplification (at least for long-living filesystems) because when
> small amounts of free space are randomly scattered all over the device the
> filesystem has to fill these holes at some point in time. This decreases
> performance because it has to find these holes and possibly split batched
> write requests, and it potentially decreases life-time of your SSD because
> the read-modify-write-erase cycle takes action in more places than what
> would be needed if the free space hole had just been big enough. I don't
> know how big erase blocks [*] are - but think about it. You will come to
> the conclusion that it will reduce life-time.

Do you have any numbers to back your claim?

I just demonstrated that >90000 extent Nepomuk database file. And still I do 
not see any serious performance degradation in KDE´s desktop search. For 
example I just entered nodatacow in Alt-F2 krunner text input and it presented 
me some indexed mails in an instant.

I tried to defrag the file, but frankly even though numbers of extent decreased 
I never perceived any difference in performance whatsoever.

I am just not convinced that autodefrag will give me any noticeable benefit for 
this Intel SSD 320 based /home.

For seeing any visible difference I think you need to have an I/O pattern that 
generated lots of IOPS due to the fragmented file, i.e. is reading and writing 
continuously large amounts of the fragmented data, yet despite those >90000 
extents I get:

merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> 
echo 3 > /proc/sys/vm/drop_caches ; /usr/bin/time -v dd if=soprano-virtuoso.db 
of=/dev/null bs=1M
2418+0 Datensätze ein
2418+0 Datensätze aus
2535456768 Bytes (2,5 GB) kopiert, 13,9546 s, 182 MB/s
        Command being timed: "dd if=soprano-virtuoso.db of=/dev/null bs=1M"
        User time (seconds): 0.00
        System time (seconds): 2.77
        Percent of CPU this job got: 19%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:13.96
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 2000
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 2
        Minor (reclaiming a frame) page faults: 549
        Voluntary context switches: 9369
        Involuntary context switches: 57
        Swaps: 0
        File system inputs: 5102304
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0


So even if I read in the full 2,4 GiB where BTRFS will have to look up all the 
>90000 extents I get 182 MB/s. (I disabled Nepomuk during that test).

Okay, I have seen 260 MB/s. But frankly I am pretty sure that Virtuoso isn´t 
doing this kind of large scale I/O on a highly fragmented file. Its a database. 
Its random access. My oppinion is that Virtuoso couldn´t care less about the 
fragmentation of the file. As long as it is stored on the SSD.

Well… take this with caveat. This is LZO compressed, those 2,4 GiB / 128 KiB 
gives at least about 20000 extents already provided that my calculation is 
correct. And these extents could be sequential (I doubt it tough also give the 
high free space fragmention I suspect to be on this FS).


Anyway: I do not perceive any noticable performance issues due to file 
fragmentation on SSD and think that at least on highly filled BTRFS filesystem 
autodefrag may do more harm than good (like fragment free space and then let 
btrfs-delalloc go crazy on new allocations). I know xfs_fsr for defragmenting 
XFS in the background, even via cron job. And I think I remember Dave Chinner 
telling in some post that even for harddisks it may not be a very wise idea to 
run this frequently due to the risk to fragment free space.

There are several kinds of fragmentations. And defragmenting files may increase 
freespace fragmentation.

Thus, I am not yet convinced regarding autodefrag on SSDs.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7


