Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40986 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaKZRxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 12:53:23 -0500
Received: by mail-qa0-f44.google.com with SMTP id i13so2266577qae.31
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 09:53:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan.2014.11.26.12.50.03@googlemail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<pan.2014.11.24.08.23.25@googlemail.com>
	<pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
	<CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
	<20141125103024.GC23574@localhost.localdomain>
	<CAJBj3vckdFCwh0vr7kF-_z8-PnTN5zL1zy_zcma2waDfTqj6GA@mail.gmail.com>
	<pan.2014.11.26.12.50.03@googlemail.com>
Date: Wed, 26 Nov 2014 09:53:22 -0800
Message-ID: <CAJBj3veehruQ2_1+7uqMrRcR4bHJjBxP+gpS5QMyyFxEjTyiAQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 4:50 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Tue, 25 Nov 2014 15:17:58 -0800, John Williams wrote:
>
>> 2) CityHash : for 256-bit hashes on all systems
>> https://code.google.com/p/cityhash/
>
> Btw this is now superseded by Farmhash:
> https://code.google.com/p/farmhash/
>

It seems FarmHash is not a complete replacement for CityHash.
Specifically, I don't see a Fingerprint256() function in FarmHash, so
no 256-bit fingerprints (unless I am missing something?). Also, it
seems that FarmHash's Fingerprint128() hash is just CityHash128().

Unless I am misreading it, I think FarmHash is mostly useful for
32-bit and 64-bit hashes.
