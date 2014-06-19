Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60334 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaFSADM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 20:03:12 -0400
Received: by mail-oa0-f44.google.com with SMTP id i7so3622130oag.31
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 17:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A2268F.3080807@fb.com>
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>
	<53A20FFF.3010807@hp.com>
	<53A2125B.3050701@fb.com>
	<53A21702.8090109@hp.com>
	<53A21C78.1040809@fb.com>
	<53A21E84.2050103@hp.com>
	<53A22064.7080400@fb.com>
	<53A2212E.7090907@hp.com>
	<53A2268F.3080807@fb.com>
Date: Wed, 18 Jun 2014 20:03:11 -0400
Message-ID: <CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Waiman Long <waiman.long@hp.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, t-itoh@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 7:53 PM, Chris Mason <clm@fb.com> wrote:
> On 06/18/2014 07:30 PM, Waiman Long wrote:
>> On 06/18/2014 07:27 PM, Chris Mason wrote:
>>> On 06/18/2014 07:19 PM, Waiman Long wrote:
>>>> On 06/18/2014 07:10 PM, Josef Bacik wrote:
>>>>>
>>>>> On 06/18/2014 03:47 PM, Waiman Long wrote:
>>>>>> On 06/18/2014 06:27 PM, Josef Bacik wrote:
>>>>>>>
>>>>>>> On 06/18/2014 03:17 PM, Waiman Long wrote:
>>>>>>>> On 06/18/2014 04:57 PM, Marc Dionne wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I've been seeing very reproducible soft lockups with 3.16-rc1
>>>>>>>>> similar
>>>>>>>>> to what is reported here:
>>>>>>>>> https://urldefense.proofpoint.com/v1/url?u=http://marc.info/?l%3Dlinux-btrfs%26m%3D140290088532203%26w%3D2&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=aoagvtZMwVb16gh1HApZZL00I7eP50GurBpuEo3l%2B5g%3D%0A&s=c62558feb60a480bbb52802093de8c97b5e1f23d4100265b6120c8065bd99565
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> , along with the
>>>>>>>>> occasional hard lockup, making it impossible to complete a parallel
>>>>>>>>> build on a btrfs filesystem for the package I work on.  This was
>>>>>>>>> working fine just a few days before rc1.
>>>>>>>>>
>>>>>>>>> Bisecting brought me to the following commit:
>>>>>>>>>
>>>>>>>>>     commit bd01ec1a13f9a327950c8e3080096446c7804753
>>>>>>>>>     Author: Waiman Long<Waiman.Long@hp.com>
>>>>>>>>>     Date:   Mon Feb 3 13:18:57 2014 +0100
>>>>>>>>>
>>>>>>>>>         x86, locking/rwlocks: Enable qrwlocks on x86
>>>>>>>>>
>>>>>>>>> And sure enough if I revert that commit on top of current mainline,
>>>>>>>>> I'm unable to reproduce the soft lockups and hangs.
>>>>>>>>>
>>>>>>>>> Marc
>>>>>>>> The queue rwlock is fair. As a result, recursive read_lock is not
>>>>>>>> allowed unless the task is in an interrupt context. Doing recursive
>>>>>>>> read_lock will hang the process when a write_lock happens
>>>>>>>> somewhere in
>>>>>>>> between. Are recursive read_lock being done in the btrfs code?
>>>>>>>>
>>>>>>> We walk down a tree and read lock each node as we walk down, is that
>>>>>>> what you mean?  Or do you mean read_lock multiple times on the same
>>>>>>> lock in the same process, cause we definitely don't do that.  Thanks,
>>>>>>>
>>>>>>> Josef
>>>>>> I meant recursively read_lock the same lock in a process.
>>>>> I take it back, we do actually do this in some cases.  Thanks,
>>>>>
>>>>> Josef
>>>> This is what I thought when I looked at the looking code in btrfs. The
>>>> unlock code doesn't clear the lock_owner pid, this may cause the
>>>> lock_nested to be set incorrectly.
>>>>
>>>> Anyway, are you going to do something about it?
>>> Thanks for reporting this, we shouldn't be actually taking the lock
>>> recursively.  Could you please try with lockdep enabled?  If the problem
>>> goes away with lockdep on, I think I know what's causing it.  Otherwise,
>>> lockdep should clue us in.
>>>
>>> -chris
>>
>> I am not sure if lockdep will report recursive read_lock as this is
>> possible in the past. If not, we certainly need to add that capability
>> to it.
>>
>> One more thing, I saw comment in btrfs tree locking code about taking a
>> read lock after taking a write (partial?) lock. That is not possible
>> with even with the old rwlock code.
>
> With lockdep on, the clear_path_blocking function you're hitting
> softlockups in is different.  Futjitsu hit a similar problem during
> quota rescans, and it goes away with lockdep on.  I'm trying to nail
> down where we went wrong, but please try lockdep on.
>
> -chris

With lockdep on I'm unable to reproduce the lockups, and there are no
lockdep warnings.

Marc
