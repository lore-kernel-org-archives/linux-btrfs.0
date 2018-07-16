Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:41002 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbeGPWVF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 18:21:05 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
From: waxhead <waxhead@dirtcellar.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
Message-ID: <04dd1b9a-e193-0be1-54fe-b6297e378e42@dirtcellar.net>
Date: Mon, 16 Jul 2018 23:51:42 +0200
MIME-Version: 1.0
In-Reply-To: <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead wrote:
> David Sterba wrote:
>> An interesting question is the naming of the extended profiles. I picked
>> something that can be easily understood but it's not a final proposal.
>> Years ago, Hugo proposed a naming scheme that described the
>> non-standard raid varieties of the btrfs flavor:
>>
>> https://marc.info/?l=linux-btrfs&m=136286324417767
>>
>> Switching to this naming would be a good addition to the extended raid.
>>
> As just a humble BTRFS user I agree and really think it is about time to 
> move far away from the RAID terminology. However adding some more 
> descriptive profile names (or at least some aliases) would be much 
> better for the commoners (such as myself). 
>...snip... > Which would make the above table look like so:
> 
> Old format / My Format / My suggested alias
> SINGLE  / R0.S0.P0 / SINGLE
> DUP     / R1.S1.P0 / DUP (or even MIRRORLOCAL1)
> RAID0   / R0.Sm.P0 / STRIPE
> RAID1   / R1.S0.P0 / MIRROR1
> RAID1c3 / R2.S0.P0 / MIRROR2
> RAID1c4 / R3.S0.P0 / MIRROR3
> RAID10  / R1.Sm.P0 / STRIPE.MIRROR1
> RAID5   / R1.Sm.P1 / STRIPE.PARITY1
> RAID6   / R1.Sm.P2 / STRIPE.PARITY2
> 
> And i think this is much more readable, but others may disagree. And as 
> a side note... from a (hobby) coders perspective this is probably 
> simpler to parse as well. 
>...snap...

...and before someone else points this out that my suggestion has an 
ugly flaw , I got a bit copy / paste happy and messed up the RAID 5 and 
6 like profiles. The below table are corrected and hopefully it make the 
point why using the word 'replicas' is easier to understand than 
'copies' even if I messed it up :)

Old format / My Format / My suggested alias
SINGLE  / R0.S0.P0 / SINGLE
DUP     / R1.S1.P0 / DUP (or even MIRRORLOCAL1)
RAID0   / R0.Sm.P0 / STRIPE
RAID1   / R1.S0.P0 / MIRROR1
RAID1c3 / R2.S0.P0 / MIRROR2
RAID1c4 / R3.S0.P0 / MIRROR3
RAID10  / R1.Sm.P0 / STRIPE.MIRROR1
RAID5   / R0.Sm.P1 / STRIPE.PARITY1
RAID6   / R0.Sm.P2 / STRIPE.PARITY2
