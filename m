Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52409 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdCOH4L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 03:56:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1co3mo-0006ZV-5D
        for linux-btrfs@vger.kernel.org; Wed, 15 Mar 2017 08:55:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Home storage with btrfs
Date: Wed, 15 Mar 2017 07:55:51 +0000 (UTC)
Message-ID: <pan$744ff$2a46570b$8511eda6$b89335f6@cox.net>
References: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hérikz Nawarro posted on Mon, 13 Mar 2017 08:29:32 -0300 as excerpted:

> Today is safe to use btrfs for home storage? No raid, just secure
> storage for some files and create snapshots from it.


I'll echo the others... but with emphasis on a few caveats the others 
mentioned but didn't give the emphasis I thought they deserved:

1) Btrfs is, as I repeatedly put it in post after post, "stabilizing, but 
not yet fully stable and mature."  In general, that means it's likely to 
work quite or even very well for you (as it has done for us) if you don't 
try the too unusual or get too cocky, but get too close to the edge and 
you just might find yourself over that edge.  Don't worry too much, tho, 
those edges are clearly marked if you're paying attention, and just by 
asking here, you're already paying way more attention than too many we 
see here... /after/ they've found themselves over the edge.  That's a 
_very_ good sign. =:^)

2) "Stabilizing, not fully stable and mature", means even more than ever, 
if you value your data more than the time, hassle and resources necessary 
to have backups, you HAVE them, tested and available for practical use 
should it be necessary.

Of course any sysadmin (and that's what you are for at least your own 
systems if you're making this choice) worth the name will tell you the 
value of the data is really defined by the number of backups it has, not 
by any arbitrary claims to value absent those backups.  No backups, you 
simply didn't value the data enough to have them, whatever claims of 
value you might otherwise try to make.  Backups, you /did/ value the data.

And of course the corollary to that first sysadmin's rule of backups is 
that an untested as restorable backup isn't yet a backup, only a 
potential backup, because the job isn't finished and it can't be properly 
called a backup until you know you can restore from it if necessary.

And lest anyone get the wrong idea, a snapshot is /not/ a backup for 
purposes of the above rules.  It's on the same filesystem and hardware 
media and if that goes down... you've lost it just the same.  And since 
that filesystem is still stabilizing, you really must be even more 
prepared for it to go down, even if the chances are still quite good it 
won't.

3) "Stabilizing, not fully stable and mature", also means that since the 
current best-practices code is still a moving target, you better be 
prepared to move with it.  The list-recommended kernels are the latest 
two releases of either the current or (mainline) LTS kernel series.  On 
the current track, 4.10 is out, so 4.10 and 4.9 are supported.  If you're 
still on 4.8 or earlier and can't point to a very specific known reason, 
you're behind.  On the LTS track, 4.9 is the latest LTS kernel as well, 
with 4.4 the one before that.  4.1's the one before that but that's a 
very long time ago in btrfs-development time, and while we'll generally 
still /try/ to help, honestly, our memory and thus our effectiveness at 
trying to help are going to be down dramatically from that of the 
recommended series.

If you prefer longer term "enterprise" or just Debian-stable distro 
support, fine, but honestly, the sort of stability they target doesn't 
have much in common with a still stabilizing btrfs, and the chances are 
/extremely/ high that either one or the other isn't a good match for your 
needs.   Either you want/need a more leading edge aka current distro 
which btrfs as still stabilizing fits in well with, or you want/need the 
stability of those longer term releases, and btrfs as still very actively 
stabilizing sticks out like a sore thumb and you're very likely to be 
better off on something that's actually considered stable, ext4 or xfs, 
perhaps, or my longer term stability favorite, reiserfs (which tends to 
be so stable in part because there's nobody screwing with it and messing 
things up, any more, reference the period when the mainline kernel devs 
switched the otherwise quite stable ext3 to the rather less stable 
data=writeback mode, for instance).

4) Keep the number of snapshots per subvolume under tight control as 
already suggested.  A few hundred, NOT a few thousand.  Easy enough if 
you do those snapshots manually, but easy enough to get thousands if 
you're not paying attention to thin out the old ones and using an 
automated tool such as snapper.

5) Stay away from quotas.  Either you need the feature and thus need a 
more mature filesystem where it's actually stable and does what it says 
on the label, or you don't, in which case you'll save yourself a /lot/ of 
headaches keeping them off.  Maybe someday...

6) Stay away from raid56 mode.  It has known problems ATM and is simply 
not ready.

FWIW, single-device and raid1 mode are the best tested and most reliable 
(within the single-device limitations for it, of course).  But even raid1 
mode has some caveats about rebuilding that it might be wise to 
familiarize yourself with /before/ they happen, if you're going to be 
using it, of course.

7) Keep your filesystem sizes manageable.  If it's going to take a week 
to btrfs check --repair, it's likely to be faster restoring from those 
backups (or simply doing a fresh mkfs and eating the lost data if it 
wasn't worth keeping backups to restore from).

I'm definitely on the low end here, but I have multiple independent btrfs 
on (partitioned) SSD, with none of the filesystems over 50 GiB.  For 
most, a more realistic size might be several hundred GiB to a TiB.  Above 
that, particularly since above that's likely to the the far slower 
spinning rust as opposed to the SSDs I'm using.  Yes, people use multi-TB 
btrfs, and yes, it works for many of them, but yes too, I've seen people 
posting maintenance times in the weeks and higher.  Is that really 
practical for you?  Maybe; it's definitely NOT for me, tho.  (FWIW, full 
balances, scrubs, checks, etc, on my btrfs', tend to take under a minute 
per filesystem.  I remember hours for md-raid repair back in the day, and 
it was acceptable then, but SSDs have spoiled me.  But days... even back 
then I think I'd have perhaps done it once, but after that, finding 
something or some way more efficient would have definitely been top of my 
priority list!)

Here is where quotas and thousands of snapshots will eat you alive, as 
simply put, neither one scales out very well.  But disabling quotas and 
keeping snapshots to 2-300 per subvolume will help *dramatically*.

8) If your use-case involves multi-gig VMs or DBs, consider nocow for 
them.  But do your research as nocow has some side-effects that make 
choosing nocow less straightforward than you might expect.

9) You may want to consider using the autodefrag mount option from the 
start, so the very first things you copy onto the filesystem are done 
with autodefrag.  In limited circumstances it may not be the right 
choice, but for general-purpose use, I'd recommend it.

10) Spend some time familiarizing yourself with the btrfs fi show/df/
usage commands.  They reveal a lot about the filesystem if you know how 
to read them, and posting their output is one of the first orders of 
business on any trouble report here.  (Note that btrfs fi show is perhaps 
the least informative of the three on its own, but is the only one that 
can be run on an unmounted filesystem.  It and btrfs fi df (not normal 
df, which is a bit quirky on btrfs) together provide about the same 
information as btrfs fi usage does, so usage is the preferred report if 
the filesystem is mountable.)

Similarly of course for the subvolume/snapshot report commands if you use 
those features.  My btrfs use-case doesn't (tho the feature is considered 
stable enough I certainly would if needed, just keep the numbers 
reasonable), so I don't personally know much about them.

And if you've not already discovered it, https://btrfs.wiki.kernel.org  
Spend some time reading up. =:^)

That's the whirlwind tour.  If it hasn't scared you off, welcome aboard! 
=:^)  If it has, that's fine; you can check back on btrfs in say five 
years, when it should have matured quite a bit. Meanwhile, there's no 
harm and for some quite some wisdom in sticking with something more 
mature for the time being. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

