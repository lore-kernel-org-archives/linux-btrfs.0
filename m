Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:43302 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbeCVVNV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 17:13:21 -0400
From: waxhead <waxhead@dirtcellar.net>
Subject: Re: Status of RAID5/6
Reply-To: waxhead@dirtcellar.net
To: Liu Bo <obuil.liubo@gmail.com>, Menion <menion@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
Message-ID: <d9ee9d63-15af-e9a0-06d9-51f39cc69de0@dirtcellar.net>
Date: Thu, 22 Mar 2018 22:13:18 +0100
MIME-Version: 1.0
In-Reply-To: <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo wrote:
> On Wed, Mar 21, 2018 at 9:50 AM, Menion <menion@gmail.com> wrote:
>> Hi all
>> I am trying to understand the status of RAID5/6 in BTRFS
>> I know that there are some discussion ongoing on the RFC patch
>> proposed by Liu bo
>> But it seems that everything stopped last summary. Also it mentioned
>> about a "separate disk for journal", does it mean that the final
>> implementation of RAID5/6 will require a dedicated HDD for the
>> journaling?
> 
> Thanks for the interest on btrfs and raid56.
> 
> The patch set is to plug write hole, which is very rare in practice, tbh.
> The feedback is to use existing space instead of another dedicate
> "fast device" as the journal in order to get some extent of raid
> protection.  I'd need some time to pick it up.
> 
> With that being said, we have several data reconstruction fixes for
> raid56 (esp. raid6) in 4.15, I'd say please deploy btrfs with the
> upstream kernel or some distros which do kernel updates frequently,
> the most important one is
> 
> 8810f7517a3b Btrfs: make raid6 rebuild retry more
> https://patchwork.kernel.org/patch/10091755/
> 
> AFAIK, no other data corruptions showed up.
> 
I am very interested in the "raid"5/6 like behavior myself. Actually 
calling it RAID in the past may have had it's benefits , but these days 
continuing to use the RAID term is not helping. Even technically minded 
people seem to get confused.

For example: It was suggested that "raid"5/6 should have hot-spare 
support. In BTRFS terms a hot spare devicse sounds wrong to me, but 
reserving extra space for a "hot-space" so any "raid"5/6 like system can 
(auto?) rebalance to missing blocks to the rest of the pool sounds 
sensible enough (as long as the number of devices allows to separate the 
different bits and pieces).

Anyway , I got carried away a bit there. Sorry about that.
What I really wanted to comment is about usability of "raid"5/6
How would really a metadata "raid"1 + data "raid"5 or 6 compare to say 
mdraid 5 or 6 from a reliability point of view.

Sure mdraid has the advantage, but even with the write hole and the risk 
of corruption of data (not the filesystem) would not BTRFS in "theory" 
be safer that at least mdraid 5 if run with metadata "raid"5 ?!
You have to run scrub on both mdraid as well as BTRFS to ensure data is 
not corrupted.

PS! It might be worth mentioning that I am slightly affected by a 
Glenfarclas 105 Whisky while writing this so please bare with me in case 
something is too far off :)
