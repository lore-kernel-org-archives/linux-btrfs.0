Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36077 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcAEQeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 11:34:04 -0500
Received: by mail-wm0-f51.google.com with SMTP id l65so29391548wmf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 08:34:02 -0800 (PST)
Subject: Re: Purposely using btrfs RAID1 in degraded mode ?
To: Alphazo <alphazo@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
From: Psalle <psalleetsile@gmail.com>
Message-ID: <568BF078.8060303@gmail.com>
Date: Tue, 5 Jan 2016 17:34:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Alphazo,

I am a mere btrfs user, but given the discussions I regularly see here 
about difficulties with degraded filesystems I wouldn't rely on this 
(yet?) as a regular work strategy, even if it's supposed to work.

If you're familiar with git, perhaps git-annex could be an alternative.

-Psalle.

On 04/01/16 18:00, Alphazo wrote:
> Hello,
>
> My picture library today lies on an external hard drive that I sync on
> a regular basis with a couple of servers and other external drives.
> I'm interested by the on-the-fly checksum brought by btrfs and would
> like to get your opinion on the following unusual use case that I have
> tested:
> - Create a btrfs with the two drives with RAID1
> - When at home I can work with the two drives connected so I can enjoy
> the self-healing feature if a bit goes mad so I only backup perfect
> copies to my backup servers.
> - When not at home I only bring one external drive and manually mount
> it in degraded mode so I can continue working on my pictures while
> still having checksum error detection (but not correction).
> - When coming back home I can plug-back the seconde drive and initiate
> a scrub or balance to get the second drive duplicated.
>
> I have tested the above use case with a couple of USB flash drive and
> even used btrfs over dm-crypt partitions and it seemed to work fine
> but I wanted to get some advices from the community if this is really
> a bad practice that should not be used on the long run. Is there any
> limitation/risk to read/write to/from a degraded filesystem knowing it
> will be re-synced later?
>
> Thanks
> alphazo
>
> PS: I have also investigated the RAID1 on a single drive with two
> partitions but I cannot afford the half capacity resulting from that
> approach.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

