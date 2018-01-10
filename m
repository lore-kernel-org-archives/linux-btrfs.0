Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:37423 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751655AbeAJUpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 15:45:02 -0500
Received: by mail-io0-f179.google.com with SMTP id n14so864830iob.4
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 12:45:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3B79EE2F-030E-4B2D-9A1A-8E70D965E6CB@thefsb.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net> <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
 <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru> <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
 <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net> <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
 <3e353e79-3a13-d2cf-e098-6074a3e17918@gmail.com> <3B79EE2F-030E-4B2D-9A1A-8E70D965E6CB@thefsb.org>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 10 Jan 2018 23:44:21 +0300
Message-ID: <CAGqmi75afCNomxFALABtUhoSV7Op8onXa=9xeBTvY0ob=OpGXw@mail.gmail.com>
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Tom Worster <fsb@thefsb.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-10 21:33 GMT+03:00 Tom Worster <fsb@thefsb.org>:
> On 10 Jan 2018, at 12:01, Austin S. Hemmelgarn wrote:
>
>> On 2018-01-10 11:30, Tom Worster wrote:
>>
>> Also, for future reference, the term we typically use is ENOSPC, as that's
>> the symbolic name for the error code you get when this happens (or when your
>> filesystem is just normally full), but I actually kind of like your name for
>> it too, it conveys the exact condition being discussed in a way that should
>> be a bit easier for non-technical types to understand.
>
>
> Iiuc, ENOSPC is _exhaustion_ of unallocated space, which is a specific case
> of depletion.
>
> I sought a term to refer to the phenomenon of unallocated space shrinking
> beyond what filesystem use would demand and how it ratchets down. Hence a
> sysop needs to manage DoUS. ENOSPC is likely a failure of such management.
>
>
>>> - Some experienced users say that, to resolve a problem with DoUS, they
>>> would rather recreate the filesystem than run balance.
>>
>> This is kind of independent of BTRFS.
>
>
> Yes. I mentioned it only because it was, to me, a striking statement of lack
> of confidence in balance.
>
>
>>> But if Duncan is right (which, for me, is practically the same as
>>> consensus on the proposition) that problems with corruption while running
>>> balance are associated with heavy coincident IO activity, then I can see a
>>> reasonable way forwards. I can even see how general recommendations for
>>> BTRFS maintenance might develop.
>>
>> As I commented above, I would tend to believe Duncan is right in this case
>> (both because it makes sense, and because he seems to generally be right
>> about this type of thing).  That said, I really do think that normal user
>> I/O is probably not the issue, but low-level filesystem operations are.
>> That said, there is no reason that BTRFS shouldn't either:
>> 1. Handle this just fine without causing corruption.
>> or:
>> 2. Extend the mutex used to prevent concurrent balances to cover other
>> operations that might cause issues (that is, make it so you can't scrub a
>> filesystem while it's being balanced, or defragment it, or whatever else).
>
>
> Yes, but backtracking a bit, I think there's another really important point
> here. Assuming Duncan's right, it's not so hard to develop guidelines for
> general BTRFS management that include DoUS among other topics. Duncan's
> other email today contains or implies quite a lot of those guidelines.
>
> Or, to put it another way, it's enough for me. I think I know what to do
> now. And that much could be written down for the benefit of others.
>
> Tom
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

My two cents,
I've about ~50 different systems
(VCS Systems, MySQL DB, Web Servers, Elastic Search nodes & etc.).
All running btrfs only and run fine, even with auto snapshot rotating
on some of them,
(btrfs make my life easier and i like it).

Most of them are small VMs From 3GiB..512GiB (I use compression everywhere).
And no one of them need balance, only that i care,
i try have always some unallocated space on it.

Most of them are stuck with some used/allocated/unallocated ratio.

I.e. as i see from conversation point of view.
We run balance for reallocate data -> make more unallocated space,
but if someone have plenty of it, that useless, no?

ex. I've 60% allocated by data/meta data chunks on my notebook,
And only 40% are really used by data, even then i have 90% allocated,
and 85% used, i don't face into ENOSPC problems. (256GiB ssd).

And if i run balance, i run it only to fight with btrfs discard processing bug,
which leads to trim only unallocated space (probably fixed already).

So if we talk about "regular" running of balance, may be that make a sense
To check free space, i.e. if system have some percentage of space
allocated, like 80%,
and have plenty of allocated/unused space, only then balance will be needed, no?

(I'm not say that btrfs have no problems, i see some rare hateful bugs,
on some systems, but most of them are internal btrfs problems
or problems with coop of btrfs with applications).

Thanks.
-- 
Have a nice day,
Timofey.
