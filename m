Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33931 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcJNWay (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 18:30:54 -0400
Received: by mail-oi0-f68.google.com with SMTP id p136so8205407oic.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 15:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQCRiM2MPJt9cwQC37tTJiJoiZj5X5bwg-NDxpNaLvB7g@mail.gmail.com>
References: <20161011160601.GI7683@carfax.org.uk> <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com> <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com> <20161012171936.GD26140@hungrycats.org>
 <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com> <20161013210346.GY21290@hungrycats.org>
 <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com> <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
 <20161014195544.GZ21290@hungrycats.org> <CAJCQCtQCRiM2MPJt9cwQC37tTJiJoiZj5X5bwg-NDxpNaLvB7g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Oct 2016 16:30:42 -0600
Message-ID: <CAJCQCtSCmGQmKfNWrzO6Nzodf2Q8rZ0qiNsMoXbZpxxT==QKWA@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Chris Murphy <lists@colorremedies.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 14, 2016 at 3:38 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Oct 14, 2016 at 1:55 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
>
>>
>>> And how common is RMW for metadata operations?
>>
>> RMW in metadata is the norm.  It happens on nearly all commits--the only
>> exception seems to be when both ends of a commit write happen to land
>> on stripe boundaries accidentally, which is less than 1% of the time on
>> 3 disks.
>
> In the interest of due diligence, and the fact I can't confirm or deny
> this myself from reading the code (although I do see many comments
> involving RMW in the code), I must ask Qu if he can corroborate this.
>
> Because basically means btrfs raid56 is not better than md raid56 - by
> design. It has nothing to do with bugs. This is substantially worse
> than the scrub->wrong parity bug.
>
> Does it make sense to proscribe raid5 profile for metadata? As in,
> disallow -m raid5 at mkfs time? Maybe recommend raid1. Even raid6
> seems like it could be specious - yes there are two copies but if
> there is constant RMW, then there's no CoW and we're not really
> protected that well with all of these overwrites, statistically
> speaking.
>
> Basically you have to have a setup where there's no chance of torn or
> misdirected writes, and no corruptions, in which case Btrfs checksums
> aren't really helpful, you're using it for other reasons (snapshots
> and what not).
>
> Really seriously the CoW part of Btrfs being violated by all of this
> RMW to me sounds like it reduces the pros of Btrfs.


Also, is there RMW with raid0, or even raid10? Or is that always CoW
for metadata and data, just like single and dup? If raid0 is always
CoW, then I don't think it's correct to consider raid5 minus parity to
be anything like raid0 - in a Btrfs context anyway. Outside of that
context, I understand the argument.



-- 
Chris Murphy
