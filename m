Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49977 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaAYMyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 07:54:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 13:54:40 +0100
Message-ID: <2056077.lUO7kt9W8r@merkaba>
In-Reply-To: <pan$3043$d8104a03$9e09c506$6ce38ae5@cox.net>
References: <52E19667.6090005@gmail.com> <pan$3043$d8104a03$9e09c506$6ce38ae5@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

Am Freitag, 24. Januar 2014, 06:54:31 schrieb Duncan:
> Anyway, yes, I turned autodefrag on for my SSDs, here, but there are 
> arguments to be made in either direction, so I can understand people 
> choosing not to do that.

Do you have numbers to back up that this gives any advantage?

I have it disabled and yet I have things like:

Oh, this is insane. This filefrags runs for over a minute already. And hogging 
on one core eating almost 100% of its processing power.

merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> 
/usr/bin/time -v filefrag soprano-virtuoso.db


Wow, this still didn´t complete yet – even after 5 minutes.

Well I have some files with several ten thousands extent. But first, this is 
mounted with compress=lzo, so 128k is the largest extent size as far as I 
know, and second: I did manual btrfs filesystem defragment on files like those 
and and never ever perceived any noticable difference in performance.

Thus I just gave up on trying to defragment stuff on the SSD.


Well, now that command completed:

soprano-virtuoso.db: 93807 extents found
        Command being timed: "filefrag soprano-virtuoso.db"
        User time (seconds): 0.00
        System time (seconds): 338.77
        Percent of CPU this job got: 98%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 5:42.81
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 520
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 181
        Voluntary context switches: 9978
        Involuntary context switches: 1216
        Swaps: 0
        File system inputs: 150160
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0



And this is really quite high. But… I think I have a more pressing issue with 
that BTRFS /home on an Intel SSD 320 and that is that it is almost full:

merkaba:~> LANG=C df -hT /home
Filesystem               Type   Size  Used Avail Use% Mounted on
/dev/mapper/merkaba-home btrfs  254G  241G  8.5G  97% /home

merkaba:~> btrfs filesystem show
[…]
Label: home  uuid: […]
        Total devices 1 FS bytes used 238.99GiB
        devid    1 size 253.52GiB used 253.52GiB path /dev/mapper/merkaba-home

Btrfs v3.12

merkaba:~> btrfs filesystem df /home
Data, single: total=245.49GiB, used=237.07GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=4.00GiB, used=1.92GiB
Metadata, single: total=8.00MiB, used=0.00



Okay, I could probably get back 1,5 GiB on metadata, but whenever I tried a 
btrfs filesystem balance on any of the BTRFS filesystems on my SSD I usually got 
the following unpleasant result:

Halve of the performance. Like double boot times on / and such.



So I have the following thoughts:

1) I am not yet clear whether defragmenting files on SSD will really bring a 
benefit.

2) On my /home problem is more that it is almost full and free space appears 
to be highly fragmented. Long fstrim times speak tend to agree with it:

merkaba:~> /usr/bin/time fstrim -v /home
/home: 13494484992 bytes were trimmed
0.00user 12.64system 1:02.93elapsed 20%CPU (0avgtext+0avgdata 768maxresident)k
192inputs+0outputs (0major+243minor)pagefaults 0swaps

3) Turning autodefrag on might fragment free space even more.

4) I have no clear conclusion on what maintenance other than scrubbing might 
make sense for BTRFS filesystems on SSDs at all. Everything I tried either did 
not have any perceivable effect or made things worse.

Thus for SSD except for the scrubbing and the occasional fstrim I be done with 
it.


For harddisks I enable autodefrag.


But still for now this is only guess work. I don´t have much clue on BTRFS 
filesystems maintenance yet and I just remember the slogan on xfs.org wiki:

"Use the defaults."

With a cite of Donald Knuth:

"Premature optimization is the root of all evil."

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E


I would love to hear some more or less official words from BTRFS filesystem 
developers on that. But for know I think one of the best optimizations would 
be to complement that 300 GB Intel SSD 320 with a 512 GB Crucial m5 mSATA SSD 
or some Intel mSATA SSDs (but these cost twice as much), and make more free 
space on /home again. For criticial data regarding data safety and amount of 
accesses I could even use BTRFS RAID 1 then. All those MPEG3 and photos I 
could place on the bigger mSATA SSD. Granted a SSD is definately not needed for 
those, but it is just more silent. I never got how loud even a tiny 2,5 inch 
laptop drive is, unless I switched one external on while using this ThinkPad 
T520 with SSD. For the first time I heard the harddisk clearly. Thus I´d prefer 
a SSD anyway.

Still even with that highly full filesystem performance is pretty nice here. 
Except for some burts on btrfs-delalloc kernel threads once in a while. 
Especially when I fill it even a bit more. BTRFS has trouble finding free space 
on this partition. I saw this thread being active for half a minute without 
much happening on BTRFS. Thus I really think its good to get it at least to 
20-30 GiB free again. Well I could still add about 13 GiB to it if I get rid 
of a 10 GiB volume for testing out SSD caching.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
