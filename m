Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35023 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbGFUB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 16:01:56 -0400
Received: by obbop1 with SMTP id op1so114511930obb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 13:01:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150706194932.GE10539@carfax.org.uk>
References: <559AD4E5.2030107@friedels.name> <559ADAB5.3050804@friedels.name> <20150706194932.GE10539@carfax.org.uk>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Mon, 6 Jul 2015 15:01:36 -0500
Message-ID: <CAC=t97D7p96+x_QQyAwa7c_2-TN0LvrBQ0TX_6B-2-b882JMWQ@mail.gmail.com>
Subject: Re: size 2.73TiB used 240.97GiB after balance
To: Hugo Mills <hugo@carfax.org.uk>, Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on my experience Hugo's advice is critical, get the bad drive
out of the pool when in raid56 and do not try to replace or delete it
while it's still attached and recognized.

If you add a new device, mount degraded and rebalance.  If you don't,
mount degraded then device delete missing.

On Mon, Jul 6, 2015 at 2:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Jul 06, 2015 at 09:44:53PM +0200, Hendrik Friedel wrote:
>> Hello,
>>
>> ok, sdc seems to have failed (sorry, I checked only sdd and sdb
>> SMART values, as sdc is brand new. Maybe a bad assumption, from my
>> side.
>>
>> I have mounted the device
>> mount -o recovery,ro
>>
>> So, what should I do now:
>> btrfs device delete /dev/sdc /mnt
>>
>> or
>>
>> mount -o degraded /dev/sdb /mnt
>> btrfs device delete missing /mnt
>>
>> I do have a backup of the most valuable data.
>> But if you consider one of the above options risky, I might better
>> get a new drive before, but this might take a couple of days (in
>> which sdc could further degrade).
>> What is your recommendation?
>
>    Physically remove the device from the array, mount with -o
> degraded, optionally add the new device, and run a balance.
>
>    Hugo.
>
> --
> Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
> hugo@... carfax.org.uk | pub in Pimlico."
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
