Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39884 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbaENNVK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 09:21:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WkZ7K-0001oX-K1
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 15:21:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 15:21:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 15:21:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: send/receive and bedup
Date: Wed, 14 May 2014 13:20:53 +0000 (UTC)
Message-ID: <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Scott Middleton posted on Mon, 12 May 2014 20:27:13 +0800 as excerpted:

> Hi Everyone
> 
> History:
> I just recently discovered BtrFS. Well really only just started reading
> a lot about it. Starting with blogs by Jim Salters and Marc Merlin. So,
> thanks for those blogs guys.
> 
> This also introduced me to ZoL (ZFS). It seemed a bit more stable but
> one of the features I really wanted was deduplication and needing 20GB
> RAM for 1TB of deduped data and the fact it is always on - pushed me
> away. Some of those guys really don't like BtrFS BTW!
> 
> What I want to be able to do is backup Virtual images (VirtualBox and
> some older VMware) over ADSL. I hoped a mixture of Dedupe and the
> send/receive functions of BtrFS might accomplish this.
> 
> I am in the process of building a test BtrFS system at home now but I
> hope to put it into production in the next few months.
> 
> 
> Current server is a Dual Xeon, Intel server board, 32GB RAM, 2 x 2TB
> Hardware RAID SAS (consisting of 4 x 2TB SATA drives) as / and /home in
> ext4 format. I also have 2 unused 4TB SATA drives that will be
> eventually be BtrFS RAID1 as /Backup. Ubuntu 14.04. Its is mainly a VM
> host, small file storage for word docs etc, some large archival .pst
> files and shadowprotect backups of the Terminal Server. I only just
> built this server over the last weekend to replace their other aging
> server and I purposely over engineered it.
> 
> Onsite there is also a backup server that is pretty basic with 2 x 4TB
> HDDs and 8GB RAM. I plan on converting it to BtrFS as well. Currently is
> Ubuntu 12.04 but I will be upgrading it soon to 14.04.
> 
> Offsite in a data centre I have an aging 1 RU server that I will be
> upgrading. It'll probably have 8GB RAM, 1 X 60GB SSD as boot/swap and 2
> X 4TB HDD BtrFS in RAID 1. Currently running 32 bit Debian 7.5. It has
> had many partial hardware and OS upgrades over the years as it
> originally started as Slink or even Hamm. Time to start again since I
> need to move to 64bit.
> 
> What I want to do is backup the / and /home directories on the main
> server to /Backup BtrFS directory, run bedup then "send" it to the
> onsite backup server. The onsite backup server will "send" it to the
> offsite server. I am assuming (correctly I hope) that the deduplication
> will also be replicated across the machines.  I'll have NOCOW on the VM
> images, Archived PST files, Shadow protect images and some other stuff.
> 
> I guess the first question is this even possible? I don't believe that
> much actual non duplicated data changes all that much mostly just word
> docs that I already send offsite. I'm really hoping to backup the VMs
> and the shadow protects offsite as well. I can  upgrade the broadband to
> fibre but before I do that (spend a lot of money) I want to be able to
> see that it would be possible.

I left this for a couple days hoping someone else with a more directly 
similar use-case would answer, but none so far, so I'll give it a go...

First some general boilerplate.  Btrfs is still under heavy development 
and keeping current with especially the kernel is *STRONGLY* recommended, 
as every new kernel still brings lots of fixes, meaning if you're running 
an old kernel, you're running known-buggy code with fixes available in a 
current kernel.  Similarly, you probably don't want to let the btrfs-progs 
userspace tools get too outdated either, tho that's not as critical as it 
mostly means not being able to take advantage of the latest features and 
fixes for maintenance, not the risk of operational data loss if one of 
the known-fixed old-version kernel bugs hits that you have when running 
an older kernel.

Second, as you've done some research already you're likely aware of this, 
but just in case, let me give you the link to the wiki.  If you haven't 
read up there, please do, as it's likely to be quite helpful. =:^)

