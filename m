Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59627 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaEUXaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 19:30:03 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so2047914eek.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 16:30:01 -0700 (PDT)
Message-ID: <537D36F3.7070707@gmail.com>
Date: Thu, 22 May 2014 02:29:55 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
References: <2308735.51F3c4eZQ7@xev> <lldpvm$s7c$1@ger.gmane.org> <537A7BF9.5060508@swiftspirit.co.za> <4483661.BdmCOR8JR5@xev>
In-Reply-To: <4483661.BdmCOR8JR5@xev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/5/2014 5:07 πμ, Russell Coker wrote:
> On Mon, 19 May 2014 23:47:37 Brendan Hide wrote:
>> This is extremely difficult to measure objectively. Subjectively ... see
>> below.
>>
>>> [snip]
>>>
>>> *What other failure modes* should we guard against?
>> I know I'd sleep a /little/ better at night knowing that a double disk
>> failure on a "raid5/1/10" configuration might ruin a ton of data along
>> with an obscure set of metadata in some "long" tree paths - but not the
>> entire filesystem.
> My experience is that most disk failures that don't involve extreme physical
> damage (EG dropping a drive on concrete) don't involve totally losing the
> disk.  Much of the discussion about RAID failures concerns entirely failed
> disks, but I believe that is due to RAID implementations such as Linux
> software RAID that will entirely remove a disk when it gives errors.
>
> I have a disk which had ~14,000 errors of which ~2000 errors were corrected by
> duplicate metadata.  If two disks with that problem were in a RAID-1 array
> then duplicate metadata would be a significant benefit.
>
>> The other use-case/failure mode - where you are somehow unlucky enough
>> to have sets of bad sectors/bitrot on multiple disks that simultaneously
>> affect the only copies of the tree roots - is an extremely unlikely
>> scenario. As unlikely as it may be, the scenario is a very painful
>> consequence in spite of VERY little corruption. That is where the
>> peace-of-mind/bragging rights come in.
> http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html
>
> The NetApp research on latent errors on drives is worth reading.  On page 12
> they report latent sector errors on 9.5% of SATA disks per year.  So if you
> lose one disk entirely the risk of having errors on a second disk is higher
> than you would want for RAID-5.  While losing the root of the tree is
> unlikely, losing a directory in the middle that has lots of subdirectories is
> a risk.
Seeing the results of that paper, I think erasure coding is a better 
solution. Instead of having many copies of metadata or data, we could do 
erasure coding using something like zfec[1] that is being used by 
Tahoe-LAFS, increasing their size by lets say 5-10%, and be quite safe 
even from multiple continuous bad sectors.

[1] https://pypi.python.org/pypi/zfec
>
> I can understand why people wouldn't want ditto blocks to be mandatory.  But
> why are people arguing against them as an option?
>
>
> As an aside, I'd really like to be able to set RAID levels by subtree.  I'd
> like to use RAID-1 with ditto blocks for my important data and RAID-0 for
> unimportant data.
>

