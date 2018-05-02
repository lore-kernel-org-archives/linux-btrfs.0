Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:41410 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbeEBQ4C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 12:56:02 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: RAID56 - 6 parity raid
To: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
Date: Wed, 2 May 2018 18:55:58 +0200
MIME-Version: 1.0
In-Reply-To: <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Hi
> On 05/02/2018 03:47 AM, Duncan wrote:
>> Gandalf Corvotempesta posted on Tue, 01 May 2018 21:57:59 +0000 as
>> excerpted:
>>
>>> Hi to all I've found some patches from Andrea Mazzoleni that adds
>>> support up to 6 parity raid.
>>> Why these are wasn't merged ?
>>> With modern disk size, having something greater than 2 parity, would be
>>> great.
>> 1) [...] the parity isn't checksummed, ....
> 
> Why the fact that the parity is not checksummed is a problem ?
> I read several times that this is a problem. However each time the thread reached the conclusion that... it is not a problem.
> 
> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
> 
I am not a BTRFS dev , but this should be quite easy to answer. Unless 
you checksum the parity there is no way to verify that that the data 
(parity) you use to reconstruct other data is correct.

> On the other side, having the parity would increase both the code complexity and the write amplification, because every time a part of the stripe is touched not only the parity has to be updated, but also the checksum has too..
Which is a good thing. BTRFS main selling point is that you can feel 
pretty confident that whatever you put is exactly what you get out.
