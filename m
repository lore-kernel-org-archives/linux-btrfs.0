Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45494 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbcDDVAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 17:00:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anBbb-0006dt-Hf
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 23:00:15 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 23:00:15 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 23:00:15 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Mon, 4 Apr 2016 23:00:08 +0200
Message-ID: <20160404230008.5e7b28fe@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
	<20160404213637.58ad33b1@jupiter.sol.kaishome.de>
	<CAJCQCtQdGG3o9mu2u=Vjc0rN+0eLWYVXikH5KtfOap2SijjSKA@mail.gmail.com>
	<20160404225018.150988d2@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 22:50:18 +0200
schrieb Kai Krakow <hurikhan77@gmail.com>:

> Am Mon, 4 Apr 2016 13:57:50 -0600
> schrieb Chris Murphy <lists@colorremedies.com>:
> 
> > On Mon, Apr 4, 2016 at 1:36 PM, Kai Krakow <hurikhan77@gmail.com>
> > wrote:
> >   
> > >    
> >  [...]    
>  [...]  
> > >
> > > In the following sense: I should disable the automounter and
> > > backup job for the seed device while I let my data migrate back
> > > to main storage in the background...    
> > 
> > The sprout can be written to just fine by the backup, just
> > understand that the seed and sprout volume UUID are different. Your
> > automounter is probably looking for the seed's UUID, and that seed
> > can only be mounted ro. The sprout UUID however can be mounted rw.
> > 
> > I would probably skip the automounter. Do the seed setup, mount it,
> > add all devices you're planning to add, then -o
> > remount,rw,compress... , and then activate the backup. But maybe
> > your backup also is looking for UUID? If so, that needs to be
> > updated first. Once the balance -dconvert=raid1 and -mconvert=raid1
> > is finished, then you can remove the seed device. And now might be
> > a good time to give the raid1 a new label, I think it inherits the
> > label of the seed but I'm not certain of this.
> > 
> >   
> > > My intention is to use fully my system while btrfs migrates the
> > > data from seed to main storage. Then, afterwards I'd like to
> > > continue using the seed device for backups.
> > >
> > > I'd probably do the following:
> > >
> > > 1. create btrfs pool, attach seed    
> > 
> > I don't understand that step in terms of commands. Sprouts are made
> > with btrfs dev add, not with mkfs. There is no pool creation. You
> > make a seed. You mount it. Add devices to it. Then remount it.  
> 
> Hmm, yes. I didn't think this through into detail yet. It actually
> works that way. I more commonly referenced to the general approach.
> 
> But I think this answers my question... ;-)
> 
> > > 2. recreate my original subvolume structure by snapshotting the
> > > backup scratch area multiple times into each subvolume
> > > 3. rearrange the files in each subvolume to match their intended
> > > use by using rm and mv
> > > 4. reboot into full system
> > > 4. remove all left-over snapshots from the seed
> > > 5. remove (detach) the seed device    
> > 
> > You have two 4's.  
> 
> Oh... Sorry... I think one week of 80 work hours, and another of 60
> was a bit too much... ;-)
> 
> > Anyway the 2nd 4 is not possible. The seed is ro by definition so
> > you can't remove snapshots from the seed. If you remove them from
> > the mounted rw sprout volume, they're removed from the sprout, not
> > the seed. If you want them on the sprout, but not on the seed, you
> > need to delete snapshots only after the seed is a.) removed from
> > the sprout and b.) made no longer a seed with btrfstune -S 0 and
> > c.) mounted rw.  
> 
> If I understand right, the seed device won't change? So whatever
> action I apply to the sprout pool, I can later remove the seed from
> the pool and it will still be kind of untouched. Except, I'll have to
> return it no non-seed mode (step b).
> 
> Why couldn't/shouldn't I remove snapshots before detaching the seed
> device? I want to keep them on the seed but they are useless to me on
> the sprout.
> 
> What happens to the UUIDs when I separate seed and sprout?
> 
> This is my layout:
> 
> /dev/sde1 contains my backup storage: btrfs with multiple weeks worth
> of retention in form of ro snapshots, and one scratch area in which
> the backup is performed. Snapshots are created from the scratch area.
> The scratch area is one single subvolume updated by rsync.
> 
> I want to turn this into a seed for my newly created btrfs pool. This
> one has subvolumes for /home, /home/my_user, /distribution_name/rootfs
> and a few more (like var/log etc).
> 
> Since the backup is not split by those subvolumes but contains just
> the single runtime view of my system rootfs, I'm planning to clone
> this single subvolume back into each of my previously used subvolumes
> which in turn of course now contain all the same complete filesystem
> tree. Thus, in the next step, I'm planning to mv/rm the contents to
> get back to the original subvolume structure - mv should be a fast
> operation here, rm probably not so but I don't bother. I could defer
> that until later by moving those rm-candidates into some trash folder
> per subvolume.
> 
> Now, I still have the ro-snapshots worth of multiple weeks of
> retention. I only need those in my backup storage, not in the storage
> proposed to become my bootable system. So I'd simply remove them. I
> could also defer that until later easily.
> 
> This should get my system back into working state pretty fast and
> easily if I didn't miss a point.
> 
> I'd now reboot into the system to see if it's working. By then, it's
> time for some cleanup (remove the previously deferred "trashes" and
> retention snapshots), then separate the seed from the sprout. During
> that time, I could already use my system again while it's migrating
> for me in the background.
> 
> I'd then return the seed back to non-seed, so it can take the role of
> my backup storage again. I'd do a rebalance now.
> 
> During the whole process, the backup storage will still stay safe for
> me. If something goes wrong, I could easily start over.
> 
> Did I miss something? Is it too much of an experimental kind of stuff?
> 
> BTW: The way it is arranged now, the backup storage is bootable by
> setting the scratch area subvolume as the rootfs on kernel cmdline,
> USB drivers are included in the kernel, it's tested and works. I
> guess, this isn't possible while the backup storage acts as a seed
> device? But I have an initrd with latest btrfs-progs on my boot
> device (which is an UEFI ESP, so not related to btrfs at all), I
> should be able to use that to revert changes preventing me from
> booting.

The whole idea of this is to think of it as sort of thin provisioning
my system from the backup storage, then let btrfs work for me. It saves
me copying back data for 40 hours without being able to use the system.


-- 
Regards,
Kai

Replies to list-only preferred.

