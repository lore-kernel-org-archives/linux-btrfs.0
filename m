Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33965 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbcC2U0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 16:26:34 -0400
Received: by mail-ig0-f177.google.com with SMTP id sy18so13388210igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 13:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FADEAE.3080801@gmail.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
	<56FA9420.8020503@oracle.com>
	<20160329192428.GA27148@jeknote.loshitsa1.net>
	<56FADEAE.3080801@gmail.com>
Date: Tue, 29 Mar 2016 14:26:32 -0600
Message-ID: <CAJCQCtQH07uHy0h0xfkRzKPOmiyozDTR9NfivhAjU+Akam9_hw@mail.gmail.com>
Subject: Re: Global hotspare functionality
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 1:59 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-03-29 15:24, Yauhen Kharuzhy wrote:
>>
>> On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
>>>
>>>
>>>   No. No. No please don't do that, it would lead to trouble in handing
>>>   slow devices. I purposely didn't do it.
>>
>>
>> Hmm. Can you explain please? Sometimes admins may want to have
>> autoreplacement working automatically if drive was failed and removed
>> before unmounting and remounting again. The simplest way to achieve this —
>> add spare and always mount FS with 'degraded' option (we need to use
>> this option in any case if we have root fs on RAID, for instance, to
>> avoiding non-bootable state). So, if the autoreplacement code will check
>> for
>> missing drives also, this will working without user intervention. To
>> allow user to decide if he wants autoreplacement, we can add mount
>> option like '(no)hotspare' (I have done this already for our project and
>> will send patch after rebasing onto your new series). Yes, there are
>> side effects exists if you want to make some experiments with missing
>> drives in FS, but you can disable autoreplacement for such case.
>>
>> If you know about any pitfalls in such scenarios, please point me to
>> them, I am newbie in FS-related kernel things.
>
> If a disk is particularly slow to start up for some reason (maybe it's going
> bad, maybe it's just got a slow interconnect (think SD cards), maybe it's
> just really cold so the bearings seizing up), then this would potentially
> force it out of the array when it shouldn't be.
>
> That said, having things set to always allow degraded mounts is _extremely
> dangerous_.  If the user does not know anything failed, they also can't know
> they need to get anything fixed.  While notification could be used, it also
> introduces a period of time where the user is at risk of data loss without
> them having explicitly agreed to this risk (by manually telling it to mount
> degraded).

I agree, certainly replace should not be automatic by default. And I'm
unconvinced this belongs in kernel code anyway because it's a matter
of policy. Policy stuff goes in user space, where capability to
achieve the policy goes in the kernel.

A reasonable exception is bad device ejection (e.g. mdadm faulty).

Considering spinning devices take a long time to rebuild already and
this probably won't change, a policy I'd like to see upon a drive
going bad (totally vanishing, or producing many read or write errors):
1. Bad device is ejected, volume is degraded.
2. Consider chunks with one remaining stripe (one copy) as degraded.
3. Degraded chunks are read only, so COW changes to non-degraded chunks.
4. Degraded metadata chunks are replicated elsewhere, happens right away.
5. Implied by 4, degraded data chunks aren't immediately replicated
but any change are, via COW.
6. Option, by policy, to immediately start replicating degraded data
chunks - either with existing storage or hot spare, which is also a
policy choice.

In particular, I'd like to see the single stripe metadata chunks
replicated soon so in case there's another device failure the entire
volume doesn't implode. Yes there's some data loss, still better than
100% data loss.


> I could possibly understand doing this for something that needs to be
> guaranteed to come on line when powered on,  but **only** if it notifies
> responsible parties that there was a problem **and** it is explicitly
> documented, and even then I'd be wary of doing this unless there was
> something in place to handle the possibility of false positives (yes, they
> do happen), and to make certain that the failed hardware got replaced as
> soon as possible.

Exactly. And I think it's safer to be more aggressive with (fairly)
immediate metadata replication to remaining devices, than it is with
data.

I'm considering this behavior for both single volume setups, as well
as multiple bricks in a cluster. And admittedly it's probably
cheaper/easier to just get n-way copies of metadata than the above
scheme I've written.

-- 
Chris Murphy