Memory or bookmark: https://btrfs.wiki.kernel.org

User documentation bookmark:

https://btrfs.wiki.kernel.org/index.php/Main_Page#Guides_and_usage_information

On to your proposed setup.  In general, it looks reasonable.

My first concern upon reading about the VM images was of course the 
fragmentation issues that come with the VM images territory on btrfs, but 
if you keep your working partitions as ext4 and use btrfs primarily for 
backup, that issue goes away to a large extent, since the operational 
rewriting will be happening on the ext4, which should handle it a bit 
better than btrfs does at this point, while btrfs will only be getting 
the more sequentially written backups and not have to deal with the live 
in-place updates on the VM images.

The problem with btrfs hosting operational VM images is snapshots, 
particularly when using btrfs send for backup and/or when doing frequent, 
often scripted, snapshotting.  The problem with send is that it takes a 
read-only snapshot and sends from that, so it's a snapshotting issue 
either way.  The problem with snapshots is that for NOCOW files, the 
first write to a block after a snapshot still triggers a COW write, since 
the snapshot locked the existing version in place.

So frequent snapshotting has the effect of nullifying NOCOW for big VM 
images in operation due to the operational internal-write pattern, thus 
being a big problem that the devs are still working on finding a 
reasonably satisfactory solution for.

But by keeping your operational VM images on ext4 and only using btrfs 
for originally local backups, then using btrfs send to replicate those 
backups to onsite and then offsite remote, you should be avoiding the 
biggest problem, since the backup write-pattern should be far more 
sequential and not trigger the fragmentation issue you'd have trying to 
host the operational VMs directly on btrfs.

My next concern is with bedup and its interaction with btrfs send and 
snapshots.  I simply don't have enough knowledge in that area to be able 
to comment intelligently on how all the pieces fit together there, but 
you'll need to ensure a couple things, for sure.  Btrfs send starts with 
a full send, then uses that original base, kept the same on both sides, 
as a reference for the incremental sends you do later.  Both the original 
backup ext4->btrfs and the bedup processes will need to be setup so as 
not to interfere with the efficiency of those incremental sends, or if it 
works at all, you'll be effectively resending the entire thing each time, 
which isn't what you want at all.  Unfortunately I simply don't know 
enough about the interaction between the pieces to say whether your plan 
is reasonable there or not, and if so, how to actually do it.  This is 
why I was hoping someone else with more direct experience/knowledge would 
reply, but...

Next is bedup itself.  I'm not sure of the maturity status there, tho I 
don't believe it's fully production-quality yet.  However, it's quite 
possible that to the extent that it isn't production-ready, any breakage 
simply reduces the efficiency, while still helping some.  You'd really 
need to contact the guy working on it to find out.

Finally, btrfs send/receive itself just recently had a whole host of bugs 
fixed, so again, you'll want a very recent kernel and userspace in 
ordered to get those bugfixes.  In fact, I believe some of those fixes 
are only in kernel 3.15-rc, and only in the btrfs-progs integration 
branch, not yet in stable at all.  You can of course try 3.14.x stable 
kernel and 3.14.1 btrfs-progs and hope it works for now, updating if you 
have problems, or go for the pre-releases from the get-go.  Meanwhile, 
while that round of fixes certainly means btrfs send/receive is more 
mature than it was, I'd still strongly recommend having a fallback plan, 
in case you start getting errors and it quits working for you, pending 
further fixes.  IOW, yes, I'd say use send/receive if it works for you, 
but at this point, don't count on it actually continuing to work every 
time, and have a fallback if it breaks temporarily, so you're not as they 
say left up a creek without a paddle.

Hope that helps and good luck.  Looking forward to seeing more posts as 
you experiment, and hopefully you'll then stick around to add your 
experiences to the wiki and answer questions about that use-case here as 
others may have them. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

