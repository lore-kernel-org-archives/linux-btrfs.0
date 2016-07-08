Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37868 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbcGHQLD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 12:11:03 -0400
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Chris Murphy <lists@colorremedies.com>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <CAJCQCtRV2Eis8h9u_Mpum_pFoLzOQe+LjooO0Y4_AYqwsVBiMA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <c8c5564e-623a-f1ca-b1c2-521e18de714c@fastmail.fm>
Date: Fri, 8 Jul 2016 18:10:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRV2Eis8h9u_Mpum_pFoLzOQe+LjooO0Y4_AYqwsVBiMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 19:57, Chris Murphy wrote:
> Use F3 to test flash:
> http://oss.digirati.com.br/f3/

I tested my USB flash drive with F3 as you suggested, and there's no
indication it is a fake device.

---------------

# f3probe --destructive /dev/sdb
F3 probe 6.0
Copyright (C) 2010 Digirati Internet LTDA.
This is free software; see the source for copying conditions.

WARNING: Probing normally takes from a few seconds to 15 minutes, but
         it can take longer. Please be patient.

Good news: The device `/dev/sdb' is the real thing

Device geometry:
	         *Usable* size: 57.69 GB (120979456 blocks)
	        Announced size: 57.69 GB (120979456 blocks)
	                Module: 64.00 GB (2^36 Bytes)
	Approximate cache size: 0.00 Byte (0 blocks), need-reset=no
	   Physical block size: 512.00 Byte (2^9 Bytes)

Probe time: 2'23"

--------------

$ f3read /run/media/fturco/a7d8a7b1-e0c2-4fbb-879f-e17046989f3c
                  SECTORS      ok/corrupted/changed/overwritten
Validating file 1.h2w ... 2097152/        0/      0/      0
Validating file 2.h2w ... 2097152/        0/      0/      0
Validating file 3.h2w ... 2097152/        0/      0/      0
Validating file 4.h2w ... 2097152/        0/      0/      0
Validating file 5.h2w ... 2097152/        0/      0/      0
Validating file 6.h2w ... 2097152/        0/      0/      0
Validating file 7.h2w ... 2097152/        0/      0/      0
Validating file 8.h2w ... 2097152/        0/      0/      0
Validating file 9.h2w ... 2097152/        0/      0/      0
Validating file 10.h2w ... 2097152/        0/      0/      0
Validating file 11.h2w ... 2097152/        0/      0/      0
Validating file 12.h2w ... 2097152/        0/      0/      0
Validating file 13.h2w ... 2097152/        0/      0/      0
Validating file 14.h2w ... 2097152/        0/      0/      0
Validating file 15.h2w ... 2097152/        0/      0/      0
Validating file 16.h2w ... 2097152/        0/      0/      0
Validating file 17.h2w ... 2097152/        0/      0/      0
Validating file 18.h2w ... 2097152/        0/      0/      0
Validating file 19.h2w ... 2097152/        0/      0/      0
Validating file 20.h2w ... 2097152/        0/      0/      0
Validating file 21.h2w ... 2097152/        0/      0/      0
Validating file 22.h2w ... 2097152/        0/      0/      0
Validating file 23.h2w ... 2097152/        0/      0/      0
Validating file 24.h2w ... 2097152/        0/      0/      0
Validating file 25.h2w ... 2097152/        0/      0/      0
Validating file 26.h2w ... 2097152/        0/      0/      0
Validating file 27.h2w ... 2097152/        0/      0/      0
Validating file 28.h2w ... 2097152/        0/      0/      0
Validating file 29.h2w ... 2097152/        0/      0/      0
Validating file 30.h2w ... 2097152/        0/      0/      0
Validating file 31.h2w ... 2097152/        0/      0/      0
Validating file 32.h2w ... 2097152/        0/      0/      0
Validating file 33.h2w ... 2097152/        0/      0/      0
Validating file 34.h2w ... 2097152/        0/      0/      0
Validating file 35.h2w ... 2097152/        0/      0/      0
Validating file 36.h2w ... 2097152/        0/      0/      0
Validating file 37.h2w ... 2097152/        0/      0/      0
Validating file 38.h2w ... 2097152/        0/      0/      0
Validating file 39.h2w ... 2097152/        0/      0/      0
Validating file 40.h2w ... 2097152/        0/      0/      0
Validating file 41.h2w ... 2097152/        0/      0/      0
Validating file 42.h2w ... 2097152/        0/      0/      0
Validating file 43.h2w ... 2097152/        0/      0/      0
Validating file 44.h2w ... 2097152/        0/      0/      0
Validating file 45.h2w ... 2097152/        0/      0/      0
Validating file 46.h2w ... 2097152/        0/      0/      0
Validating file 47.h2w ... 2097152/        0/      0/      0
Validating file 48.h2w ... 2097152/        0/      0/      0
Validating file 49.h2w ... 2097152/        0/      0/      0
Validating file 50.h2w ... 2097152/        0/      0/      0
Validating file 51.h2w ... 2097152/        0/      0/      0
Validating file 52.h2w ... 2097152/        0/      0/      0
Validating file 53.h2w ... 2097152/        0/      0/      0
Validating file 54.h2w ... 2097152/        0/      0/      0
Validating file 55.h2w ... 2097152/        0/      0/      0
Validating file 56.h2w ... 1364266/        0/      0/      0

  Data OK: 55.65 GB (116707626 sectors)
Data LOST: 0.00 Byte (0 sectors)
	       Corrupted: 0.00 Byte (0 sectors)
	Slightly changed: 0.00 Byte (0 sectors)
	     Overwritten: 0.00 Byte (0 sectors)
Average reading speed: 34.73 MB/s

----------------

> Read more, and also includes a much faster alternative for GNOME:
> https://blogs.gnome.org/hughsie/2015/01/28/detecting-fake-flash/

I also tested my flash drive with gnome-multi-writer-probe, and it says
it is not fake:

# gnome-multi-writer-probe /dev/sdb
Device is GOOD

I also created a big file with dd using /dev/urandom with the same size
as my flash drive, copied it once and read it three times. The SHA-1
checksum is always the same and matches the original one on the hard disk.

So after much testing I feel I can conclude that my USB flash drive is
not fake and it is not defective.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
