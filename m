Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37249 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbbHCFRk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Aug 2015 01:17:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZM882-0006Up-4e
	for linux-btrfs@vger.kernel.org; Mon, 03 Aug 2015 07:17:38 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 07:17:38 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 07:17:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
Date: Mon, 3 Aug 2015 05:17:31 +0000 (UTC)
Message-ID: <pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sonic posted on Sun, 02 Aug 2015 13:13:41 -0400 as excerpted:

> I have had bad dreams about this particular fat finger but after a few
> years it has finally happened.
> 
> Scenario: 2 drives in a raw btrfs array (no previous partitions and
> non-redundant) with various subvols as well. One was sdc the other was
> sde, although sde never displays with mount command and blkid is the
> same for both.
> 
> Thinking I was writing to a flash drive I sent 32MB via dd
> ===========================
> dd if=file of=/dev/sde
> ===========================
> to sde (instead of what I wanted - sdf) and now the volume nor any of
> it's subvol's can mount (of course that seems entirely reasonable,
> although you can imagine how unhappy I am).

> [...]

> Obligatory details:
> ===========================
> uname -a
> Linux sartre 4.1.3-gentoo [...]
> ===========================
> btrfs --version
> btrfs-progs v4.1.2
> ===========================
> btrfs fi show
> [...]
> warning, device 2 is missing
> bytenr mismatch, want=20971520, have=0
> Couldn't read chunk root
> Label: 'terrafirm'  [...]
>         Total devices 2 FS bytes used 6.40TiB
>         devid    1 size 3.64TiB used 3.21TiB path /dev/sdc
>         *** Some devices missing
> [...]

Of course the first thing is sysadmin's backups rule -- if you don't have 
it backed up, by definition and action, that data is worth less to you 
than the time/effort/media to back it up, any claims to the contrary not 
withstanding, as your actions spoke louder than your words.

And of course btrfs isn't fully stable yet, so that rule applies double, 
compared to a fully mature and stable filesystem.

Therefore, you're in luck.  Either you didn't lose anything of value 
because you had it backed up, or it wasn't of /that/ much value to you 
anyway, so again, you didn't lose anything of value. =:^)

(And actually, that's truer than you might think at the moment.  Consider 
my next-door neighbor, who a couple weeks ago escaped a fire with his 
life and the pair of shorts he was wearing.  No wallet, no keys, 
nothing.  I don't think he's going to be worrying much about that last 
fat-fingering he did on the computer for awhile!  If you have your life, 
your health, a roof over your head, and either food on the kitchen 
shelves or money to eat out with, you're a lucky one!  They say everybody 
fat-fingers at some point and has to learn the value of those backups the 
hard way.  Now you have that behind you. =:^)  I've been there too, and a 
bit of perspective really does help.)


Beyond that...

You're running current kernel and userspace/progs already, good job 
there. =:^)

The first thing you need to do in terms of trying to recover, is restore 
the superblock on the damaged device.  Since btrfs keeps multiple copies 
(up to three, once the filesystem is large enough, as yours is) per 
device, that's actually relatively easy.  Use...

btrfs rescue super-recover

... for that.  Being a gentooer (as am I), I'm confident you can read the 
manpage for the details.  =:^)  You can use...

btrfs-show-super

... to examine the various superblock copies in ordered to pick a good 
one to restore.


Beyond that, as a simple btrfs user and list regular who hasn't had that 
particular problem here (my brown-bag day was a different fat-fingering!
), not a dev, I'm a bit beyond my depth, but were it me, at that point 
I'd see what I had, then try...

btrfs restore

There's a page on the wiki with details on how to try to get it to work 
manually, if it's not going to work automatically for you:

https://btrfs.wiki.kernel.org/index.php/Restore

I've used it here (tho not in the situation you're in) when I had 
backups, but they were a bit stale.  Basically, I valued the data enough 
to have backups, but valued saving the hassle over keeping them current, 
given the amount of actually changed data.  Still, since restore worked 
for me and thus gave me the choice of somewhat stale backups, or rather 
less stale btrfs restore, I took less stale. =:^)

The nice thing about restore, other than that it often works when the 
filesystem won't mount, is that it doesn't write to the damaged 
filesystem at all, so there's no chance of making the problem worse 
instead of better.  Restore simply reads what files it can get, restoring 
them to some other (working and mounted) filesystem.  So you'll need some 
alternate place to store all those files...

Tho the wiki is somewhat behind current code, so read the manpage for 
more useful options.  In particular, the dry-run option can give you a 
good idea whether you're going to get much of anything useful with that 
generation/transid, or not, and there's now options to restore metadata 
(ownership and permissions) and symlinks, as well as the file data 
itself.  Also, where it talks about picking a tree root with as many of 
the filesystem trees as possible, use the list-roots option.  This is 
what displays all those trees it's talking about.


If restore worked for you, you have a choice.  What I've done at that 
point, since I was reasonably happy with the result as I got pretty much 
everything back using restore, is simply blow away the damaged 
filesystem, and start over, fresh mkfs.btrfs, etc.  For me, that was the 
simplest.  If it didn't work (still too damaged) or it did but you want 
to continue...

Next, if you want more than one chance at things, it's time to copy the 
filesystem's raw devices elsewhere, so you have a backup copy of the raw 
devices in case you screw up the one you're experimenting with even 
worse.  dd each filesystem component device to some other storage, for 
that raw backup.

This is where I start going beyond my depth...  If you had no backups and 
restore hasn't worked on it at this point, you may well want to wait for 
a second opinion.  If he answers, I'd put Hugo Mills' answers at 
priority, else Chris Murphy or others.

Once that's done, or if you decide to skip it and have only one go at 
things, if it were me, /I/ would try...

btrfs rescue chunk-recover

... next.  After that, hopefully at least restore will work, if it didn't 
before.   There's also some stuff possible with btrfs check, but again, 
this is getting beyond my level, and it's going pretty vague and hand-
wavy at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

