Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55482 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3F3VUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 17:20:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UtP36-0000kD-M3
	for linux-btrfs@vger.kernel.org; Sun, 30 Jun 2013 23:20:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 23:20:44 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 23:20:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unclean shutdown and space cache rebuild
Date: Sun, 30 Jun 2013 21:20:26 +0000 (UTC)
Message-ID: <pan$11aaf$ca21b34a$6b343753$2a7ad2d@cox.net>
References: <11441914.sRzrmH57Vq@bheem> <4774295.3Q3X7zsTmb@vfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Garry T. Williams posted on Sun, 30 Jun 2013 13:53:48 -0400 as excerpted:

> I suspect this is, at least in part, related to severe fragmentation in
> /home.
> 
> There are large files in these directories that are updated frequently
> by various components of KDE and the Chrome browser.  (Firefox has its
> own databases that are frequently updated, too.)
> 
>     ~/.local/share/akonadi
>     ~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend
>     ~/.cache/chromium/Default/Cache ~/.cache/chromium/Default/Media\
>     Cache
> 
> I improved performance dramatically (orders of magnitude) by copying the
> database files into an empty file that was modified with:
> 
>     chattr -C
> 
> and renaming to make the files no COW.  (Note that this is the only way
> to change an existing file to no COW.)  I also set the same attribute on
> the owning directories so that all new files inherit the no COW
> attribute.
> 
> I suspect there are other files that fragment badly since I see periods
> of high disk activity coming back slowly over a few weeks of use after
> making the modifications above.  I intend to track them down and do the
> same.

This definitely won't be practical for everyone, but...

1) I run kde here, but switched away from kmail, akregator, basically 
anything kdepim related, when that akonadified.  I had been using kmail 
for nearly a decade, and it had converted MSOE mail in it from before the 
turn of the century (!!), but one day when akonadi simply lost an email 
for the Nth time in so many days, the question occurred to me, why do I 
put up with this when there's so many sane alternatives?  Yes, I could 
have probably recovered that mail as I had others by redoing the akonadi 
resources or whatever, but the question was, why should I *HAVE* to, 
again, when there's all sorts of saner alternatives that, like kmail 
before the akonadi insanity, didn't lose mail in the first place?

So I switched, choosing claws-mail to replace both kmail and akregator 
here, FWIW, but there's other alternatives for those who don't like claws-
mail.

And when I switched that off, I began wondering about semantic-desktop at 
all, even tho it was run-time switched off.  So being a gentooer who had 
the option, I set USE=-semantic-desktop and a few other flags and rebuilt 
the affected bits of kde.  Now no more semantic-desktop AT ALL! =:^)  
(Unfortunately, the gentoo/kde folks decided to kill the option and hard-
enable semantic-desktop for the coming 4.11, which I'm running the betas 
of ATM, but using the diffs between the 4.10 ebuilds with the option and 
4.11 builds without, I was able to patch out the the support, so now run 
with semantic-desktop build-time hard-disabled (instead of the normal 
gentoo 4.11 hard-enabled) here.

So no gigabytes of nepomuk and akonadi files doing nothing but create 
problems for me, here!  I do run firefox, but haven't seen a problem with 
it, either, possibly due to #2...

2) Throw hardware at the problem.  About a month ago I finally bit the 
financial bullet and upgraded to (mostly) SSD.  My media partition and 
backups are still on spinning rust (on reiserfs since btrfs is still 
experimental), but the main system and /home are now on dual (fairly 
fast, Corsair Neutron) SSD, on btrfs in raid1 mode (both data/metadata).

That's actually why I'm running btrfs here, as my old standby, reiserfs, 
while highly reliable on spinning rust (yes, I know the rumors, but after 
a decade on reiserfs on spinning rust, it has been /extremely/ reliable 
for me, at least it has been since the data=ordered switch in kernel 
2.6.16 IIRC, even thru various hardware issues!), isn't particularly 
appropriate for SSD.

So I run btrfs, which detects my SSDs and activates SSD mode 
automatically, here.  I use dual SSDs in btrfs raid1 mode, in ordered to 
take advantage of btrfs data integrity with the checksumming.

And with the SSDs, there's no mechanical seek latency and the IOPS are 
high enough that, at least with the btrfs autodefrag mount option 
activated from the beginning, I've seen no noticeable fragmentation 
slowdowns either.  (It may also help that I'm close to 100% 
overprovisioned on the SSDs as my effectively write-once-read-many media 
and backups remain on reiserfs on the spinning rust, so even without the 
trim option, the SSDs have plenty of room to do their write-management.)

What I've noticed most is that the stuff that small, often written files 
that caused fragmentation issues on reiserfs on spinning rust, generally 
aren't an issue at all on btrfs on SSD.  This includes my main gentoo 
package tree and overlays, my git kernel checkout, and pan's nntp message 
cache (by default 10 MB with two-week header expiry, but I'm running 
nearly a gig of text messages with no expiry, with messages on some gmane 
mailing-list groups I follow going back to 2002).  All these are an order 
of magnitude at least faster on btrfs on the SSDs than they were on 
reiserfs on spinning rust, without the slowdowns I saw due to 
fragmentation on spinning rust, either.

So that has been my answer to the fragmentation issue.  The space-cache 
issue of the OP may be different.  I had some problems with that and 
unclean shutdown when I first experimented with btrfs a bit over a year 
ago (still on spinning rust at the time), but I decided it wasn't ready 
for me then and waited a year, and I haven't had problems this go-round.  
I've only had a couple unclean shutdowns, however, but the system did 
seem to come right back up afterward.  The SSDs may be playing some role 
in that too, tho.  But I've really not had enough unclean shutdowns to be 
sure, yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

