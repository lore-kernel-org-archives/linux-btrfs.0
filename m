Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56074 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2FYD2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 23:28:00 -0400
Received: by wibhm11 with SMTP id hm11so2520906wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 20:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206162223.20392.Martin@lichtvoll.de>
References: <201206162223.20392.Martin@lichtvoll.de>
From: Chester <somethingsome2000@gmail.com>
Date: Sun, 24 Jun 2012 22:27:39 -0500
Message-ID: <CAAE6i0hruv7t-cXCbGwCvqsVW2AfBnvEbrZUf4=YraHBgsgYVQ@mail.gmail.com>
Subject: Re: kernel got struck while scrubbing BTRFS with node- and leafsize 32768
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 16, 2012 at 3:23 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
>
> [251818.022631] ------------[ cut here ]------------
> [251818.022714] WARNING: at
>
> /media/data/mattems/src/linux-2.6-3.4.1/debian/build/source_amd64_none/fs/btrfs/extent_io.c:4522
> read_extent_buffer+0x43/0xf0 [btrfs]()
> [251818.022723] Hardware name: 42433WG
> [251818.022727] Modules linked in: rose usb_storage uas rfcomm bnep btusb

I don't think btrfs supported big blocks until recently. Something
like 3.3 or 3.4.. Anything from 2.6 would definitely not cut it.

> Data is not critically important, but I do not like to loose it either.
> Thus
> at least two copies.
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
