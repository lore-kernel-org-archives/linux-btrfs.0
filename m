Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753312AbbAEJ65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 04:58:57 -0500
Message-ID: <54AA5FB0.5020102@cn.fujitsu.com>
Date: Mon, 5 Jan 2015 17:56:00 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>, Robert White <rwhite@pobox.com>
CC: Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
References: <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com> <548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com> <549017E8.7060107@cn.fujitsu.com> <54908D8A.8040101@pobox.com> <54916B39.5080409@cn.fujitsu.com> <549252FF.10400@pobox.com> <20141231001514.GA13116@hungrycats.org>
In-Reply-To: <20141231001514.GA13116@hungrycats.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/31/2014 08:15 AM, Zygo Blaxell wrote:
> On Wed, Dec 17, 2014 at 08:07:27PM -0800, Robert White wrote:
>> [...]
> There are a number of pathological examples in here, but I think there
> are justifiable correct answers for each of them that emerge from a
> single interpretation of the meanings of f_bavail, f_blocks, and f_bfree.
>
> One gotcha is that some of the numbers required may be difficult to
> calculate precisely before all space is allocated to chunks; however,
> some error is tolerable as long as free space is not overestimated.
> In other words:  when in doubt, guess low.
>
> statvfs(2) gives us six numbers, three of which are block counts.
> Very few users or programs ever bother to look at the inode counts
> (f_files, f_ffree, f_favail), but they could be overloaded for metadata
> block counts.
>
> The f_blocks parameter is mostly irrelevant to application behavior,
> except to the extent that the ratio between f_bavail and f_blocks is
> used by applications to calculate a percentage of occupied or free space.
> f_blocks must always be greater than or equal to f_bavail and f_blocks,
> and preferably f_blocks would be scaled to use the same effective unit
> size as f_bavail and f_blocks within a percent or two.
>
> Nobody cares about f_bfree since traditionally only root could use the
> difference between f_bfree and f_bavail.  f_bfree is effectively space
> conditionally available (e.g. if the process euid is root or the process
> egid matches a configured group id), while f_bavail is space available
> without conditions (e.g. processes without privilege can use it).
>
> The most important number is f_bavail.  It's what a bunch of software
> (archive unpackers, assorted garbage collectors, email MTAs, snapshot
> remover scripts, download managers, etc) uses to estimate how much space
> is available without conditions (except quotas, although arguably those
> should be included too).  Applications that are privileged still use
> the unprivileged f_bavail number so their decisions based on free space
> don't disrupt unprivileged applications.
>
> It's generally better to underestimate than to overestimate f_bavail.
> Historically filesystems have reserved extra space to avoid various
> problems in low-disk conditions, and application software has adapted
> to that well over the years.  Also, admin people are more pleasantly
> surprised when it turns out that they had more space than f_bavail,
> instead of when they had less.
>
> The rule should be:  if we have some space, but it is not available for
> data extents in the current allocation mode, don't add it to f_bavail
> in statvfs.  I think this rule handles all of these examples well.
>
> That would mean that we get cases where we add a drive to a full
> filesystem and it doesn't immediately give you any new f_bavail space.
> That may be an unexpected result for a naive admin, but much less
> unexpected than having all the new space show up in f_bavail when it
> is not available for allocation in the current data profile!  Better
> to have the surprising behavior earlier than later.
>
> On to examples...
>
>> But a more even case is downright common and likely. Say you run a
>> nice old-fashoned MUTT mail-spool. "most" of your files are small
>> enough to live in metadata. You start with one drive. and allocate 2
>> single-data and 10 metatata (5xDup). Then you add a second drive of
>> equal size. (the metadata just switched to DUP-as-RAID1-alike mode)
>> And then you do a dconvert=raid0.
>>
>> That uneven allocation of metadata will be a 2GiB difference between
>> the two drives forever.
>> So do you shave 2GiB off of your @size?
> Yes.  f_blocks is the total size of all allocated chunks plus all free
> space allocated by the current data profile.

