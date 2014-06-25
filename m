Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:64923 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbaFYW00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 18:26:26 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2819574wes.7
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 15:26:25 -0700 (PDT)
Message-ID: <53AB4C89.1060203@gmail.com>
Date: Thu, 26 Jun 2014 01:26:17 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs data dup on single device?
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>	 <20140625074713.GE31096@carfax.org.uk> <1403707306.4857.13.camel@heisenberg.scientia.net>
In-Reply-To: <1403707306.4857.13.camel@heisenberg.scientia.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/6/2014 5:41 μμ, Christoph Anton Mitterer wrote:
> On Wed, 2014-06-25 at 08:47 +0100, Hugo Mills wrote:
>>     This has variously been possible and not over the last few years. I
>> think it's finally come down on the side of "not",
> I think that would really be a loss... :(
>
>
>>     The question is, why?
> Well imagine you have some computer which can only have one disk drive
> (laptop, etc.) and you still want at least some kind of redundancy
> against bit rot errors.
>
>
> IMO, btrfs should support most flavours out there...
> - n-way duplicates on the same device (and not just DUP with n=2)
For the same device there is also erasure coding, where you lose lets 
say 10% capacity, and have the benefit of recovering from the most 
probable disk errors that dont take the whole disk with them, bad sectors.

> - n-way mirrors on multiple devices (i.e. what we have right now with
> RAID1 plus up to classic RAID1 with copies on each device
> - RAID5/6
> - n-way striped+parity with n>2
> - "stacked" layouts (RAID 10 as e.g. MD has it,... RAID50, 60)
>
>
> And terminology should really be re-worked... IMHO it's very bad to use
> the term RAID1, if it's not what classic RAID1 does.
>
>
> Cheers,
> Chris.
>


-- 
Konstantinos Skarlatos

