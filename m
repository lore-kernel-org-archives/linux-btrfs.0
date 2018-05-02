Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:52785 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbeEBRTU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 13:19:20 -0400
Received: by mail-it0-f54.google.com with SMTP id i136-v6so9487019ita.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 10:19:20 -0700 (PDT)
Subject: Re: RAID56 - 6 parity raid
To: waxhead@dirtcellar.net, kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c98e354-3687-1c26-f7b4-c6a4fa83b57c@gmail.com>
Date: Wed, 2 May 2018 13:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-02 12:55, waxhead wrote:
> Goffredo Baroncelli wrote:
>> Hi
>> On 05/02/2018 03:47 AM, Duncan wrote:
>>> Gandalf Corvotempesta posted on Tue, 01 May 2018 21:57:59 +0000 as
>>> excerpted:
>>>
>>>> Hi to all I've found some patches from Andrea Mazzoleni that adds
>>>> support up to 6 parity raid.
>>>> Why these are wasn't merged ?
>>>> With modern disk size, having something greater than 2 parity, would be
>>>> great.
>>> 1) [...] the parity isn't checksummed, ....
>>
>> Why the fact that the parity is not checksummed is a problem ?
>> I read several times that this is a problem. However each time the 
>> thread reached the conclusion that... it is not a problem.
>>
>> So again, which problem would solve having the parity checksummed ? On 
>> the best of my knowledge nothing. In any case the data is checksummed 
>> so it is impossible to return corrupted data (modulo bug :-) ).
>>
> I am not a BTRFS dev , but this should be quite easy to answer. Unless 
> you checksum the parity there is no way to verify that that the data 
> (parity) you use to reconstruct other data is correct.
While this is the biggest benefit (and it's a _huge_ one, because it 
means you don't have to waste time doing the parity reconstruction if 
you know the result won't be right), there's also a rather nice benefit 
for scrubbing the array, namely that you don't have to recompute parity 
to check if it's right or not (and thus can avoid wasting time 
recomputing it for every stripe in the common case of almost every 
stripe being correct).
> 
>> On the other side, having the parity would increase both the code 
>> complexity and the write amplification, because every time a part of 
>> the stripe is touched not only the parity has to be updated, but also 
>> the checksum has too..
> Which is a good thing. BTRFS main selling point is that you can feel 
> pretty confident that whatever you put is exactly what you get out.
