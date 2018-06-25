Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:34881 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933863AbeFYQnl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 12:43:41 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: unsolvable technical issues?
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <20180625133611.GC27958@twin.jikos.cz>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <5d76bd89-a209-2197-5eec-9cd88774f1a2@dirtcellar.net>
Date: Mon, 25 Jun 2018 18:43:38 +0200
MIME-Version: 1.0
In-Reply-To: <20180625133611.GC27958@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote:
> On Fri, Jun 22, 2018 at 01:13:31AM +0200, waxhead wrote:
>> According to this:
>>
>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf
>> Page 4 , section 1.2
>>
>> It claims that BTRFS still have significant technical issues that may
>> never be resolved.
>> Could someone shed some light on exactly what these technical issues
>> might be?! What are BTRFS biggest technical problems?
> 
> The subject you write is 'unsolvable', which I read as 'impossible to
> solve', eg. on the design level. I'm not aware of such issues.
> 
Alright , so I interpret this as there is no showstopper regarding 
implementation of existing and planned features...

> If this is about issues that are difficult either to implement or
> getting right, there are a few known ones.
> 
Alright again, and I interpret this as there might be some code that is 
not flexible enough and changing that might affect working / stable 
parts of the code so therefore other solutions are looked at which is 
not that uncommon for software. Apart from not listing the known issues 
I think I got my questions answered :) and now it is perhaps finally 
appropriate to file a request at the Stratis bugtracker to ask what 
specifically they are referring to.

>> If you forget about the "RAID"5/6 like features then the only annoyances
>> that I have with BTRFS so far is...
>>
>> 1. Lack of per subvolume "RAID" levels
>> 2. Lack of not using the deviceid to re-discover and re-add dropped devices
>>
>> And that's about it really...
> 
> This could quickly turn into 'my faviourite bug/feature' list that can
> be very long. The most asked for are raid56, and performance of qgroups.
> 
> Qu Wenruo improved some of the core problems and Jeff is working on the
> performance problem. So there are people working on that.
> 
> On the raid56 front, there were some recent updates that fixed some
> bugs, but the fix for write hole is still missing so we can't raise the
> status yet.  I have some some good news but nobody should get too
> excited until the code lands.
> 
> I have prototype for the N-copy raid (where N is 3 or 4).  This will
> provide the underlying infrastructure for the raid5/6 logging mechanism,
> the rest can be taken from Liu Bo's patchset sent some time ago.  In the
> end the N-copy can be used for data and metadata too, independently and
> flexibly switched via the balance filters. This will cost one
> incompatibility bit.

I hope I am not asking for too much (but I know I probably am), but I 
suggest that having a small snippet of information on the status page 
showing a little bit about what is either currently the development 
focus , or what people are known for working at would be very valuable 
for users and it may of course work both ways, such as exciting people 
or calming them down. ;)

For example something simple like a "development focus" list...
2018-Q4: (planned) Renaming the grotesque "RAID" terminology
2018-Q3: (planned) Magical feature X
2018-Q2: N-Way mirroring
2018-Q1: Feature work "RAID"5/6

I think it would be good for people living their lives outside as it 
would perhaps spark some attention from developers and perhaps even 
media as well.
