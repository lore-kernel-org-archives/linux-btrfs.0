Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:60395 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751689AbeEBQ1w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 12:27:52 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
Date: Wed, 2 May 2018 18:27:49 +0200
MIME-Version: 1.0
In-Reply-To: <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
On 05/02/2018 03:47 AM, Duncan wrote:
> Gandalf Corvotempesta posted on Tue, 01 May 2018 21:57:59 +0000 as
> excerpted:
> 
>> Hi to all I've found some patches from Andrea Mazzoleni that adds
>> support up to 6 parity raid.
>> Why these are wasn't merged ?
>> With modern disk size, having something greater than 2 parity, would be
>> great.
> 1) [...] the parity isn't checksummed, ....

Why the fact that the parity is not checksummed is a problem ?
I read several times that this is a problem. However each time the thread reached the conclusion that... it is not a problem.

So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).

On the other side, having the parity would increase both the code complexity and the write amplification, because every time a part of the stripe is touched not only the parity has to be updated, but also the checksum has too..


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
