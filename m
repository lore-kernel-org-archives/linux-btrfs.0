Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:52956 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbdJaVsR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:48:17 -0400
Received: by mail-wm0-f46.google.com with SMTP id t139so1607006wmt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com> <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
From: Dave <davestechshop@gmail.com>
Date: Tue, 31 Oct 2017 17:47:54 -0400
Message-ID: <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm following up on all the suggestions regarding Firefox performance
on BTRFS. I have time to make these changes now, but I am having
trouble figuring out what to do. The constraints are:

1. BTRFS snapshots have proven to be too useful (and too important to
our overall IT approach) to forego.
2. We do not see any practical alternative (for us) to the incremental
backup strategy
(https://btrfs.wiki.kernel.org/index.php/Incremental_Backup)
3. We have large amounts of storage space (and can add more), but not
enough to break all reflinks on all snapshots.
4. We can transfer snapshots to backup storage (and thereby retain
minimal snapshots on the live volume)
3. Our team is standardized on Firefox. (Switching to Chromium is not
an option for us.)
5. Firefox profile sync has not worked well for us in the past, so we
don't use it.
6. Our machines generally have plenty of RAM so we could put the
Firefox cache (and maybe profile) into RAM using a technique such as
https://wiki.archlinux.org/index.php/Firefox/Profile_on_RAM. However,
profile persistence is important.

The most common recommendations were to switch to Chromium, defragment
and don't use snapshots. As the constraints above illustrate, we
cannot do those things.

The tentative solution I have come up with is:

1. Continue using snapshots, but retain the minimal number possible on
the live volume. Move historical snapshots to a backup device using
btrfs send-receive.
(https://btrfs.wiki.kernel.org/index.php/Incremental_Backup)

2. Put $HOME/.cache on a separate BTRFS subvolume that is mounted
nocow -- it will NOT be snapshotted

3. Put most of $HOME on a "home" volume but separate all user
documents to another volume (i.e., "documents").

3.a. The "home" volume will retain only the one most recent snapshot
on that live volume. (More backup history will be retained on a backup
volume. ) This home volume can be defragmented. With one snapshot,
that will double our space usage, which is acceptable.

3.b. The documents volume will be snapshotted hourly and 36 hourly
snapshots plus daily, weekly and monthly snapshots retained. Therefore
it will NOT be defragmented, as that would not be practical or
space-wise possible.

3.c. The root volume (operating system, etc.) will follow a strategy
similar to home, but will also retain pre- and post- update snapshots.

4. Put the Firefox cache in RAM

5. If needed, consider putting the Firefox profile in RAM

6. Make sure Firefox is running in multi-process mode. (Duncan's
instructions, while greatly appreciated and very useful, left me
slightly confused about pulseaudio's compatibility with multi-process
mode.)

7. Check various Firefox performance tweaks such as these:
https://wiki.archlinux.org/index.php/Firefox/Tweaks

Can anyone guess whether this will be sufficient to solve our severe
performance problems? Do these steps make sense? Will any of these
steps lead to new problems? Should I proceed to give them a try? Or
can anyone suggest a better set of steps to test?

Notes:

In regard to snapshots, we must retain about 36 hourly snapshots of
user documents, for example. We have to have pre- and post- package
upgrade snapshots from at least the most recent operating system &
application package update. And we have to retain several daily,
weekly and monthly snapshots of system directories and some other
locations.) Most of these snapshots can be retained on backup storage
devices.

Regarding Firefox profile sync, it does not have an intelligent method
for resolving conflicts, for example. We found too many unexpected
changes when using sync, so we do not use it.

On Thu, Sep 21, 2017 at 7:09 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Dave posted on Wed, 20 Sep 2017 02:38:13 -0400 as excerpted:
>
>> Here's my scenario. Some months ago I built an over-the-top powerful
>> desktop computer / workstation and I was looking forward to really
>> fantastic performance improvements over my 6 year old Ubuntu machine. I
>> installed Arch Linux on BTRFS on the new computer (on an SSD). To my
>> shock, it was no faster than my old machine. I focused a lot on Firefox
>> performance because I use Firefox a lot and that was one of the
>> applications in which I was most looking forward to better performance.
>>
>> I tried everything I could think of and everything recommended to me in
>> various forums (except switching to Windows) and the performance
>> remained very disappointing.
>>
>> Then today I read the following:
>>
>>     Gotchas - btrfs Wiki https://btrfs.wiki.kernel.org/index.php/Gotchas
>>
>>     Fragmentation: Files with a lot of random writes can become
>> heavily fragmented (10000+ extents) causing excessive multi-second
>> spikes of CPU load on systems with an SSD or large amount a RAM. On
>> desktops this primarily affects application databases (including
>> Firefox). Workarounds include manually defragmenting your home directory
>> using btrfs fi defragment. Auto-defragment (mount option autodefrag)
>> should solve this problem.
>>
>> Upon reading that I am wondering if fragmentation in the Firefox profile
>> is part of my issue. That's one thing I never tested previously. (BTW,
>> this system has 256 GB of RAM and 20 cores.)
>>
>> Furthermore, on the same BTRFS Wiki page, it mentions the performance
>> penalties of many snapshots. I am keeping 30 to 50 snapshots of the
>> volume that contains the Firefox profile.
>>
>> Would these two things be enough to turn top-of-the-line hardware into a
>> mediocre-preforming desktop system? (The system performs fine on
>> benchmarks -- it's real life usage, particularly with Firefox where it
>> is disappointing.)
>>
>> After reading the info here, I am wondering if I should make a new
>> subvolume just for my Firefox profile(s) and not use COW and/or not keep
>> snapshots on it and mount it with the autodefrag option.
>>
>> As part of this strategy, I could send snapshots to another disk using
>> btrfs send-receive. That way I would have the benefits of snapshots
>> (which are important to me), but by not keeping any snapshots on the
>> live subvolume I could avoid the performance problems.
>>
>> What would you guys do in this situation?
>
> [FWIW this is my second try at a reply, my first being way too detailed
> and going off into the weeds somewhere, so I killed it.]
>
> That's an interesting scenario indeed, and perhaps I can help, since my
> config isn't near as high end as yours, but I run firefox on btrfs on
> ssds, and have no performance complaints.  The difference is very likely
> due to one or more of the following (FWIW I'd suggest a 4-3-1-2 order,
> tho only 1 and 2 are really btrfs related):
>
> 1) I make sure I consistently mount with autodefrag, from the first mount
> after the filesystem is created in ordered to first populate it, on.  The
> filesystem never gets fragmented, forcing writes to highly fragmented
> free space, in the first place.  (With the past and current effect of the
> ssd mount option under discussion to change, it's possible I'll get more
> fragmentation in the future after ssd doesn't try so hard to find
> reasonably large free-space chunks to write into, but it has been fine so
> far.)
>
> 2) Subvolumes and snapshots seemed to me more trouble than they were
> worth, particularly since it's the same filesystem anyway, and if it's
> damaged, it'll take all the subvolumes and snapshots with it.  So I don't
> use them, preferring instead to use real partitioning and more smaller
> fully separate filesystems, some of which aren't mounted by default (and
> root mounted read-only by default), so there's little chance they'll be
> damaged in a crash or filesystem bug damage scenario.  And if there /is/
> any damage, it's much more limited in scope since all my data eggs aren't
> in the same basket, so maintenance such as btrfs check and scrub take far
> less time (and check far less memory) than they would were it one big
> pool with snapshots.  And if recovery fails too, the backups are likewise
> small filesystems the same size as the working copies, so copying the
> data back over takes far less time as well (not to mention making the
> backups takes less time in the first place, so it's easier to regularly
> update them).
>
> 3) Austin mentioned the firefox cache.  I honestly wouldn't know on it,
> since I have firefox configured to use a tmpfs for its cache, so it
> operates at memory speed and gets cleared along with its memory at every
> reboot or tmpfs umount.  My inet speed is fast enough I don't really need
> cache anyway, but it's nice to have it, operating at memory speed, within
> a single boot session... and to have it cleared on reboot.
>
>
> 4) This one was the biggest one for me for awhile.
>
> Is firefox running in multi-process mode?  If you don't know, got to
> about:support, and look in the Application Basics section, at the
> Multiprocess Windows entry and the Web Content Processes entry.  When you
> have multiple windows open it should show something like 2/2 (for two
> windows open, tho you won't get 20/20 for 20 windows open) for windows,
> and n/7 (tho I believe the default is 4 instead of 7, I've upped mine)
> for content processes, with n going up toward 7 (or 4) if you have
> multiple tabs/windows open playing video or the like.
>
> If you're stuck at a single process that'll be a *BIG* drag on
> performance, particularly when playing youtube full-screen or the like.
> There are various reasons you might get stuck at a single process,
> including extensions that aren't compatible with "electrolysis" (aka e10s,
> this being the mozilla code name for multi-process firefox), and the one
> that was my problem after I ensured all my extensions were e10s
> compatible -- I was trying to run the upstream firefox binary, which is
> now pulseaudio-only (no more direct alsa support), with apulse as a
> pulseaudio substitute, and apulse is apparently single-process-only
> (forcing multi-process would crash the tabs as soon as I tried navigating
> away from about:whatever to anything remote).
>
> Once I figured that out I switched back to using the gentoo firefox ebuild
> and enabling the alsa USE flag instead of pulseaudio there.  That got
> multiprocess working, and it was was *MUCH* more responsive, as I figured
> it should be! =:^)
>
> If you find you're stuck at single process (remember, check with at least
> two windows open) and need help with it, yell.  Because it'll make a
> *HUGE* difference.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
