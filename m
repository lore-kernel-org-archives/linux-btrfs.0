Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45429 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 12:18:44 -0400
Received: by mail-vc0-f179.google.com with SMTP id ht10so6525477vcb.24
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 09:18:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5239EDC3.2060804@mur.at>
References: <5236E1FF.4080900@mur.at>
	<5238343F.3020802@mur.at>
	<20130917111809.GA16032@panda>
	<52384A08.40404@mur.at>
	<523873FC.20504@mur.at>
	<CAFvQSYS7U6VdYeUa-BocBq2tgQuyg1Z_eqpO=6UkcER2a1_p-g@mail.gmail.com>
	<5239EDC3.2060804@mur.at>
Date: Thu, 19 Sep 2013 12:18:43 -0400
Message-ID: <CAC4gV=57gOWABD3n+fhEkxRVDKKeejKSQYVEC-M=V2rDXr8Uog@mail.gmail.com>
Subject: Re: rootfs crash
From: Frank Holton <fholton@gmail.com>
To: =?ISO-8859-1?Q?Jogi_Hofm=FCller?= <jogi@mur.at>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jogi,

I'm not sure what's causing the free error, I'll keep looking.

Have you tried running restore on your home subvolume yet? By default
restore only works on the default subvolume which in your case is /

The following command will try to restore your /home subvolume
btrfs restore -i -r 258 [image] [destination]

Run that and see if you get your home folder restored. Hopefully the
errors are only on the root volume.

You can also try the /var subvolume which is 257 instead of 258.

Let me know if any of that helps,
Frank

On Wed, Sep 18, 2013 at 2:15 PM, Jogi Hofmüller <jogi@mur.at> wrote:
> Hi Clemens, all,
> Am 2013-09-17 20:53, schrieb Clemens Eisserer:
>
>> a. comment out the free()-calls which led to crashes
>
> Uh, well, I did not want to go that far ;)  I'm certainly not the
> greatest programmer around, but not freeing allocated memory seems kind
> of drastic.
>
> Anyway, I checked out a copy of btrfs-progs from git and took a look at
> the code.  Then I remembered valgrind and instead of running btrfs
> restore on the broken machine I tried it on my images (saved with dd on
> an external hard drive).  Running the self-compiled program using sudo
> resulted in the same errors.
>
> Now the (at least for me) fun part.  Running it under my UID I managed
> to retrieve 13GB worth of data so far before hitting the same error:
>
>   Error in `./btrfs': free(): invalid next size (normal)
>
> I would be glad for someone's opinion on this.
>
> Regards!
> --
> j.hofmüller
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
