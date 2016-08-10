Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35328 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbcHJWuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 18:50:12 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so12380036wmg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 15:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSybRPdoe1FD1bXnqto7ovhrr=N8Zvwkz_4UWO0-0qJTg@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <CAJCQCtSybRPdoe1FD1bXnqto7ovhrr=N8Zvwkz_4UWO0-0qJTg@mail.gmail.com>
From: Dave T <davestechshop@gmail.com>
Date: Wed, 10 Aug 2016 18:50:09 -0400
Message-ID: <CAGdWbB7YCU8RznnN64ub8mdvZgcnWJTBxJVdyg2F=H-B71xyTw@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

see below

On Wed, Aug 10, 2016 at 5:15 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 1. Report 'btrfs check' without --repair, let's see what it complains
> about and if it might be able to plausibly fix this.

First, a small part of the dmesg output:

[  172.772283] Btrfs loaded
[  172.772632] BTRFS: device label top_level devid 1 transid 103495 /dev/dm-0
[  274.320762] BTRFS info (device dm-0): use lzo compression
[  274.320764] BTRFS info (device dm-0): disk space caching is enabled
[  274.320764] BTRFS: has skinny extents
[  274.322555] BTRFS info (device dm-0): bdev /dev/mapper/sysluks
errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[  274.329965] BTRFS: detected SSD devices, enabling SSD mode


Now, full output of btrfs check without repair option.


checking extents
bad metadata [292414541824, 292414558208) crossing stripe boundary
bad metadata [292414607360, 292414623744) crossing stripe boundary
bad metadata [292414672896, 292414689280) crossing stripe boundary
bad metadata [292414738432, 292414754816) crossing stripe boundary
bad metadata [292415787008, 292415803392) crossing stripe boundary
bad metadata [292415918080, 292415934464) crossing stripe boundary
bad metadata [292416376832, 292416393216) crossing stripe boundary
bad metadata [292418015232, 292418031616) crossing stripe boundary
bad metadata [292419325952, 292419342336) crossing stripe boundary
bad metadata [292419588096, 292419604480) crossing stripe boundary
bad metadata [292419915776, 292419932160) crossing stripe boundary
bad metadata [292422930432, 292422946816) crossing stripe boundary
bad metadata [292423061504, 292423077888) crossing stripe boundary
ref mismatch on [292423155712 16384] extent item 1, found 0
Backref 292423155712 root 258 not referenced back 0x2280a20
Incorrect global backref count on 292423155712 found 1 wanted 0
backpointer mismatch on [292423155712 16384]
owner ref check failed [292423155712 16384]
bad metadata [292423192576, 292423208960) crossing stripe boundary
bad metadata [292423323648, 292423340032) crossing stripe boundary
bad metadata [292429549568, 292429565952) crossing stripe boundary
bad metadata [292439904256, 292439920640) crossing stripe boundary
bad metadata [292440297472, 292440313856) crossing stripe boundary
bad metadata [292442525696, 292442542080) crossing stripe boundary
bad metadata [292443770880, 292443787264) crossing stripe boundary
bad metadata [292443967488, 292443983872) crossing stripe boundary
bad metadata [292444033024, 292444049408) crossing stripe boundary
bad metadata [292444098560, 292444114944) crossing stripe boundary
bad metadata [292444164096, 292444180480) crossing stripe boundary
bad metadata [292444229632, 292444246016) crossing stripe boundary
bad metadata [292444688384, 292444704768) crossing stripe boundary
bad metadata [292444884992, 292444901376) crossing stripe boundary
bad metadata [292445081600, 292445097984) crossing stripe boundary
bad metadata [292446720000, 292446736384) crossing stripe boundary
bad metadata [292448948224, 292448964608) crossing stripe boundary
Error: could not find btree root extent for root 258
Checking filesystem on /dev/mapper/cryptroot
UUID:
