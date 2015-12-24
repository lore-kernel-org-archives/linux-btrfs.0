Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:42335 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbLXQor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 11:44:47 -0500
Subject: Re: btrfs und lvm-cache?
To: Neuer User <auslands-kv@gmx.de>, linux-btrfs@vger.kernel.org
References: <n5du09$9rn$1@ger.gmane.org> <567C07A6.7080503@siedziba.pl>
 <n5h30b$8vd$1@ger.gmane.org>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <567C206B.70705@siedziba.pl>
Date: Thu, 24 Dec 2015 17:42:19 +0100
MIME-Version: 1.0
In-Reply-To: <n5h30b$8vd$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 24.12.2015 o 16:29, Neuer User pisze:
> Am 24.12.2015 um 15:56 schrieb Piotr Pawłow:
>> Hello,
>>> - both hdd and ssd in one LVM VG
>>> - one LV on each hdd, containing a btrfs filesystem
>>> - both btrfs LV configured as RAID1
>>> - the single SDD used as a LVM cache device for both HDD LVs to speed up
>>> random access, where possible
>> I have a setup like this for my /home. It works but it's a crappy solution.
>>
> Indeed? Exactly like this? Great to hear. But sad to hear it is not a
> good solution.

Exactly. Single SSD caching 2 LVs used for btrfs RAID1. Don't get me 
wrong, it's still a lot better than without caching, but not optimal. An 
optimal solution would have to be integrated with the FS like in ZFS.

>> The effective capacity for caching is halved, and it takes twice as much
>> time to fully cache your working set, because you get a cache miss at
>> least once for each mirror.
>>
>> There are also some gotchas:
>>
>> - you should use "device=" mount options, or else there is a danger of
>> btrfs mounting origin devices and even mixing cached and origin in one
>> FS. I completely broke my FS before realizing what's going on.
> Hmm, strange. I thought btrfs should not even know of the lvmcache. It
> would just try to mount the HDD LVs and the caching is done
> automatically via lvmcache?

Unfortunately, at least on my system, there are device files for origin LVs:

# lvs
   LV    VG   Attr       LSize   Pool     Origin Data%  Meta%  Move Log 
Cpy%Sync Convert
   home1 pp   Cwi-aoC---   1,42t [cache0] [home1_corig] 100,00 
11,02           0,00
   home2 pp   Cwi-aoC---   1,42t [cache1] [home2_corig] 100,00 
11,02           0,00
[...]

# ls -1 /dev/mapper/
[...]
pp-home1
pp-home1_corig
pp-home2
pp-home2_corig
[...]

... which btrfs would detect, pick up at random and assemble into the 
RAID set. I had to do this in fstab to force only specified devices:

UUID=[...] /home btrfs 
noatime,autodefrag,subvol=@home,device=/dev/mapper/pp-home1,device=/dev/mapper/pp-home2

>> - you should use writethrough mode if you only have one SSD. There was a
>> bug in LVM where it wouldn't save the caching mode and revert to
>> writeback after restart, so make sure you use the latest version of LVM
>> tools.
> Do you know, which version is good?

I know it was buggy in Ubuntu Vivid (version 2.02.111 I think), and in 
Wily it's OK (curently 2.02.122).

Looking at the changelog, it may have been fixed in 2.02.112 by commit 
9d57aa9a0fe00322cb188ad1f3103d57392546e7:

"cache-pool:  Fix specification of cachemode when converting to cache-pool

Failure to copy the 'feature_flags' lvconvert_param to the matching
lv_segment field meant that when a user specified the cachemode argument,
the request was not honored."

Of cource I may be wrong, I haven't bisected it.
