Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33535 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2LRQXV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 11:23:21 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so642161pad.38
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 08:23:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACR_K2u4gYOd9xMOS8JuPssqLBySAnW+Ubg05F1r2X=yzjMWXQ@mail.gmail.com>
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
	<20121217103624.GA15304@panda>
	<201212172220.42946.russell@coker.com.au>
	<CACR_K2t2uD_NjxzhTxGFMorVu_sSziv7LGbOSTafdADnFT=-mA@mail.gmail.com>
	<CACR_K2u4gYOd9xMOS8JuPssqLBySAnW+Ubg05F1r2X=yzjMWXQ@mail.gmail.com>
Date: Tue, 18 Dec 2012 09:27:52 -0600
Message-ID: <CAE5mzvi322erCrtiz4YujKwsy1y9FXph6uPOR8XufahajzUg0A@mail.gmail.com>
Subject: Re: btrfs subvolume snapshot performance problem
From: cwillu <cwillu@cwillu.com>
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 7:06 AM, Sylvain Alain <d2racing911@gmail.com> wrote:
> So, if I don't use the discard command, how often do I need to run the
> fstrim command ?

If your ssd isn't a pile of crap, never.  SSD's are always
over-provisioned, and so every time an erase block fills up, the drive
knows that there must be one erase-block worth of garbage which could
be compacted, erased, and added to the pool of empty blocks.  The
crappiest ones only do this as needed (which is why their write speed
plummets with use), and really benefit from people forcing the issue
with -o discard or occasional fstrim.  Everything else should get
along fine without it, although an occasional fstrim certainly won't
hurt: it just shouldn't help much.

> I found this thread : https://patrick-nagel.net/blog/archives/337

It's worth noting that there's a large number of very effective tricks
that an ssd can perform to almost completely negate the caveat
mentioned there.  It really is a solved problem in a modern ssd.
