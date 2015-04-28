Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36421 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440AbbD1MjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 08:39:12 -0400
Received: by wgen6 with SMTP id n6so149721002wge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 05:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$a40d6$92516c5$38662177$7c6f432f@cox.net>
References: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
 <pan$a40d6$92516c5$38662177$7c6f432f@cox.net>
From: Ermanno Baschiera <ebaschiera@gmail.com>
Date: Tue, 28 Apr 2015 14:38:50 +0200
Message-ID: <CAGMbsDWLz=v+o5g8vut2H7bGtA-XOJoSjnhea3CV-jjpJ3UvWQ@mail.gmail.com>
Subject: Re: help on broken file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your support, Duncan, and for your clear explanation
about the concept of backup. I have very few data in that file system
that I would miss if lost, because basically that file system serves
as backup server and generic file storage. At the early stage of the
incident, I was hoping to restore the machine fully up and running,
but later on I understood that recovering data and reinstall the
server was the only reachable target.

Back on topic, I took a read of the "btrfs restore" man page and found
the "-i" option, which make the process continue even if errors are
encountered. I did not manage to run a full restore till the end yet
(it will take a full day at least and I had to stop it), but I got
already encouraging results. Many files have been successfully
recovered. So I will go that way.

I'm still convinced that Btrfs is a good option for me, even after
this incident, and I'm pretty sure that a new file system install,
with latest tools, will be stronger than my file system was.


