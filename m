Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751414AbcISULZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 16:11:25 -0400
Subject: Re: stability matrix
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        <linux-btrfs@vger.kernel.org>, <dave@jikos.cz>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net> <20160919152753.GG933@twin.jikos.cz>
 <bc71caf0-4656-382b-479d-e135ee7f4bc7@gmail.com>
 <1474314776.10189.24.camel@scientia.net>
From: Chris Mason <clm@fb.com>
Message-ID: <7d60b7ae-7a5f-a386-9472-9237cacfb046@fb.com>
Date: Mon, 19 Sep 2016 16:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <1474314776.10189.24.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/19/2016 03:52 PM, Christoph Anton Mitterer wrote:
> On Mon, 2016-09-19 at 13:18 -0400, Austin S. Hemmelgarn wrote:
>>>> - even mounting a fs ro, may cause it to be changed
>>>
>>> This would go to the UseCases
>> My same argument about the UUID issues applies here, just without
>> the
>> security aspect.
>
> I personally could agree to have that "just" in the usecases.
>
> That a fs my be changed even though it's mounted ro is not unique to
> btrfs.... and the need for not having that happen goes probably rather
> into data-forensics and rescue use cases.
>
> IMO there's rather a general problem, namely that the different
> filesystems don't provide a mount option that implies every other mount
> options currently needed to get an actual "hard ro", i.e. one where the
> device is never written to.
>
> Qu was about to add such option when nologreplay was added, but IIRC he
> got some resistance by linux-fs, who probably didn't care enough
> whether the end-user can easily do such "hard ro" mount ;)
>
>

That's in the blockdev command (blockdev --setro /dev/xxx).

We actually try to maintain the established norms where it doesn't 
conflict with the btrfs use cases.  This is one of them ;)

-chris

