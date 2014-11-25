Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58895 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaKYXR7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 18:17:59 -0500
Received: by mail-qa0-f53.google.com with SMTP id bm13so1152194qab.26
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 15:17:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125103024.GC23574@localhost.localdomain>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<pan.2014.11.24.08.23.25@googlemail.com>
	<pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
	<CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
	<20141125103024.GC23574@localhost.localdomain>
Date: Tue, 25 Nov 2014 15:17:58 -0800
Message-ID: <CAJBj3vckdFCwh0vr7kF-_z8-PnTN5zL1zy_zcma2waDfTqj6GA@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: bo.li.liu@oracle.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 2:30 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Mon, Nov 24, 2014 at 11:34:46AM -0800, John Williams wrote:
>> For example, Spooky V2 hash is 128 bits and is very fast. It is
>> noncryptographic, but it is more than adequate for data checksums.
>>
>> http://burtleburtle.net/bob/hash/spooky.html
>>
>> SnapRAID uses this hash, and it runs at about 15 GB/sec on my machine
>> (Xeon E3-1270 V2 @ 3.50Ghz)
>
> Thanks for the suggestion, I'll take a look.
>
> Btw, it's not in kernel yet, is it?

No, as far as I know, it is not in the kernel.

By the way, as for the suggestion of blake2 hash, note that it is much
slower than Spooky V2 hash. That is to be expected, since blake2 is a
cryptographic hash (even if it is one that is fast relative to other
cryptographic hashes) and as a class, cryptographic hashes tend to be
an order of magnitude slower than the fastest noncryptographic hashes.

The hashes that I would recommend for use with btrfs checksums are:

1) SpookyHash V2 : for 128 bit hashes on 64-bit systems
http://burtleburtle.net/bob/hash/spooky.html

2) CityHash : for 256-bit hashes on all systems
https://code.google.com/p/cityhash/

3) Murmur3 :for 128-bit hashes on 32-bit systems (since Spooky and
City are not the fastest on most 32-bit systems)
https://code.google.com/p/smhasher/wiki/MurmurHash3

All of those are noncryptographic, but they all have good properties
that should make them more than adequate for data checksums and dedup
usage.

For more information, here are some comparisons of fast hash functions
(note that these comparisons were written 2 to 3 years ago):

http://blog.reverberate.org/2012/01/state-of-hash-functions-2012.html
http://research.neustar.biz/tag/spooky-hash/
