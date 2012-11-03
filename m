Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:55596 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2KCEN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 00:13:26 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so1903365dak.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 21:13:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
References: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
Date: Fri, 2 Nov 2012 22:13:26 -0600
Message-ID: <CAE5mzvj38wxYWgcV+77hB-YmCS7ZKH_4sigf3ybcyMY9NB==zg@mail.gmail.com>
Subject: Re: What's the minimum size I can shrink my FS to?
From: cwillu <cwillu@cwillu.com>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run "btrfs balance start -musage=1 -dusage=1", and then try it again.
This may require update btrfs tools however.

On Fri, Nov 2, 2012 at 10:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
> Hello,
> I'm trying to shrink my Btrfs filesystem to the smallest size it can
> go, here's the information:
>
> failed to read /dev/sr0
> Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
> Total devices 1 FS bytes used 491.86GB
> devid    1 size 612.04GB used 605.98GB path /dev/sda6
>
> Btrfs Btrfs v0.19
>
> Data: total=580.90GB, used=490.88GB
> System, DUP: total=32.00MB, used=76.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=12.51GB, used=1001.61MB
>
> Here's the command I use to resize:
>
> [root@archpc ~]# btrfs file res 500g /home/jordan/Storage/
> Resize '/home/jordan/Storage/' of '500g'
> ERROR: unable to resize '/home/jordan/Storage/' - No space left on device
>
> I was wondering if that size doesn't work then what's the minimum I
> can shrink to?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