2015-04-28 8:27 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> Ermanno Baschiera posted on Mon, 27 Apr 2015 15:39:14 +0200 as excerpted:
>
>> I have a 3 disks file system configured in RAID1, created with Ubuntu
>> 13.10 (if I recall correctly). Last friday I upgraded my system from
>> Ubuntu 14.10 (kernel 3.16.0) to 15.04 (kernel 3.19.0). Then I started to
>> notice some malfunctions (errors on cron scripts, my time machine asking
>> to perform a full backup, high load, etc.). On saturday I rebooted the
>> system and it booted in readonly. I tried to reboot it and it didn't
> boot
>> anymore, stuck at mounting the disks.
>> So I booted with a live Ubuntu 15.05 which could not mount my disks,
>> even with "-o recovery,". Then I switched to Fedora beta with kernel
>> 4.0.0-0.rc5. I did a "btrfs check" and got a lot of "parent transid
> verify
>> failed on 8328801964032 wanted 1568448 found 1561133".
>> Reading on docs and Stack Exchange, I decided to try a "btrfs restore"
>> to backup my data. Having not a spare disk, and being the file system a
>> RAID1, I decided to use one of the 3 disks as target for the restore. I
>> formatted it in EXT4 and tried the restore. The process stopped after
> one
>> minute, ending with errors.
>> Then I tried to "btrfs-zero-log" the file system, but I noticed that
>> running it multiple times, it was giving me the same amount of messages,
>> making me think it wasn't fixing anything.
>> So I run a "btrfs rescue chunk-recover". After that, I still not being
>> able to mount the system (with parameters -o recovery,degraded,ro).
>> I'm not sure about what to do now. Can someone give me some advice?
>> My possible steps are (if I understand correctly):
>> - try the "btrfs rescue super-recover"
>> - try the "btrfs check --repair"
>
> Sysadmin's backup rule of thumb:  If the data is valuable to you, it's
> backed up.  If it's not backed up, by definition, you consider it less
> valuable to you than the time and money you're saving by not backing it
> up, or it WOULD be backed up.  No exceptions.
>
> And the corollary:  A backup is not a backup until you have tested your
> ability to actually use it.  An untested "will-be backup" is therefore
> not yet a backup, as the backup job is not yet completed until it is
> tested usable.
>
> Given that btrfs isn't yet fully stable and mature, those rules apply to
> it even more than they apply to other, more stable and mature filesystems.
>
> So... no problem.  If you have a backup, restore from it and be happy.
> If you don't, as seems to be the case, then by definition, you considered
> the time and money saved by not doing that backup more valuable than the
> data, and you still have that time and money you saved, so again, no
> problem.
>
>
> OK, so you unfortunately may have learned that the hard way...  Lesson
> learned, is there any hope?
>
> Actually, yes, and you were on the right track with restore, you just
> haven't gone far enough with it yet, using only its defaults, which as
> you've seen, don't always work.  But with a strong dose of patience, some
> rather fine-point effort, and some luck... hopefully... =:^)
>
> The idea is to use btrfs-find-root along with the advanced btrfs restore
> options to find an older root commit (btrfs' copy-on-write nature means
> there's generally quite a few older generations still on the device(s))
> that contains as much of the data you're trying to save as possible.
> There's a writeup on the wiki about it, but last I checked, it was rather
> outdated.  Still, you should be able to use it as a start, and with some
> trial and error...
>
> https://btrfs.wiki.kernel.org/index.php/Restore
>
> Basically, your above efforts stopped at the "really lucky" stage.
> Obviously you aren't that lucky, so you gotta do the "advanced usage"
> stuff.
>
> A few hints that I found helpful last time I had to use it.[1]
>
> * Use current btrfs-progs for the best chance at successful restoration.
> As of a few days ago, that was v3.19.1, the version I'm referring to in
> the points below.
>
> * "Generation" and "transid" (transaction ID) are the same thing.
> Fortunately the page actually makes this a bit more explicit than it used
> to, as this key to understanding the output, which also makes it worth
> repeating, just in case.
>
> * Where the page says pick the tree root with the largest set of
> filesystem trees, use restore's -l option to see those trees.  (The page
> doesn't say how to see the set, just to use the largest set.)
>
> * Use btrfs-show-super to list what the filesystem thinks is the current
> transid/generation, and btrfs-find-root to find older candidate
> transids.
>
> * Feed the bytenrs (byte numbers) from find-root to restore using the -t
> option (as the page mentions), first with -l to see if it gives you a
> full list of filesystem trees, then with -D (dry run, which didn't exist
> when the page was written) to see if you get a good list of files.
>
> * Restore's -D (dry run) can be used to see what it thinks it can
> restore.  It's a file list so will likely be long.  You thus might want
> to redirect it to a file or pipe it to a pager for further examination.
>
> * In directories with lots of files, restore will loop enough it can
> think it's not making progress, and will prompt you to continue or not.
> You'll obviously want to continue if you want all the files in that dir
> restored.  (Back when I ran it, it just gave up, and I had to run it
> repeatedly, getting more files each time, to get them all.)
>
> * Restore currently only restores file data, not metadata like dates,
> ownership/permission, etc, and not symlinks.  Files are written as owned
> by the user and group (probably root:root ) you're running restore as,
> using the current UMASK.  When I ran restore, since I had a stale backup
> as well, I whipped up a script to compared to it, and where the file
> existed in the backup too, the script used the backup file as a reference
> to reset ownership/perms.  That left only the files new enough not to be
> in the backup to deal with, and there were relatively few of those.  I
> had to recreate the symlinks manually.
>
> There are still very new (less than a week old) patches on the list that
> let restore optionally restore ownership/perms/symlinks, too.  Depending
> on what you're restoring, it may be well worth your time to rebuild btrfs-
> progs with these patches applied, letting you avoid having to do the
> fixups I had to do when I had to use restore.
>
>
>
> Given enough patience and the technical literacy to piece things together
> from the outdated page, the above hints, and the output as you get it,
> chances are reasonably good that you'll be able to successfully restore
> most of your files.  Btrfs' COW nature makes the techniques restore uses
> surprisingly effective, but it does take a bit of reading between the
> lines to figure things out, and nerves of steel while you're working on
> it.  The exception would be a filesystem that's simply so heavily damaged
> there's just not enough of the trees, of /any/ generation, left to make
> sense of things.
>
> ---
> [1] FWIW, I had a backup, but it wasn't as current as I wanted, and it
> turned out restore gave me newer copies than my stale backup of many
> files.  In keeping with the above rule, the data was valuable enough to
> me to back it up, but obviously not valuable enough to me to consistently
> update that backup...  If I'd have lost everything from the backup on,
> I'd have been not exactly happy, but I'd have considered it fair for the
> backup time/energy/money invested.  Restore thus simply let me get a
> better deal than I actually deserved... which actually happens enough
> that I'm obviously willing to play the odds...
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
