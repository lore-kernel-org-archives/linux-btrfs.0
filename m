Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35739 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbdC1Ouo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 10:50:44 -0400
Received: by mail-wm0-f67.google.com with SMTP id z133so133587wmb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 07:50:38 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Shrinking a device - performance?
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <22746.30348.324000.636753@tree.ty.sabi.co.uk>
Date: Tue, 28 Mar 2017 15:50:29 +0100
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <2F3BCD5B-2E3D-47BB-869B-19018380B1C5@gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu>
 <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk>
To: Peter Grandi <pg@btrfs.for.sabi.co.UK>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I glazed over at “This is going to be long” … :)

> On 28 Mar 2017, at 15:43, Peter Grandi <pg@btrfs.for.sabi.co.UK> wrote:
> 
> This is going to be long because I am writing something detailed
> hoping pointlessly that someone in the future will find it by
> searching the list archives while doing research before setting
> up a new storage system, and they will be the kind of person
> that tolerates reading messages longer than Twitter. :-).
> 
>> I’m currently shrinking a device and it seems that the
>> performance of shrink is abysmal.
> 
> When I read this kind of statement I am reminded of all the
> cases where someone left me to decatastrophize a storage system
> built on "optimistic" assumptions. The usual "optimism" is what
> I call the "syntactic approach", that is the axiomatic belief
> that any syntactically valid combination of features not only
> will "work", but very fast too and reliably despite slow cheap
> hardware and "unattentive" configuration. Some people call that
> the expectation that system developers provide or should provide
> an "O_PONIES" option. In particular I get very saddened when
> people use "performance" to mean "speed", as the difference
> between the two is very great.
> 
> As a general consideration, shrinking a large filetree online
> in-place is an amazingly risky, difficult, slow operation and
> should be a last desperate resort (as apparently in this case),
> regardless of the filesystem type, and expecting otherwise is
> "optimistic".
> 
> My guess is that very complex risky slow operations like that
> are provided by "clever" filesystem developers for "marketing"
> purposes, to win box-ticking competitions. That applies to those
> system developers who do know better; I suspect that even some
> filesystem developers are "optimistic" as to what they can
> actually achieve.
> 
>> I intended to shrink a ~22TiB filesystem down to 20TiB. This is
>> still using LVM underneath so that I can’t just remove a device
>> from the filesystem but have to use the resize command.
> 
> That is actually a very good idea because Btrfs multi-device is
> not quite as reliable as DM/LVM2 multi-device.
> 
>> Label: 'backy'  uuid: 3d0b7511-4901-4554-96d4-e6f9627ea9a4
>>       Total devices 1 FS bytes used 18.21TiB
>>       devid    1 size 20.00TiB used 20.71TiB path /dev/mapper/vgsys-backy
> 
> Maybe 'balance' should have been used a bit more.
> 
>> This has been running since last Thursday, so roughly 3.5days
>> now. The “used” number in devid1 has moved about 1TiB in this
>> time. The filesystem is seeing regular usage (read and write)
>> and when I’m suspending any application traffic I see about
>> 1GiB of movement every now and then. Maybe once every 30
>> seconds or so. Does this sound fishy or normal to you?
> 
> With consistent "optimism" this is a request to assess whether
> "performance" of some operations is adequate on a filetree
> without telling us either what the filetree contents look like,
> what the regular workload is, or what the storage layer looks
> like.
> 
> Being one of the few system administrators crippled by lack of
> psychic powers :-), I rely on guesses and inferences here, and
> having read the whole thread containing some belated details.
> 
> From the ~22TB total capacity my guess is that the storage layer
> involves rotating hard disks, and from later details the
> filesystem contents seems to be heavily reflinked files of
> several GB in size, and workload seems to be backups to those
> files from several source hosts. Considering the general level
> of "optimism" in the situation my wild guess is that the storage
> layer is based on large slow cheap rotating disks in teh 4GB-8GB
> range, with very low IOPS-per-TB.
> 
>> Thanks for that info. The 1min per 1GiB is what I saw too -
>> the “it can take longer” wasn’t really explainable to me.
> 
> A contemporary rotating disk device can do around 0.5MB/s
> transfer rate with small random accesses with barriers up to
> around 80-160MB/s in purely sequential access without barriers.
> 
> 1GB/m of simultaneous read-write means around 16MB/s reads plus
> 16MB/s writes which is fairly good *performance* (even if slow
> *speed*) considering that moving extents around, even across
> disks, involves quite a bit of randomish same-disk updates of
> metadata; because it all depends usually on how much randomish
> metadata updates need to done, on any filesystem type, as those
> must be done with barriers.
> 
>> As I’m not using snapshots: would large files (100+gb)
> 
> Using 100GB sized VM virtual disks (never mind with COW) seems
> very unwise to me to start with, but of course a lot of other
> people know better :-). Just like a lot of other people know
> better that large single pool storage systems are awesome in
> every respect :-): cost, reliability, speed, flexibility,
> maintenance, etc.
> 
>> with long chains of CoW history (specifically reflink copies)
>> also hurt?
> 
> Oh yes... They are about one of the worst cases for using
> Btrfs. But also very "optimistic" to think that kind of stuff
> can work awesomely on *any* filesystem type.
> 
>> Something I’d like to verify: does having traffic on the
>> volume have the potential to delay this infinitely? [ ... ]
>> it’s just slow and we’re looking forward to about 2 months
>> worth of time shrinking this volume. (And then again on the
>> next bigger server probably about 3-4 months).
> 
> Those are pretty typical times for whole-filesystem operations
> like that on rotating disk media. There are some reports in the
> list and IRC channel archives to 'scrub' or 'balance' or 'check'
> times for filetrees of that size.
> 
>> (Background info: we’re migrating large volumes from btrfs to
>> xfs and can only do this step by step: copying some data,
>> shrinking the btrfs volume, extending the xfs volume, rinse
>> repeat.
> 
> That "extending the xfs volume" will have consequences too, but
> not too bad hopefully.
> 
>> If someone should have any suggestions to speed this up and
>> not having to think in terms of _months_ then I’m all ears.)
> 
> High IOPS-per-TB enterprise SSDs with capacitor backed caches :-).
> 
>> One strategy that does come to mind: we’re converting our
>> backup from a system that uses reflinks to a non-reflink based
>> system. We can convert this in place so this would remove all
>> the reflink stuff in the existing filesystem
> 
> Do you have enough space to do that? Either your reflinks are
> pointless or they are saving a lot of storage. But I guess that
> you can do it one 100GB file at a time...
> 
>> and then we maybe can do the FS conversion faster when this
>> isn’t an issue any longer. I think I’ll
> 
> I suspect the de-reflinking plus shrinking will take longer, but
> not totally sure.
> 
>> Right. This is wan option we can do from a software perspective
>> (our own solution - https://bitbucket.org/flyingcircus/backy)
> 
> Many thanks for sharing your system, I'll have a look.
> 
>> but our systems in use can’t hold all the data twice. Even
>> though we’re migrating to a backend implementation that uses
>> less data than before I have to perform an “inplace” migration
>> in some way. This is VM block device backup. So basically we
>> migrate one VM with all its previous data and that works quite
>> fine with a little headroom. However, migrating all VMs to a
>> new “full” backup and then wait for the old to shrink would
>> only work if we had a completely empty backup server in place,
>> which we don’t.
> 
>> Also: the idea of migrating on btrfs also has its downside -
>> the performance of “mkdir” and “fsync” is abysmal at the
>> moment.
> 
> That *performance* is pretty good indeed, it is the *speed* that
> may be low, but that's obvious. Please consider looking at these
> entirely typical speeds:
> 
>  http://www.sabi.co.uk/blog/17-one.html?170302#170302
>  http://www.sabi.co.uk/blog/17-one.html?170228#170228
> 
>> I’m waiting for the current shrinking job to finish but this
>> is likely limited to the “find free space” algorithm. We’re
>> talking about a few megabytes converted per second. Sigh.
> 
> Well, if the filetree is being actively used for COW backups
> while being shrunk that involves a lot of randomish IO with
> barriers.
> 
>>> I would only suggest that you reconsider XFS. You can't
>>> shrink XFS, therefore you won't have the flexibility to
>>> migrate in the same way to anything better that comes along
>>> in the future (ZFS perhaps? or even Bcachefs?). XFS does not
>>> perform that much better over Ext4, and very importantly,
>>> Ext4 can be shrunk.
> 
> ZFS is a complicated mess too with an intensely anisotropic
> performance envelope too and not necessarily that good for
> backup archival for various reasons. I would consider looking
> instead at using a collection of smaller "silo" JFS, F2FS,
> NILFS2 filetrees as well as XFS, and using MD RAID in RAID10
> mode instead of DM/LVM2:
> 
>  http://www.sabi.co.uk/blog/16-two.html?161217#161217
>  http://www.sabi.co.uk/blog/17-one.html?170107#170107
>  http://www.sabi.co.uk/blog/12-fou.html?121223#121223
>  http://www.sabi.co.uk/blog/12-fou.html?121218b#121218b
>  http://www.sabi.co.uk/blog/12-fou.html?121218#121218
> 
> and yes, Bcachefs looks promising, but I am sticking with Btrfs:
> 
>  https://lwn.net/Articles/717379
> 
>> That is true. However, we do have moved the expected feature
>> set of the filesystem (i.e. cow)
> 
> That feature set is arguably not appropriate for VM images, but
> lots of people know better :-).
> 
>> down to “store files safely and reliably” and we’ve seen too
>> much breakage with ext4 in the past.
> 
> That is extremely unlikely unless your storage layer has
> unreliable barriers, and then you need a lot of "optimism".
> 
>> Of course “persistence means you’ll have to say I’m sorry” and
>> thus with either choice we may be faced with some issue in the
>> future that we might have circumvented with another solution
>> and yes flexibility is worth a great deal.
> 
> Enterprise SSDs with high small-random-write IOPS-per-TB can
> give both excellent speed and high flexibility :-).
> 
>> We’ve run XFS and ext4 on different (large and small)
>> workloads in the last 2 years and I have to say I’m much more
>> happy about XFS even with the shrinking limitation.
> 
> XFS and 'ext4' are essentially equivalent, except for the
> fixed-size inode table limitation of 'ext4' (and XFS reportedly
> has finer grained locking). Btrfs is nearly as good as either on
> most workloads is single-device mode without using the more
> complicated features (compression, qgroups, ...) and with
> appropriate use of the 'nowcow' options, and gives checksums on
> data too if needed.
> 
>> To us ext4 is prohibitive with it’s fsck performance and we do
>> like the tight error checking in XFS.
> 
> It is very pleasing to see someone care about the speed of
> whole-tree operations like 'fsck', a very often forgotten
> "little detail". But in my experience 'ext4' checking is quite
> competitive with XFS checking and repair, at least in recent
> years, as both have been hugely improved. XFS checking and
> repair still require a lot of RAM though.
> 
>> Thanks for the reminder though - especially in the public
>> archive making this tradeoff with flexibility known is wise to
>> communicate. :-)
> 
> "Flexibility" in filesystems, especially on rotating disk
> storage with extremely anisotropic performance envelopes, is
> very expensive, but of course lots of people know better :-).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

