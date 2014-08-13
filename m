Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38987 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaHMLGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 07:06:23 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so10936297wgh.13
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 04:06:22 -0700 (PDT)
Message-ID: <53EB466A.40605@gmail.com>
Date: Wed, 13 Aug 2014 14:05:14 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: David Pottage <david@chrestomanci.org>, Vimal A R <arvimal@yahoo.in>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E9F3D6.9040502@gmail.com> <53EB4581.8050104@chrestomanci.org>
In-Reply-To: <53EB4581.8050104@chrestomanci.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/8/2014 2:01 μμ, David Pottage wrote:
>
> On 12/08/14 12:00, Konstantinos Skarlatos wrote:
>> Maybe help with Andrea Mazzoleni's New RAID library supporting up to 
>> six parities? It seems to be a great feature for btrfs.
>>
>> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31735.html
>
> That would be very cool, but at present vanila RAID 5 or 6 does not 
> work properly, so I think getting that fully working would be a better 
> idea. (Unless it would make more sense to merge the whole lot into one 
> bit of work where RAID 5 or 6 are just a special case of arbitrary 
> parity level support).
>
> At present, you can write RAID 5 or 6 data, but if anything goes 
> wrong, btrfs cannot use the parity information to help you get your 
> data back, so in general you are better off with RAID 1 or 10. Also, I 
> don't think I/O done in parallel so you get no speed advantage from 
> having multiple discs either.
>
Yeah, thats one of the features I am waiting to get finished, because I 
already have 5 multi disk systems that i would prefer to migrate to 
RAID5/6 from RAID1/JBOD that they are now.

I dont know what is the best sequencing, I just think that these are 
great patches/features and its a pity for them to languish.


-- 
Konstantinos Skarlatos