Agreed. This is what my patch designed by.
>    That 2GiB should disappear
> from such a calculation.
>
>> Do you shave @2GiB off your @available?
> Yes, because it's _not_ available until something changes to make it
> available (e.g. balance to get rid of the dup metadata, change the
> metadata profile to dup or single, or change the data profile to single).
>
> The 2GiB could be added to f_bfree, but that might still be confusing
> for people and software.
>
>> Do you overreport your available by @2GiB and end up _still_ having
>> things "available" when you get your ENOSPC?
> No.  ENOSPC when f_bavail > 0 is very bad.

Yes, it is very bad.
>   Low-available-space admin
> alerts will not be triggered.  Automated mitigation software will not be
> activated.  Service daemons will start transactions they cannot complete.
>
>> How about this ::
>>
>> /dev/sda == |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
>> /dev/sdb == |10 GiB free                                 |
>>
>> Operator fills his drive, then adds a second one, then _foolishly_
>> tries to convert it to RAID0 when the power fails. In order to check
>> the FS he boots with no_balance. Then his maintenance window closes
>> and he has to go back into production, at which point he forgets (or
>> isn't allowed) to do the balance. The flags are set but now no more
>> extents can be allocated.
>>
>> Size is 20GiB, slack is 10.5GiB. Operator is about to get ENOSPACE.

I am not clear about this use case. Is the current profile raid0? if so, 
@available is
10.5G. If raid1, @available is 0.5G.
> f_bavail should be 0.5GB or so.  Operator is now aware that ENOSPC is
> imminent, and can report to whoever grants permission to do things that
> the machine will be continuing to balance outside of the maintenance
> window.  This is much better than the alternative, which is that the
> lack of available space is detected by application failure outside of
> a maintenance window.
>
> Even better:  if f_bavail is reflective of reality, the operator can
> minimize out-of-window balance time by monitoring f_bavail and pausing
> the balance when there is enough space to operate without ENOSPC until
> the next maintenance window.
>
>> Yes a balance would fix it, but that's not the question.
> The question is "how much space is available at this time?" and the
> correct answer is "almost none," and it stays that way until and unless
> someone runs a balance, adds more drives, deletes a lot of data, etc.
>
> balance changes the way space will be allocated, so it also changes
> the output of df to match.
>
>> In the meantime what does your patch report?
> It should report that there's almost no available space.
> If the patch doesn't report that, the patch needs rework.
>
>> Or...
>>
>> /dev/sda == |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
>> /dev/sdb == |10 GiB free                                 |
>> /dev/sdc == |10 GiB free                                 |
>>
>> Does a -dconvert=raid5 and immediately gets ENOSPC for all the
>> blocks. According to the flags we've got 10GiB free...
> 10.5GiB is correct:  1.0GiB in a 3-way RAID5 on sd[abc] (2x 0.5GiB
> data, 1x 0.5GiB parity), and 9.5GiB in a 2-way RAID5 (1x 9.5GiB data,
> 1x 9.5GiB parity) on sd[bc].  The current RAID5 implementation might
> not use space that way, but if that's true, that's arguably a bug in
> the current RAID5 implementation.

The current RAID5 does not work like this. It will alloc 10G (0.5 sd[ab] 
+ 9.5 sd[bc]).

The calculation in statfs() is same with the calculation in current 
allocator.
It will report 10G available.

Yes it would be better if we make the allocator more clever in these case.
That can be another topic about allocator.
>
> If it was -dconvert=raid6, there would be only 0.5GiB in f_bavail (1x
> 0.5GiB data, 2x 0.5GiB parity) since raid6 requires 3 disks per chunk.
>
>> See you keep giving me these examples where the history of the
>> filesystem is uniform. It was made a certain way and stayed that
>> way. But in real life this sort of thing is going to happen and your
>> patch simply report's a _different_ _wrong_ number. A _friendlier_
>> wrong number, I'll grant you that, but still wrong.
> Who cares if the number is wrong, as long as useful decisions can still be
> made with it?  It doesn't have to be byte-accurate in all possible cases.
>
> Existing software and admin practice is OK with underreporting free
> space, but not overreporting it.  All the errors should be biased in
> that direction.

Thanx Zygo and Robert, I agree that my patch did not cover the situation 
when
block groups in different raid level. I will update my patch soon and 
sent it out.

Thanx for your suggestion.

Yang
>

