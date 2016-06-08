Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s1.hotmail.com ([65.55.116.12]:61324 "EHLO
	BLU004-OMC1S1.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562AbcFHNc1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 09:32:27 -0400
Message-ID: <BLU437-SMTP62B170C13822AC38033D43925E0@phx.gbl>
Subject: Re: check if hardware checksumming works or not
To: Nicholas D Steeves <nsteeves@gmail.com>
References: <BLU436-SMTP235FBB8882371723DF217EA925B0@phx.gbl>
 <CAD=QJKg0GVGn06+zurHEy5jx3woNrKcP_XdtDBH2RjStmapKSw@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alberto Bursi <alberto.bursi@outlook.it>
Date: Wed, 8 Jun 2016 15:32:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAD=QJKg0GVGn06+zurHEy5jx3woNrKcP_XdtDBH2RjStmapKSw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was hoping for a more advanced method than just blacklisting drivers. :)

Anyways, it seems that first june there was a patch


    [PATCH] btrfs: advertise which crc32c implementation is being used
    at module load

that is getting merged lately, so In the near future I will be able to 
see on btrfs load what driver is in use.


On 05/06/2016 22:33, Nicholas D Steeves wrote:
> Hi Alberto,
>
> On 5 June 2016 at 15:37, Alberto Bursi <alberto.bursi@outlook.it> wrote:
>> Hi, I'm running Debian ARM on a Marvell Kirkwood-based 2-disk NAS.
>>
>> Kirkwood SoCs have a XOR engine that can hardware-accelerate crc32c
>> checksumming, and from what I see in kernel mailing lists it seems to have a
>> linux driver and should be supported.
>>
>> I wanted to ask if there is a way to test if it is working at all.
>>
>> How do I force btrfs to use software checksumming for testing purposes?
> Is there a mv_xor.ko module you can blacklist?  I'm not familiar with
> the platform, but I imagine you'll have to blacklist it and reboot,
> because I'm guessing the module can't be removed once it's loaded.
>
> 'just a guess,
> Nicholas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

