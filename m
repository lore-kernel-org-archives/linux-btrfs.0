Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49632 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaLAT2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 14:28:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvWeB-0004Z2-Tl
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 20:28:35 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 20:28:35 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 20:28:35 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 11:28:22 -0800
Message-ID: <m5ifgo$c1e$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 9:42 AM, Austin S Hemmelgarn > Except most of
> the CPU optimized hashes aren't crypto hashes (other than the
>> various SHA implementations).  Furthermore, I've actually tested the
>> speed of a generic CRC32c implementation versus SHA-1 using the SHA
>> instructions on an UltraSPARC processor, and the difference ammounts to a
>> few microseconds in _favor_ of the optimized crypto hash; and I've run
>> the math for every other ISA that has instructions for computing SHA
>> hashes (I don't have the hardware for any of the others), and expect
>> similar results for those as well.
> 
> I think the confusion here is that I am talking about 128-bit and
> 256-bit hashes, which is what you would choose for filesystem
> checksums if you want to have extremely strong collision resistance
> (eg., you could also use it for dedup).
> 
> You seem to be talking about 32-bit (and maybe 64-bit) hashes.
> 
> The speed difference between crypto 128- and 256-bit hashes and
> non-crypto equivalents that I have mentioned is an order of magnitude
> or more.

I think there's a fundamental set of points being missed.

* The Crypto API can be used to access non-cryptographic hashes. Full stop.

* He was comparing CRC32 (a 32-bit non-cryptographic hash, *via the Crypto 
API*) against SHA-1 (a 128-bit cryptographic hash, via the Crypto API), and 
SHA-1 _still_ won. CRC32 tends to beat the pants off 128-bit non-
cryptographic hashes simply because those require multiple registers to 
store the state if nothing else; which makes this a rather strong argument 
that _hardware matters a heck of a lot_, quite possibly _more_ than the 
algorithm.

Even if SHA-1 in software is vastly slower than CityHash or whatever in 
software, the Crypto API implementation *may not be purely software*.

* The main benefit of the Crypto API is not any specific hash, it's that 
it's a _common API_ for _using any supported hash_.

* Your preferred non-cryptographic hashes can, thus, be used _via_ the 
Crypto API.

* This has benefits of:
    * Code reuse (for anyone else who wants to use such a hash).

    * Optimization opportunities (if a CPU implements some primitive, it can 
be leveraged in an arch-specific implementation, which the Crypto API will 
use _automatically_).

    * Flexibility (by using the Crypto API, _any_ supported hash can be used 
generically, so the _user_ can decide whether they want rather than a small, 
hard-coded menu of options in btrfs).

