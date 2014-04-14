Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65306 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDNHMn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 03:12:43 -0400
Received: by mail-bk0-f49.google.com with SMTP id my13so2956740bkb.36
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 00:12:42 -0700 (PDT)
Received: from [172.17.11.93] (PCX125.ipht-jena.de. [194.94.33.125])
        by mx.google.com with ESMTPSA id e5sm16139939bkg.3.2014.04.14.00.12.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 14 Apr 2014 00:12:40 -0700 (PDT)
Message-ID: <534B8A6C.4090808@xbra.de>
Date: Mon, 14 Apr 2014 09:12:44 +0200
From: =?UTF-8?B?TWF4aW1pbGlhbiBCcsOkdXRpZ2Ft?= <m@xbra.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PARTIALLY SOLVED] Btrfs RAID1 corrupted after crash
References: <CAA7TVBzRubwy-xUOGFGAJCi+mVvBBwwpqXHs9RRKxjpsrAd_=A@mail.gmail.com> <pan$b81be$f24a3d23$40041e1f$3538cdeb@cox.net>
In-Reply-To: <pan$b81be$f24a3d23$40041e1f$3538cdeb@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 14.04.2014 00:42, schrieb Duncan:
> Maximilian Bräutigam posted on Sun, 13 Apr 2014 22:18:21 +0200 as
> excerpted:
> 
>> unfortunately, I am very very deperate and I highly appreciate any help.
>> One week ago, I move my entire system to btrfs to setup a RAID1. I
>> created the RAID between device /dev/sdb and /dev/sdc with no partition
>> table on normal HDDs. Everything was working smoothly until my computer
>> crashed and at reboot I was not able to mount the device (my home dir)
>> again and got the following messages:
> 
> You did your research before switching to a new filesystem and know that 
> (as the btrfs kernel config option implies, and as the mkfs.btrfs command 
> said at least last I used it, tho that was the v3.12 version) btrfs isn't 
> entirely stable yet, and that (even more than with fully stable 
> filesystems, where the general principle still applies) you should keep 
> tested-to-be-usable backups when running it, or by action if not words, 
> you're demonstrating that you really don't care about the data you place 
> on it and don't mind if it gets trashed, right?
> 
> Good.  Then you either have a backup and can simply mkfs from your rescue 
> method and restore from that backup, or you've demonstrated by your 
> actions that the data wasn't of any major value to you anyway. No big 
> deal either way! =:^)
> 
> In case you didn't, well, you still have a reasonably good chance at 
> recovery =:^), but regardless of whether it's recovered or not, do chalk 
> this up to a learning experience and do your research and have those 
> backups ready and tested next time, OK?
> 
> [snip dmesg output from first attempt to mount]
> 
>> So I cleared the cache with trying the mount option clear_cache
> 
> Good.  First thing to try. =:^)
> 
>> but it stayed problematic and I was not able to mount it:
>>
>> [  368.159594] BTRFS: error (device sdc) in __btrfs_free_extent:5755:
>> errno=-5 IO failure
>> [  368.159602] BTRFS: error (device sdc) in
>> btrfs_run_delayed_refs:2713: errno=-5 IO failure
>> [  368.165584] BTRFS warning (device sdc): Skipping commit of aborted
>> transaction.
>> [  368.165589] BTRFS: error (device sdc) in cleanup_transaction:1545:
>> errno=-5 IO failure
>> [  368.165787] BTRFS: error (device sdc) in
>> open_ctree:2839: errno=-5 IO failure (Failed to recover log tree)
>> [  368.227161] BTRFS: open_ctree failed
> 
> OK, there's several things to try based on that output...
> 
>> Now, if I tried to mount it manually with degraded option enabled:
>>
>> # mount -t btrfs -o degraded /dev/sdb /mnt/sonst/
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>>        missing codepage or helper program, or other error
>>
>>        In some cases useful info is found in syslog - try dmesg | tail
>>        or so.
> 
> FWIW, the degraded option could be used if you didn't have both devices 
> available, but the above dmesg got beyond that, so degraded isn't likely 
> to help here.
> 
> 
>> Now I run btrfsck with repair option enabled but still I cannot mount
>> it.
> 
> That was a mistake, as you'd have known if you had read this list before 
> you tried your btrfs test.  btrfsck --repair can fix some problems, but 
> the code is rather new and not well tested and it can also make some 
> problems it doesn't know about worse, so the recommendation is to try it 
> last, after all other attempts to either fix the problem or simply 
> recover the data have failed and the next step would be a mkfs, so you're 
> not losing anything by trying it anyway.  Either that, or run it in 
> repair mode (without --repair it's OK since it's read-only and thus can't 
> do further damage) only after being told to do so by a dev who can read 
> the output from the read-only run and other diagnostics and is thus 
> relatively confident it will fix the problems without doing further 
> damage.
> 
>> Here you can find the dmesg and btrfsck outputs:
>> dmesg: http://pastebin.com/zsaKQ0h1
>> btrfsck: http://pastebin.com/xva6uJwT
>>
>> Please, help me! ;( Are there other options to investigate my RAID or to
>> even temporarily mount it to get some data? What went wrong here? What
>> can I do? Why is a simple crash making my RAID unusable? Can I use other
>> tools for a recovery?
> 
>> Archlinux, linux-3.14-5, btrfs-progs-3.14-1
> 
> Good.  You're using current kernel and tools. =:^)
> 
> As hinted above, there are indeed additional tools to try, and there's a 
> fair chance you can at least recover some/most of the data.  =:^)  Tho 
> you didn't do yourself any favors running btrfsck --repair before trying 
> them. =:^(
> 
> Please read the wiki and manpages before doing anything else so as to 
> increase the chances of recovery without further damage, but there's the 
> recovery mount option (which often works best with ro), and tools to 
> bypass the log tree and to recover from previous tree roots, among other 
> things.
> 
> wiki start page (suitable for memory or bookmarking):
> 
> https://btrfs.wiki.kernel.org
> 
> Here's the wiki's btrfsck page, which has a nice list of other things to 
> try before you use it with --repair (and a link to the page of a list 
> regular with further detail, too), but they will hopefully work afterward 
> as well.  Given the log-tree error in your dmesg, the btrfs-zero-log tool 
> might be useful.  But I'd definitely try mount -o ro,recovery first, and 
> if that works, get everything to backup before trying anything else.
> 
> https://btrfs.wiki.kernel.org/index.php/Btrfsck
> 

Hi Duncan,

I was not really afraid of my data since I have several external backups
of the important data or git repos of what I do for work. But I would
have lost some very recent photos, which would have not been nice. And I
am (still) afraid of setting up/configure a properly working home dir on
another fs again. This is just time consuming. Furthermore, I thought
that btrfs has reached a certain level of maturity and this means some
fail safety for me. But "filesystem disk format is no longer unstable"
[1] does obviously not mean that there is an intact ecosystem of repair
tools (or better said one program that simply tries its best).

I tried several things according to [2].

1) btrfs restore
Was not really working, only a few GB of my data.

2) then I realised some "transid verify failed", so I did a
btrfs-zero-log DEVICE

3) From here I was able to mount my volume again – so I could save my
latest photos. ;)

When I mount my volume with autodefrag,compress=lzo,subvolid=0, I end up
with a "rw" mounted device. Then I copy some data with e.g. rsync and it
turns to "ro" on some point. I found this while I wanted to scrub the
devices, but this is naturally only working for writable mounts. And it
is still – I don't know why – not possible to boot from the device again.

Things to do next: try again with recovery option. If this is not
working: roll back to ext4. But I really like the idea behind COW,
subvolumes, no partitioning, RAID and everything in one fs. Snapshots
against user mistakes, RAID against disk failure – perfectly save, if
there was not the fs itself.

So far, so good. The problem is, that even if I can come back to a fully
working device or RAID again, the work load (that I have to put in just
because my computer crashed) is much to high for something profound like
a home dir.

Duncan, I appreciate your email. Unfortunately, the only thing I learned
to far is to give btrfs some more decades to age. ;)

Best wishes and thanks again,
Max

[1] https://btrfs.wiki.kernel.org/index.php/Main_Page
[2] https://unix.stackexchange.com/questions/32440/how-do-i-fix-btrfs
