Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:52191 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbeEBSR5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 14:17:57 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: RAID56 - 6 parity raid
To: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <52465207-6c06-ef4b-b212-94b2199811a0@dirtcellar.net>
Date: Wed, 2 May 2018 20:17:55 +0200
MIME-Version: 1.0
In-Reply-To: <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> On 05/02/2018 06:55 PM, waxhead wrote:
>>>
>>> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
>>>
>> I am not a BTRFS dev , but this should be quite easy to answer. Unless you checksum the parity there is no way to verify that that the data (parity) you use to reconstruct other data is correct.
> 
> In any case you could catch that the compute data is wrong, because the data is always checksummed. And in any case you must check the data against their checksum.
> 
What if you lost an entire disk? or had corruption for both data AND 
checksum? How do you plan to safely reconstruct that without checksummed 
parity?

> My point is that storing the checksum is a cost that you pay *every time*. Every time you update a part of a stripe you need to update the parity, and then in turn the parity checksum. It is not a problem of space occupied nor a computational problem. It is a a problem of write amplification...
How much of a problem is this? no benchmarks have been run since the 
feature is not yet there I suppose.

> 
> The only gain is to avoid to try to use the parity when
> a) you need it (i.e. when the data is missing and/or corrupted)
I'm not sure I can make out your argument here , but with RAID5/6 you 
don't have another copy to restore from. You *have* to use the parity to 
reconstruct data and it is a good thing if this data is trusted.

> and b) it is corrupted.
> But the likelihood of this case is very low. And you can catch it during the data checksum check (which has to be performed in any case !).
> 
> So from one side you have a *cost every time* (the write amplification), to other side you have a gain (cpu-time) *only in case* of the parity is corrupted and you need it (eg. scrub or corrupted data)).
> 
> IMHO the cost are very higher than the gain, and the likelihood the gain is very lower compared to the likelihood (=100% or always) of the cost.
> 
Then run benchmarks and considering making parity checksums optional 
(but pretty please dipped in syrup with sugar on top - keep in on by 
default).

