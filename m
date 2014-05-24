Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41444 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEXUBD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 16:01:03 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so6155707wgh.17
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 13:01:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5380EDF7.6010606@gmail.com>
References: <CANg_oxybdjtOXrqo=yLPEKEz=NrJtSRfGgMxDeCQP+0EAbV_Qw@mail.gmail.com>
	<5380EDF7.6010606@gmail.com>
Date: Sat, 24 May 2014 22:01:01 +0200
Message-ID: <CANg_oxznQP=veRsxpcy1T_RArmz_SLM3=9_Vsw-Hn++RebVk7A@mail.gmail.com>
Subject: Re: is it safe to change BTRFS_STRIPE_LEN?
From: john terragon <jterragon@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes the btrfs-tools would have to be recompiled too ( BTRFS_STRIPE_LEN
is defined in a volumes.h in there too).
And yes, kernel and tools would certainly kill any raid0 btrfs fs and
maybe any other multidevice kind of setting.


On Sat, May 24, 2014 at 9:07 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 05/24/2014 12:44 PM, john terragon wrote:
>> Hi.
>>
>> I'm playing around with (software) raid0 on SSDs and since I remember
>> I read somewhere that intel recommends 128K stripe size for HDD arrays
>> but only 16K stripe size for SSD arrays, I wanted to see how a
>> small(er) stripe size would work on my system. Obviously with btrfs on
>> top of md-raid I could use the stripe size I want. But if I'm not
>> mistaken the stripe size with the native raid0 in btrfs is fixed to
>> 64K in BTRFS_STRIPE_LEN (volumes.h).
>> So I was wondering if it would be reasonably safe to just change that
>> to 16K (and duck and wait for the explosion ;) ).
>>
>> Can anyone adept to the inner workings of btrfs raid0 code confirm if
>> that would be the right way to proceed? (obviously without absolutely
>> any blame to be placed on anyone other than myself if things should go
>> badly :) )
> I personally can't render an opinion on whether changing it would make
> things break or not, but I do know that it would need to be changed both
> in the kernel and the tools, and the resultant kernel and tools would
> not be entirely compatible with filesystems produced by the regular
> tools and kernel, possibly to the point of corrupting any filesystem
> they touch.
>
> As for the 64k default strip size, that sounds correct, and is probably
> because that's the largest block that the I/O schedulers on Linux will
> dispatch as a single write to the underlying device.
>
