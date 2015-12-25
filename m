Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54794 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbbLYRLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 12:11:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCVtW-0001YH-So
	for linux-btrfs@vger.kernel.org; Fri, 25 Dec 2015 18:11:10 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 18:11:10 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 18:11:10 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Fri, 25 Dec 2015 18:11:04 +0100
Message-ID: <567D78A8.9080105@gmx.de>
References: <n5du09$9rn$1@ger.gmane.org> <567C07A6.7080503@siedziba.pl> <n5h30b$8vd$1@ger.gmane.org> <567C206B.70705@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <567C206B.70705@siedziba.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for all the answers from all you guys. They are really very much
appreciated!

Taken together, it seems I am left with the following options:

1) Btrfs/RAID1 with lvmcache: Not well proven, at least partly buggy.
Caches can be easily added and removed to existing partitions.

2) BTRFS/RADI1 with bcache: sees to be more stable. HDDs can however,
not be used easily without bcache. Complete data conversion is needed.

3) ZFS with ZFS cache device: Well proven and stable, but VERY memory
hungry and not in main kernel.

Well, I guess, I should take some time thinking about it...

To everybody, enjoy christmas!


Am 24.12.2015 um 17:42 schrieb Piotr Pawłow:
>> Indeed? Exactly like this? Great to hear. But sad to hear it is not a
>> good solution.
> 
> Exactly. Single SSD caching 2 LVs used for btrfs RAID1. Don't get me
> wrong, it's still a lot better than without caching, but not optimal. An
> optimal solution would have to be integrated with the FS like in ZFS.
> 
>>> The effective capacity for caching is halved, and it takes twice as much
>>> time to fully cache your working set, because you get a cache miss at
>>> least once for each mirror.
>>>
>>> There are also some gotchas:
>>>
>>> - you should use "device=" mount options, or else there is a danger of
>>> btrfs mounting origin devices and even mixing cached and origin in one
>>> FS. I completely broke my FS before realizing what's going on.
>> Hmm, strange. I thought btrfs should not even know of the lvmcache. It
>> would just try to mount the HDD LVs and the caching is done
>> automatically via lvmcache?
> 
> Unfortunately, at least on my system, there are device files for origin
> LVs:
> 
> # lvs
>   LV    VG   Attr       LSize   Pool     Origin Data%  Meta%  Move Log
> Cpy%Sync Convert
>   home1 pp   Cwi-aoC---   1,42t [cache0] [home1_corig] 100,00
> 11,02           0,00
>   home2 pp   Cwi-aoC---   1,42t [cache1] [home2_corig] 100,00
> 11,02           0,00
> [...]
> 
> # ls -1 /dev/mapper/
> [...]
> pp-home1
> pp-home1_corig
> pp-home2
> pp-home2_corig
> [...]
> 
> ... which btrfs would detect, pick up at random and assemble into the
> RAID set. I had to do this in fstab to force only specified devices:
> 
> UUID=[...] /home btrfs
> noatime,autodefrag,subvol=@home,device=/dev/mapper/pp-home1,device=/dev/mapper/pp-home2
> 
> 
>>> - you should use writethrough mode if you only have one SSD. There was a
>>> bug in LVM where it wouldn't save the caching mode and revert to
>>> writeback after restart, so make sure you use the latest version of LVM
>>> tools.
>> Do you know, which version is good?
> 
> I know it was buggy in Ubuntu Vivid (version 2.02.111 I think), and in
> Wily it's OK (curently 2.02.122).
> 
> Looking at the changelog, it may have been fixed in 2.02.112 by commit
> 9d57aa9a0fe00322cb188ad1f3103d57392546e7:
> 
> "cache-pool:  Fix specification of cachemode when converting to cache-pool
> 
> Failure to copy the 'feature_flags' lvconvert_param to the matching
> lv_segment field meant that when a user specified the cachemode argument,
> the request was not honored."
> 
> Of cource I may be wrong, I haven't bisected it.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


