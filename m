Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:45047 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbeHJJq0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 05:46:26 -0400
Date: Fri, 10 Aug 2018 09:17:49 +0200
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes
 with quota
Message-ID: <20180810071748.GA5473@polanet.pl>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 07:35:32 +0800, Qu Wenruo wrote:

>> when limiting somebody's data space we usually don't care about the
>> underlying "savings" coming from any deduplicating technique - these are
>> purely bonuses for system owner, so he could do larger resource overbooking.
> 
> In reality that's definitely not the case.

Definitely? How do you "sell" a disk space when there is no upper bound?
Every, and I mean _every_ resource quota out in the wild gives you an user-perspective.
You can assign CPU cores/time, RAM or network bandwidth with HARD limit.

Only after that you _can_ sometimes assign some best-effort
outer, not guaranteed limits, like extra network bandwidth or grace
periods with filesystem usage (disregarding technical details - in case
of quota you move hard limit beyond and apply lowere soft limit).

This is the primary quota usage. Quotas don't save system resources,
quotas are valuables to "sell" (by quotes I mean every possible
allocations, including interorganisation accouting).

Quotas are overbookable by design and like I said before, the underlying
savings mechanism allow sysadm to increase actual overbooking ratio.

If I run out of CPU, RAM, storage or network I simply need to expand
such resource. I won't shrink quotas in such case.
Or apply some other resuorce-saving technique, like LVM with VDO,
swapping, RAM deduplication etc.

If that is not the usecase of btrfs quotas, then it should be renamed to
not confuse users. Using the incorrect terms for things widely known
leads to user frustration at least.

> From what I see, most users would care more about exclusively used space
> (excl), other than the total space one subvolume is referring to (rfer).

Consider this:
1. there is some "template" system-wide snapshot,
2. users X and Y have CoW copies of it - both see "0 bytes exclusive"?
3. sysadm removes "template" - what happens to X and Y quotas?
4. user X removes his copy - what happens to Y quota?

The first thing about virtually every mechanism should be
discoverability and reliability. I expect my quota not to change without
my interaction. Never. How did you cope with this?
If not - how are you going to explain such weird behaviour to users?

Once again: numbers of quotas *I* got must not be influenced by external
operations or foreign users.

> The most common case is, you do a snapshot, user would only care how
> much new space can be written into the subvolume, other than the total
> subvolume size.

If only that would be the case... then exactly - I do care how much new
data is _guaranteed_ to fit on my storage.

So please tell me, as I might get it wrong - what happens if source
subvolume get's removed and the CoWed data are not shared anymore?
Is the quota recalculated? - this would be wrong, as there were no new data written.
Is the quota left intact? - this is wrong too, as this gives the false view of exclusive space taken.

This is just another reincarnation of famous "btrfs df" problem you
couldn't comprehend so long - when reporting "disk FREE" status I want
to know the amount of data that is guaranteed to be written in current
RAID profile, i.e. ignoring any possible savings from compression etc.


Please note: my assumptions are based on
https://btrfs.wiki.kernel.org/index.php/Quota_support

"File copy and file deletion may both affect limits since the unshared
limit of another qgroup can change if the original volume's files are
deleted and only one copy is remaining"

so if I write something invalid this might be the source of my mistake.


>> And the numbers accounted should reflect the uncompressed sizes.
> 
> No way for current extent based solution.

OK, since the data is provided by the user, it's "compressableness"
might be considered his saving (we only provide transparency).

>> Moreover - if there would be per-subvolume RAID levels someday, the data
>> should be accouted in relation to "default" (filesystem) RAID level,
>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>> data, and twice the data in an opposite scenario (like "dup" profile on
>> single-drive filesystem).
> 
> No possible again for current extent based solution.

Doesn't extent have information about devices it's cloned on? But OK,
this is not important until per-subvolume profiles are available.

>> In short: values representing quotas are user-oriented ("the numbers one
>> bought"), not storage-oriented ("the numbers they actually occupy").
> 
> Well, if something is not possible or brings so big performance impact,
> there will be no argument on how it should work in the first place.

Actually I think you did something overcomplicated (shared/exclusive),
which would only lead to user confusion (especially when his data
becomes "exclusive" one day without any known reason), misnamed ...and
not reflecting anything valuable, unless the problems with extent
fragmentation are already resolved somehow?

So IMHO current quotas are:
- not discoverable for user (shared->exclusive transition of my data by someone's else action),
- not reliable for sysadm (offensive write pattern by any user can allocate virtually any space despite of quotas).

-- 
Tomasz Pala <gotar@pld-linux.org>
