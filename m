Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35291 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753977AbdEOMeL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 08:34:11 -0400
Received: by mail-io0-f171.google.com with SMTP id f102so71955925ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 05:34:10 -0700 (PDT)
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
To: Hugo Mills <hugo@carfax.org.uk>, Marc MERLIN <marc@merlins.org>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
 <20170514212111.GL9701@carfax.org.uk>
 <20170514231652.sdpaci7e4oxs5gc3@merlins.org>
 <20170515081455.GM9701@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <68d4bcac-f60c-215c-6be7-5e44f966d08d@gmail.com>
Date: Mon, 15 May 2017 08:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <20170515081455.GM9701@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-15 04:14, Hugo Mills wrote:
> On Sun, May 14, 2017 at 04:16:52PM -0700, Marc MERLIN wrote:
>> On Sun, May 14, 2017 at 09:21:11PM +0000, Hugo Mills wrote:
>>>> 2) balance -musage=0
>>>> 3) balance -musage=20
>>>
>>>    In most cases, this is going to make ENOSPC problems worse, not
>>> better. The reason for doign this kind of balance is to recover unused
>>> space and allow it to be reallocated. The typical behaviour is that
>>> data gets overallocated, and it's metadata which runs out. So, the
>>> last thing you want to be doing is reducing the metadata allocation,
>>> because that's the scarce resource.
>>>
>>>    Also, I'd usually recommend using limit=n, where n is approximately
>>> the amount of data overallcation (allocated space less used
>>> space). It's much more controllable than usage.
>>
>>
>> Thanks for that.
>> So, would you just remove the balance -musage=20 altogether?
>
>    Yes.
The advantages to doing that depend also on how much excess free space 
you have and what your usual usage is.  If you're balancing a filesystem 
for a mail server that has lots of free space, you may indeed want to 
re-balance metadata chunks regularly because you're likely to be 
rewriting significant amounts of metadata regularly.
>
>> As for limit= I'm not sure if it would be helpful since I run this
>> nightly. Anything that doesn't get done tonight due to limit, would be
>> done tomorrow?
>
>    I'm suggesting limit= on its own. It's a fixed amount of work
> compared to usage=, which may not do anything at all. For example,
> it's perfectly possible to have a filesystem which is, say, 30% full,
> and yet is still fully-allocated filesystem with more than 20% of
> every chunk used. In that case your usage= wouldn't balance anything,
> and you'd still be left in the situation of risking ENOSPC from
> running out of metadata.
FWIW, I normally use '-dusage=80 -mlimit=16' for my nightly balances. 
The usage filter at 80% means you won't waste time re-balancing full or 
mostly full chunks, and the limit filter of 16 takes on average about 5 
minutes on the consumer SSD's I have.
>
>    All you need to do is ensure that you have enough unallocated space
> for the metadata to expand into if it needs to. That's the ultimate
> goal of all this.
>
>    If you have SSDs, it may also be beneficial to use nossd as a mount
> option, because that seems to have some pathology in overallocating
> chunks in normal usage. Hans investigated this in detail a month or
> two ago.
