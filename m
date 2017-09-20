Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0058.outbound.protection.outlook.com ([104.47.116.58]:18944
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbdITBdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 21:33:47 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Pat Sailor <psalleetsile@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: SSD caching an existing btrfs raid1
Date: Wed, 20 Sep 2017 01:33:45 +0000
Message-ID: <MEXPR01MB216842616209097CB3BE95AC9E610@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
In-Reply-To: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Pat Sailor
> Sent: Wednesday, 20 September 2017 1:31 AM
> To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
> Subject: SSD caching an existing btrfs raid1
> 
> Hello,
> 
> I have a half-filled raid1 on top of six spinning devices. Now I have come into
> a spare SSD I'd like to use for caching, if possible without having to rebuild or,
> failing that, without having to renounce to btrfs and flexible reshaping.
> 
> I've been reading about the several options out there; I thought that
> EnhanceIO would be the simplest bet but unfortunately I couldn't get it to
> build with my recent kernel (last commits are from years ago).
> 
> Failing that, I read that lvmcache could be the way to go. However, I can't
> think of a way of setting it up in which I retain the ability to
> add/remove/replace drives as I can do now with pure btrfs; if I opted to drop
> btrfs to go to ext4 I still would have to offline the filesystem for downsizes.
> Not a frequent occurrence I hope, but now I'm used to keep working while I
> reshape things in btrfs, and it's better if I can avoid large downtimes.
> 
> Is what I want doable at all? Thanks in advance for any
> suggestions/experiences to proceed.

When I did mine I used a spare disk to create the initial LVM filesystem, then used btrfs dev replace to swap one of the raid1 mirrors to the new lvm device. Then repeat for the other mirror.
My suggestion for lvm setup is to use two different pools, one for each btrfs mirror. That ensures you don't accidently have btrfs sharing the one physical disk by mistake, or lvm using the same SSD to cache the two discs.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
