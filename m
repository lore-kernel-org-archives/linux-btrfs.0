Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35331 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbcEYMjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 08:39:12 -0400
Received: by mail-it0-f67.google.com with SMTP id z123so4746541itg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 05:39:11 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
 <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
 <20160524095155.GN29147@twin.jikos.cz>
 <913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
 <20160525111138.GP29147@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5d14ab66-9894-82da-91ca-5cbfd0a7d760@gmail.com>
Date: Wed, 25 May 2016 08:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <20160525111138.GP29147@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 07:11, David Sterba wrote:
> On Wed, May 25, 2016 at 08:33:45AM +0800, Qu Wenruo wrote:
>>
>>
>> David Sterba wrote on 2016/05/24 11:51 +0200:
>>> On Tue, May 24, 2016 at 08:31:01AM +0800, Qu Wenruo wrote:
>>>>> This could be made static (with thread local storage) so the state does
>>>>> not get regenerated all the time. Possibly it could be initialize from
>>>>> some true random source, not time or pid.
>>>>
>>>> I also considered true random source like /dev/random, but since it's
>>>> possible to wait for entropy pool, it would be quite slow and confusing
>>>> for users.
>>>
>>> How would it be confusing? We'll once seed the random generator from
>>> /dev/random, reading 3 * 16bit for the nrand generator context.
>>
>> Reading from /dev/random may sleep, until the entropy pool is filled.
>
> I know, but does this apply in our case? We're going to get just a few
> bytes to seed.  I want to avoid inventing own random number generation
> schemes, so we'll use a standard random number source or API.
>
> /dev/random gives about 1-2MB/s of random data on several machines I've
> tried.
You have a lot of systems with a lot of spare entropy then, or you 
unintentionally added a 'u' at the beginning of 'random' and were only 
testing on slow systems.  Some people (myself included) do seed 
/dev/random from hardware RNG's or other daemons (I run both HAVEGE and 
rngd), but many people don't, and a majority of embedded systems I've 
seen absolutely don't.  48-bits may not seem like much, but if we're 
using /dev/random, it has the potential to block indefinitely, and 
having that possibility in end-user software is not a good thing.

I would tend to agree with Hugo on this one, we should be using 
/dev/urandom, not /dev/random.

