Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:36906 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeEBVUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 17:20:36 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: RAID56 - 6 parity raid
To: Andrei Borzenkov <arvidjaar@gmail.com>, kreijack@inwind.it,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <52465207-6c06-ef4b-b212-94b2199811a0@dirtcellar.net>
 <06986e21-28cc-a58e-b16c-129d9f5a845d@gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <666fce23-1edc-ea98-b11c-2068f95aa3e9@dirtcellar.net>
Date: Wed, 2 May 2018 23:20:33 +0200
MIME-Version: 1.0
In-Reply-To: <06986e21-28cc-a58e-b16c-129d9f5a845d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Andrei Borzenkov wrote:
> 02.05.2018 21:17, waxhead пишет:
>> Goffredo Baroncelli wrote:
>>> On 05/02/2018 06:55 PM, waxhead wrote:
>>>>>
>>>>> So again, which problem would solve having the parity checksummed ?
>>>>> On the best of my knowledge nothing. In any case the data is
>>>>> checksummed so it is impossible to return corrupted data (modulo bug
>>>>> :-) ).
>>>>>
>>>> I am not a BTRFS dev , but this should be quite easy to answer.
>>>> Unless you checksum the parity there is no way to verify that that
>>>> the data (parity) you use to reconstruct other data is correct.
>>>
>>> In any case you could catch that the compute data is wrong, because
>>> the data is always checksummed. And in any case you must check the
>>> data against their checksum.
>>>
>> What if you lost an entire disk?
> 
> How does it matter exactly? RAID is per chunk anyway.
> 
It does not matter. I was wrong, got bitten by thinking about BTRFS 
"RAID5" as normal RAID5. Again a good reason to change the naming for it 
I think...

>> or had corruption for both data AND checksum?
> 
> By the same logic you may have corrupted parity and its checksum.
> 
Yup. Indeed

>> How do you plan to safely reconstruct that without checksummed
>> parity?
>>
> 
> Define "safely". The main problem of current RAID56 implementation is
> that stripe is not updated atomically (at least, that is what I
> understood from the past discussions) and this is not solved by having
> extra parity checksum. So how exactly "safety" is improved here? You
> still need overall checksum to verify result of reconstruction, what
> exactly extra parity checksum buys you?
> 
 > [...]
>>
> 
> Again - please describe when having parity checksum will be beneficial
> over current implementation. You do not reconstruct anything as long as
> all data strips are there, so parity checksum will not be used. If one
> data strip fails (including checksum) it will be reconstructed and
> verified. If parity itself is corrupted, checksum verification fails
> (hopefully). How is it different from verifying parity checksum before
> reconstructing? In both cases data cannot be reconstructed, end of story.

Ok, before attempting and answer I have to admit that I do not know 
enough about how RAID56 is laid out on disk in BTRFS terms. Is data 
checksummed pr. stripe or pr. disk? Is parity calculated on the data 
only or is it calculated on the data+checksum ?!
