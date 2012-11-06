Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51627 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2KFPer (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 10:34:47 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so328902eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Nov 2012 07:34:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121105231502.GP3102@twin.jikos.cz>
References: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
	<CAE5mzvj38wxYWgcV+77hB-YmCS7ZKH_4sigf3ybcyMY9NB==zg@mail.gmail.com>
	<CACCfv7rQ4Gqiaf8r7XRMDQnXe_xT0-eJPoLCFTFneWOYwkuaEQ@mail.gmail.com>
	<CACCfv7o-=NEYAWu=Q2CTZYuk2ii6kmYoNuA94XxdMPrf3Sg_Kg@mail.gmail.com>
	<20121105231502.GP3102@twin.jikos.cz>
Date: Wed, 7 Nov 2012 02:04:46 +1030
Message-ID: <CACCfv7qGesmgNwo9S5U8svwjPx-F+_pAoXhnf+Mf=UTxSisqDQ@mail.gmail.com>
Subject: Re: What's the minimum size I can shrink my FS to?
From: Jordan Windsor <jordanw2@gmail.com>
To: dave@jikos.cz, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 6, 2012 at 9:45 AM, David Sterba <dave@jikos.cz> wrote:
> On Sat, Nov 03, 2012 at 03:10:52PM +1030, Jordan Windsor wrote:
>> [root@archpc ~]# btrfs fi df /home/jordan/Storage/
>> Data: total=580.88GB, used=490.88GB
>
> This is getting full, 84%, there is not much chance of getting rid of
> substantially many 1G-chunks through the 'usage=1' balance filter.
> Some of the space between 490G and 580G will be spent on slack space and
> fragmentation, the rest may be packed together by a higher usage= value
> (but will be slower due to relocating more data).
>
>> System, DUP: total=32.00MB, used=76.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=13.01GB, used=1001.83MB
>
> If you intend to shrink a filesystem, all space group types must be
> taken into account, so here you have at least
>
> 580G + 2x32M + 4M + 2x13G = ~607G
>
>> [root@archpc ~]# btrfs fi sh
>> failed to read /dev/sr0
>> Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
>> Total devices 1 FS bytes used 491.86GB
>> devid    1 size 612.04GB used 606.96GB path /dev/sda6
>                                 ^^^^^^
> confirmed :)
>
> So basically you cannot go under this number when shrinking. I think you
> can squeeze the metadata space down to 2G (or maybe to 1G, it's getting
> very close to 1G so hard to guess) by the -musage= filter AND using at
> least 3.7 kernel (or 3.6+ chris' for-linus branch) with the fixed
> over-allocation bug (otherwise the size will stay pinned at 2% of the
> filesystem size).
>
> david

Thanks for the info! Shame I can't save space though.
Thanks anyway.
