Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0080.outbound.protection.outlook.com ([104.47.116.80]:53114
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754051AbdKNJpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 04:45:12 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Martin Steigerwald <martin@lichtvoll.de>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Read before you deploy btrfs + zstd
Date: Tue, 14 Nov 2017 09:45:09 +0000
Message-ID: <MEXPR01MB21683900C1C821EC352028009E280@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <20171113225046.GD28899@suse.cz> <3013353.6rxLtS64S0@merkaba>
In-Reply-To: <3013353.6rxLtS64S0@merkaba>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Martin Steigerwald
> Sent: Tuesday, 14 November 2017 6:35 PM
> To: dsterba@suse.cz; linux-btrfs@vger.kernel.org
> Subject: Re: Read before you deploy btrfs + zstd
> 
> Hello David.
> 
> David Sterba - 13.11.17, 23:50:
> > while 4.14 is still fresh, let me address some concerns I've seen on
> > linux forums already.
> >
> > The newly added ZSTD support is a feature that has broader impact than
> > just the runtime compression. The btrfs-progs understand filesystem
> > with ZSTD since 4.13. The remaining key part is the bootloader.
> >
> > Up to now, there are no bootloaders supporting ZSTD. This could lead
> > to an unmountable filesystem if the critical files under /boot get
> > accidentally or intentionally compressed by ZSTD.
> 
> But otherwise ZSTD is safe to use? Are you aware of any other issues?
> 
> I consider switching from LZO to ZSTD on this ThinkPad T520 with
> Sandybridge.

I've been using it since rc2 and had no trouble at all so far. The filesystem is running faster now (with zstd) than it did uncompressed on 4.13


Paul.





