Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36720 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbdCOW0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 18:26:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1coHNO-0004j7-PL
        for linux-btrfs@vger.kernel.org; Wed, 15 Mar 2017 23:26:38 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Home storage with btrfs
Date: Wed, 15 Mar 2017 23:26:32 +0100
Message-ID: <20170315232632.61ab02ea@jupiter.sol.kaishome.de>
References: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
        <pan$744ff$2a46570b$8511eda6$b89335f6@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 15 Mar 2017 07:55:51 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Hérikz Nawarro posted on Mon, 13 Mar 2017 08:29:32 -0300 as excerpted:
> 
> > Today is safe to use btrfs for home storage? No raid, just secure
> > storage for some files and create snapshots from it.  
> 
> 
> I'll echo the others... but with emphasis on a few caveats the others 
> mentioned but didn't give the emphasis I thought they deserved:
> 
> 1) Btrfs is, as I repeatedly put it in post after post, "stabilizing,
> but not yet fully stable and mature."  In general, that means it's
> likely to work quite or even very well for you (as it has done for
> us) if you don't try the too unusual or get too cocky, but get too
> close to the edge and you just might find yourself over that edge.
> Don't worry too much, tho, those edges are clearly marked if you're
> paying attention, and just by asking here, you're already paying way
> more attention than too many we see here... /after/ they've found
> themselves over the edge.  That's a _very_ good sign. =:^)

Well, bugs can hit you with every filesystem. Nothing as complex as a
file system can ever be proven bug free (except FAT maybe). But as a
general-purpose-no-fancy-features-needed FS, btrfs should be on par
with other FS these days.

> 2) "Stabilizing, not fully stable and mature", means even more than
> ever, if you value your data more than the time, hassle and resources
> necessary to have backups, you HAVE them, tested and available for
> practical use should it be necessary.

This is totally not dependent on "stabilizing, not fully stable and
mature". If you data matters to you, do backups. It's that simple. If
you don't do backups, your data isn't important - by definition.

> Of course any sysadmin (and that's what you are for at least your own 
> systems if you're making this choice) worth the name will tell you
> the value of the data is really defined by the number of backups it
> has, not by any arbitrary claims to value absent those backups.  No
> backups, you simply didn't value the data enough to have them,
> whatever claims of value you might otherwise try to make.  Backups,
> you /did/ value the data.

Yes. :-)

> And of course the corollary to that first sysadmin's rule of backups
> is that an untested as restorable backup isn't yet a backup, only a 
> potential backup, because the job isn't finished and it can't be
> properly called a backup until you know you can restore from it if
> necessary.

Even more true. :-)

> And lest anyone get the wrong idea, a snapshot is /not/ a backup for 
> purposes of the above rules.  It's on the same filesystem and
> hardware media and if that goes down... you've lost it just the
> same.  And since that filesystem is still stabilizing, you really
> must be even more prepared for it to go down, even if the chances are
> still quite good it won't.

A good backup should follow the 3-2-1 rule: Have 3 different backup
copies, 2 different media, and store at least 1 copy external/off-site.

For customers, we usually deploy a strategy like this for Windows
machines: Do one local backup using Windows Image Backup to a local
NAS to backup from inside the VM, use a different software to do image
backups from outside of the VM to the local NAS, mirror the "outside
image" to a remote location (cloud storage). And keep some backup
history. Overwriting the one existing backup with a new one won't help
you anything. All involved software should be able to do efficient
delta backups, otherwise mirroring offsite may be no fun.

In linux, I'm using borgbackup and rsync to have something similar.
Using borgbackup to a local storage, and syncing it offsite with rsync
gives me the 2-1 rule part. You can get the third rule by using rsync
to also mirror the local FS off the machine. But that's usually
overkill for personal backups. Instead, I only have a third copy of
most valuable data like photos, dev stuff, documents, etc.

BTW: For me, different media also means different FS types. So a bug in
one FS wouldn't easily hit the other.

[snip]

> 4) Keep the number of snapshots per subvolume under tight control as 
> already suggested.  A few hundred, NOT a few thousand.  Easy enough
> if you do those snapshots manually, but easy enough to get thousands
> if you're not paying attention to thin out the old ones and using an 
> automated tool such as snapper.

