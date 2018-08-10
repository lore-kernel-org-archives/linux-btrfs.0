Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41414 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbeHJUic (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 16:38:32 -0400
Received: by mail-lf1-f51.google.com with SMTP id v22-v6so7164095lfe.8
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 11:07:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com> <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 10 Aug 2018 12:07:34 -0600
Message-ID: <CAJCQCtQS+yiSQ4Cu-F_Spi5_6fEw_FuGdXCafJLxBe1swacabQ@mail.gmail.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with quota
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Tomasz Pala <gotar@polanet.pl>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 9, 2018 at 5:35 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 8/10/18 1:48 AM, Tomasz Pala wrote:
>> On Tue, Jul 31, 2018 at 22:32:07 +0800, Qu Wenruo wrote:
>>
>>> 2) Different limitations on exclusive/shared bytes
>>>    Btrfs can set different limit on exclusive/shared bytes, further
>>>    complicating the problem.
>>>
>>> 3) Btrfs quota only accounts data/metadata used by the subvolume
>>>    It lacks all the shared trees (mentioned below), and in fact such
>>>    shared tree can be pretty large (especially for extent tree and csum
>>>    tree).
>>
>> I'm not sure about the implications, but just to clarify some things:
>>
>> when limiting somebody's data space we usually don't care about the
>> underlying "savings" coming from any deduplicating technique - these are
>> purely bonuses for system owner, so he could do larger resource overbooking.
>
> In reality that's definitely not the case.
>
> From what I see, most users would care more about exclusively used space
> (excl), other than the total space one subvolume is referring to (rfer).

I'm confused.

So what happens in the following case with quotas enabled on Btrfs:

1. Provision a user with a directory, pre-populated with files, using
snapshot. Let's say it's 1GiB of files.
2. Set a quota for this user's directory, 1GiB.

The way I'm reading the description of Btrfs quotas, the 1GiB quota
applies to exclusive used space. So for starters, they have 1GiB of
shared data that does not affect their 1GiB quota at all.

3. User creates 500MiB worth of new files, this is exclusive usage.
They are still within their quota limit.
4. The shared data becomes obsolete for all but this one user, and is deleted.

Suddenly, 1GiB of shared data for this user is no longer shared data,
it instantly becomes exclusive data and their quota is busted. Now
consider scaling this to 12TiB of storage, with hundreds of users, and
dozens of abruptly busted quotas following this same scenario on a
weekly basis.

I *might* buy off on the idea that an overlay2 based initial
provisioning would not affect quotas. But whether data is shared or
exclusive seems potentially ephemeral, and not something a sysadmin
should even be able to anticipate let alone individual users.

Going back to the example, I'd expect to give the user a 2GiB quota,
with 1GiB of initially provisioned data via snapshot, so right off the
bat they are at 50% usage of their quota. If they were to modify every
single provisioned file, they'd in effect go from 100% shared data to
100% exclusive data, but their quota usage would still be 50%. That's
completely sane and easily understandable by a regular user. The idea
that they'd start modifying shared files, and their quota usage climbs
is weird to me. The state of files being shared or exclusive is not
user domain terminology anyway.


>
> The most common case is, you do a snapshot, user would only care how
> much new space can be written into the subvolume, other than the total
> subvolume size.

I think that's expecting a lot of users.

I also wonder if it expects a lot from services like samba and NFS who
have to communicate all of this in some sane way to remote clients? My
expectation is that a remote client shows Free Space on a quota'd
system to be based on the unused amount of the quota. I also expect if
I delete a 1GiB file, that my quota consumption goes down. But you're
saying it would be unchanged if I delete a 1GiB shared file, and would
only go down if I delete a 1GiB exclusive file. Do samba and NFS know
about shared and exclusive files? If samba and NFS don't understand
this, then how is a user supposed to understand it?

And now I'm sufficiently confused I'm ready for the weekend!


>> And the numbers accounted should reflect the uncompressed sizes.
>
> No way for current extent based solution.

I'm less concerned about this. But since the extent item shows both
ram and disk byte values, why couldn't the quota and the space
reporting be predicated on the ram value which is always uncompressed?



>
>>
>>
>> Moreover - if there would be per-subvolume RAID levels someday, the data
>> should be accouted in relation to "default" (filesystem) RAID level,
>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>> data, and twice the data in an opposite scenario (like "dup" profile on
>> single-drive filesystem).
>
> No possible again for current extent based solution.

It's fine, I think it's unintuitive for DUP or raid1 profiles to cause
quota consumption to double. The underlying configuration of the array
is not the business of the user. They can only be expected to
understand file size. Underlying space consumed, whether compressed,
or duplicated, or compressed and duplicated, is out of scope for the
user. And we can't have quotas getting busted all of a sudden because
the sysadmin decides to do -dconvert -mconvert raid1, without
requiring the sysadmin to double everyone's quota before performing
the operation.





>
>>
>>
>> In short: values representing quotas are user-oriented ("the numbers one
>> bought"), not storage-oriented ("the numbers they actually occupy").
>
> Well, if something is not possible or brings so big performance impact,
> there will be no argument on how it should work in the first place.

Yep!

What is VFS disk quotas and does Btrfs use that at all? If not, why
not? It seems to me there really should be a high level basic per
directory quota implementation at the VFS layer, with a single kernel
interface as well as a single user space interface, regardless of the
file system. Additional file system specific quota features can of
course have their own tools, but all of this re-invention of the wheel
for basic directory quotas is a mystery to me.


-- 
Chris Murphy
