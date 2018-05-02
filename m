Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:57535 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751011AbeEBRZn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 13:25:43 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: waxhead@dirtcellar.net, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
Date: Wed, 2 May 2018 19:25:36 +0200
MIME-Version: 1.0
In-Reply-To: <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/2018 06:55 PM, waxhead wrote:
>>
>> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
>>
> I am not a BTRFS dev , but this should be quite easy to answer. Unless you checksum the parity there is no way to verify that that the data (parity) you use to reconstruct other data is correct.

In any case you could catch that the compute data is wrong, because the data is always checksummed. And in any case you must check the data against their checksum.

My point is that storing the checksum is a cost that you pay *every time*. Every time you update a part of a stripe you need to update the parity, and then in turn the parity checksum. It is not a problem of space occupied nor a computational problem. It is a a problem of write amplification...

The only gain is to avoid to try to use the parity when 
a) you need it (i.e. when the data is missing and/or corrupted)
and b) it is corrupted. 
But the likelihood of this case is very low. And you can catch it during the data checksum check (which has to be performed in any case !).

So from one side you have a *cost every time* (the write amplification), to other side you have a gain (cpu-time) *only in case* of the parity is corrupted and you need it (eg. scrub or corrupted data)).

IMHO the cost are very higher than the gain, and the likelihood the gain is very lower compared to the likelihood (=100% or always) of the cost.


BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
