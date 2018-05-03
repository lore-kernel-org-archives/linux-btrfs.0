Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:55847 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751195AbeECTDa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 15:03:30 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: Alberto Bursi <alberto.bursi@outlook.it>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <VI1PR08MB0336F86EAF3DF8BF47E66E8692870@VI1PR08MB0336.eurprd08.prod.outlook.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <b8267347-a911-eb73-0471-769366ab6ee3@libero.it>
Date: Thu, 3 May 2018 21:03:27 +0200
MIME-Version: 1.0
In-Reply-To: <VI1PR08MB0336F86EAF3DF8BF47E66E8692870@VI1PR08MB0336.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2018 02:47 PM, Alberto Bursi wrote:
> 
> 
> On 01/05/2018 23:57, Gandalf Corvotempesta wrote:
>> Hi to all
>> I've found some patches from Andrea Mazzoleni that adds support up to 6
>> parity raid.
>> Why these are wasn't merged ?
>> With modern disk size, having something greater than 2 parity, would be
>> great.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> His patch was about a generic library to do RAID6, it wasn't directly 
> for btrfs.
> 
> To actually use that for btrfs someone would have to actually port btrfs 
> to that library.

In the past Andrea ported this library to btrfs too

https://lwn.net/Articles/588106/

> -Alberto

G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
