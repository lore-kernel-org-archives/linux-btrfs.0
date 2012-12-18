Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47598 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab2LRQDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 11:03:35 -0500
Received: by mail-oa0-f45.google.com with SMTP id i18so823891oag.32
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 08:03:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvi322erCrtiz4YujKwsy1y9FXph6uPOR8XufahajzUg0A@mail.gmail.com>
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
	<20121217103624.GA15304@panda>
	<201212172220.42946.russell@coker.com.au>
	<CACR_K2t2uD_NjxzhTxGFMorVu_sSziv7LGbOSTafdADnFT=-mA@mail.gmail.com>
	<CACR_K2u4gYOd9xMOS8JuPssqLBySAnW+Ubg05F1r2X=yzjMWXQ@mail.gmail.com>
	<CAE5mzvi322erCrtiz4YujKwsy1y9FXph6uPOR8XufahajzUg0A@mail.gmail.com>
Date: Tue, 18 Dec 2012 11:03:34 -0500
Message-ID: <CACR_K2u5O4x90A_25BV3kxCnd0CJVOUhQTE_oyOy0j8XwM+XzA@mail.gmail.com>
Subject: Re: btrfs subvolume snapshot performance problem
From: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I own this SSD :
http://ark.intel.com/products/66250/Intel-SSD-520-Series-240GB-2_5in-SATA-6Gbs-25nm-MLC

I don't think it's a pile of crap :P

So basically, I could remove the discard option inside my /etc/fstab
and I should run fstrim when I have the time.

Maybe someone should update the btrfs wiki and write something about
the discard situation. I tought that I had to use this option to save
some lifespan for my SSD.

2012/12/18 cwillu <cwillu@cwillu.com>:
> On Tue, Dec 18, 2012 at 7:06 AM, Sylvain Alain <d2racing911@gmail.com> wrote:
>> So, if I don't use the discard command, how often do I need to run the
>> fstrim command ?
>
> If your ssd isn't a pile of crap, never.  SSD's are always
> over-provisioned, and so every time an erase block fills up, the drive
> knows that there must be one erase-block worth of garbage which could
> be compacted, erased, and added to the pool of empty blocks.  The
> crappiest ones only do this as needed (which is why their write speed
> plummets with use), and really benefit from people forcing the issue
> with -o discard or occasional fstrim.  Everything else should get
> along fine without it, although an occasional fstrim certainly won't
> hurt: it just shouldn't help much.
>
>> I found this thread : https://patrick-nagel.net/blog/archives/337
>
> It's worth noting that there's a large number of very effective tricks
> that an ssd can perform to almost completely negate the caveat
> mentioned there.  It really is a solved problem in a modern ssd.



-- 
Salut
alp
Sylvain
