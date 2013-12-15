Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43511 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab3LONYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 08:24:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsBgN-0003Z7-Rf
	for linux-btrfs@vger.kernel.org; Sun, 15 Dec 2013 14:24:31 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 14:24:31 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 14:24:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocket for more than 120 seconds
Date: Sun, 15 Dec 2013 13:24:08 +0000 (UTC)
Message-ID: <pan$e9ec8$f8abd102$9f0d15ad$59d83b5d@cox.net>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	<CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans-Kristian Bakke posted on Sun, 15 Dec 2013 03:35:53 +0100 as
excerpted:

> I have done some more testing. I turned off everything using the disk
> and only did defrag. I have created a script that gives me a list of the
> files with the most extents. I started from the top to improve the
> fragmentation of the worst files. The most fragmentet file was a file of
> about 32GB with over 250 000 extents!
> It seems that I can defrag a two to three largish (15-30GB) ~100 000
> extents files just fine, but after a while the system locks up (not a
> complete hard lock, but everythings hangs and a restart is necessary to
> get a fully working system again)
> 
> It seems like defrag operations is triggering the issue. Probably in
> combination with the large and heavily fragmentet files.
> 
> I have slowly managed to defragment the most fragmented files,
> rebooting 4 times, so one of the worst files now is this one:
> 
> # filefrag vide01.mkv
> vide01.mkv: 77810 extents found 
> # lsattr vide01.mkv
> ---------------- vide01.mkv
> 
> All the large fragmented files are ordinary mkv-files (video). The
> reason for the heavy fragmentation was that perhaps 50 to 100 files were
> written at the same time over a period of several days, with lots of
> other activity going on as well. No problem for the system as it was
> network limited most of the time.
> Although defrag alone can trigger blocking, so can also straight rsync
> from another internal 1000 MB/s continous reads internal array combined
> with some random activity. It seems that the cause is just heavy IO. Is
> it possible that even though I have seemingly lots of space free in
> measured MBytes, that it is all so fragmented that btrfs can't allocate
> space efficiently enough? Or would that give other errors?
> 
> I actually downgraded from kernel 3.13-rc2 because of not being able to
> do anything else if copying between the internal arrays without btrfs
> hanging, although seemingly just temporarily and not as bad as the
> defrag blocking.
> 
> I will try to free up some space before running more defrag too, just to
> check if that is the issue.

Three points based on bits you've mentioned, the third likely being the 
most critical for this thread, plus a fourth point, not something you've 
mentioned but just in case...:

1) You mentioned compress=lzo.  It's worth noting that at present, 
filefrag interprets the file segments btrfs breaks compressed files up 
into as part of the compression process as fragments (of IIRC 128 KiB 
each, altho I'm not absolutely sure on that number), so anything that's 
compressed and over that size will be reported by filefrag as fragmented, 
even if it's not.

They're working on teaching filefrag about this sort of thing, and in 
fact I saw some proposed patches for the kernel side of things just 
yesterday, IIRC, but it'll be a few months before all the various pieces 
are in the kernel and filefrag upstreams, and it'll probably be a few 
months to a year or more beyond that before those fixes filter out to 
what the distros are shipping.

However, btrfs won't ordinarily attempt to compress known video files 
(unless the compress-force mount option is used) since they're normally 
already compressed, so that's unlikely to be the issue with your mkvs.  
Additionally, if defragging them is reducing the fragmentation 
dramatically, that's not the problem, as if it was defragging wouldn't 
make a difference.

But it might make a difference on some other files you have...

2) You mentioned backups.  Your backups aren't of the type that use lots 
and lots of hardlinks are they?  Because btrfs isn't the most efficient 
at processing large numbers of hardlinks.  For hardlink-type backups, 
etc, a filesystem other than btrfs will be preferred.  (Additionally, 
since btrfs is still experimental, it's probably a good idea to avoid 
having both your working system and backups on btrfs anyway.  Better to 
have the backups on something else, in case btrfs lives up to the risk 
level implied by its development status.)

3) Critically, the blocked task in your first post was rtorrent.  Given 
that and the filetypes (mkv video files) involved, one can guess that you 
do quite a bit of torrenting.

I'm not sure about rtorrent, but a lot of torrent clients (possibly 
optionally) pre-allocate the space required for a file, then fill in 
random individual chunks they are downloaded and written.

*** THIS IS ONE OF THE WORST USE-CASES POSSIBLE FOR ANY COPY-ON-WRITE 
FILESYSTEM, BTRFS INCLUDED!! ***

What happens is that each of those random chunk-writes creates a new 
extent, a new fragment of the file, since COW means it isn't rewritten in-
place and thus must be mapped to a new location on the disk.  If that's 
what you're doing, then no WONDER those files have so many extents -- a 
32-gig file with a quarter million extents in the worst-case you 
mentioned.  And especially on spinning rust, YES, something that heavily 
fragmented WILL trigger I/O blockages for minutes at a time!

(The other very common bad-case, tho I don't believe quite as bad as the 
torrent case as I don't think they commonly re-write the /entire/ thing, 
only large parts of it, is virtual machine images, where writes to the 
virtual disk in the VM end up being "internal file writes" in the file 
containing that image on the host filesystem.  The below recommendations 
apply there as well.)

There's several possible workarounds including turning off the pre-
allocate option in your torrent client, if possible, and several variants 
on the theme of telling btrfs not to COW those particular files so they 
get rewritten in-place instead.

3a) Create a separate filesystem for your torrent files and either use 
something other than a COW filesystem (ext4 or xfs might be usable 
options), or if you use btrfs, mount that filesystem with the nodatacow 
mount-option.

3b) Configure your btrfs client to use a particular directory (which it 
probably already does by default, but make sure all the files are going 
there -- you're not telling it to directly write some torrent downloads 
elsewhere instead), then set the NOCOW attribute on that directory.  
Newly created files in it should inherit that NOCOW.

3c) Arrange to set NOCOW on individual files before you start writing 
into them.  Often this is done by touching the file to create it, then 
setting the NOCOW attribute, then writing into the existing zero-length 
file.  The attribute needs to be set before there's data in the file -- 
setting it after the fact doesn't really help, and this is one way to do 
it (with inherit from the directory as in 3b another).  However, this 
could be impossible or at minimum rather complicated to handle with the 
torrent client, so 3a or 3b are likely to be more practical choices.

3d) As mentioned, in some clients it's possible to turn off the pre-
allocation option.  However, this can have other effects as well or pre-
allocation wouldn't be a common torrent client practice in the first 
place, so it may not be what you want in any case.  Pre-allocation is 
fine, as long as the file is set NOCOW using one of the methods above.


Of course once you have that setup, you'll still have to deal with the 
existing heavily fragmented files, but at least you won't have a 
continuing regenerating problem you have to deal with. =:^)

4) This one you didn't mention but just in case...  There have been some 
issues with btrfs qgroups that I'm not sure are fully ironed out yet.  In 
general, I'd recommend staying away from quotas and their btrfs qgroups 
implementation for now.  As with hardlink-heavy use-cases, use a 
different filesystem if you are dependent on quotes, at least for the 
time being.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