Borgbackup is so fast and storage efficient that you could run it easily
multiple times per day. That in turn means I don't need to rely on
regular snapshots to undo mistakes. I only use snapshots before doing
some knowingly risky stuff to have fast recovery. But that's all,
nothing else should snapshots before (except you are doing more
advanced stuff like container cloning, VM instance spawning, ...).

> 5) Stay away from quotas.  Either you need the feature and thus need
> a more mature filesystem where it's actually stable and does what it
> says on the label, or you don't, in which case you'll save yourself
> a /lot/ of headaches keeping them off.  Maybe someday...

Meanwhile, one could work with underprovisioned LVM and create multiple
small btrfs on it, and expand when needed. Tho, personally I'd stick
with one big btrfs as btrfs still has issues when running out of space
with no easy way out.

In case, one such a split FS breaks down, your backups won't fit
anyways usually: When you restore only one volume back into your
system, it may not fit the rest of the system because packages on the
other volumes may be at another point in time than what you are
currently restoring.

So, I'd recommend to partition only for the sake of keeping root,
var/log and home separated. But it may come with a performance penalty
if all partitions share the same media, at least when media == HDD.

Better use a second partition for a small rescue system with the most
important tools (and keep that updated).

[snip]

> FWIW, single-device and raid1 mode are the best tested and most
> reliable (within the single-device limitations for it, of course).
> But even raid1 mode has some caveats about rebuilding that it might
> be wise to familiarize yourself with /before/ they happen, if you're
> going to be using it, of course.

Using 3-device btrfs mraid1 draid0 here on top of bcache, usually
without problems. Those problems I had are not related to btrfs raid
code I guess...

> 7) Keep your filesystem sizes manageable.  If it's going to take a
> week to btrfs check --repair, it's likely to be faster restoring from
> those backups (or simply doing a fresh mkfs and eating the lost data
> if it wasn't worth keeping backups to restore from).

Don't fix it, restore it, except you want to support the devs. A proper
FS shouldn't need a repair tool, a proper FS should stay in order and
fix smallish problems online and by itself. Fsck is not there to
recover data, that is what backups are for.

I think this is why btrfs was lacking a repair tool for so long: They
wanted to do it right. ;-)

> I'm definitely on the low end here, but I have multiple independent
> btrfs on (partitioned) SSD, with none of the filesystems over 50
> GiB.  For most, a more realistic size might be several hundred GiB to
> a TiB.  Above that, particularly since above that's likely to the the
> far slower spinning rust as opposed to the SSDs I'm using.  Yes,
> people use multi-TB btrfs, and yes, it works for many of them, but
> yes too, I've seen people posting maintenance times in the weeks and
> higher.  Is that really practical for you?  Maybe; it's definitely
> NOT for me, tho.  (FWIW, full balances, scrubs, checks, etc, on my
> btrfs', tend to take under a minute per filesystem.  I remember hours
> for md-raid repair back in the day, and it was acceptable then, but
> SSDs have spoiled me.  But days... even back then I think I'd have
> perhaps done it once, but after that, finding something or some way
> more efficient would have definitely been top of my priority list!)

Running on 3x 1TB here with 500GB SSD bcache. The HDDs are 1.8TB full.
A complete first time backup with borgbackup takes almost 24 hours,
successive runs take 15-20 minutes. A full restore takes almost 48
hours. I guess a btrfs repair could run longer (and probably not fix
most problems that occurred when I really need my data). So, restore
from backup is the first choice. It also gets you back a clean FS. The
repair tool may miss some corner cases and you still have corruptions
without knowing, maybe even overwriting good files in the backups with
broken files from such a repaired filesystem.

> 8) If your use-case involves multi-gig VMs or DBs, consider nocow for 
> them.  But do your research as nocow has some side-effects that make 
> choosing nocow less straightforward than you might expect.

For VMs I really recommend nocow as btrfs has bugs for me otherwise
(tho, I think this has been fixed according to one poster here).

> 9) You may want to consider using the autodefrag mount option from
> the start, so the very first things you copy onto the filesystem are
> done with autodefrag.  In limited circumstances it may not be the
> right choice, but for general-purpose use, I'd recommend it.

I can second this. Even on SSD, this helps.

[snip]

-- 
Regards,
Kai

Replies to list-only preferred.


