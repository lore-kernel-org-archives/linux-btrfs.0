Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbaLAW5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 17:57:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvZtv-00074J-Gg
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 23:57:03 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 23:57:03 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 23:57:03 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 14:56:48 -0800
Message-ID: <m5irni$ieq$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com> <m5ihkj$cep$1@ger.gmane.org> <m5ihs4$cep$2@ger.gmane.org> <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 12:08 PM, Alex Elsayed <eternaleye@gmail.com>
> wrote:
>> Actually, I said "Sure" here, but this isn't strictly true. At some
>> point, you're more memory-bound than CPU-bound, and with CPU intrinsic
>> instructions (like SPARC and recent x86 have for SHA) you're often past
>> that. Then, you're not going to see any real difference - and the
>> accelerated cryptographic hashes may even win out, because the intrinsics
>> may be faster (less stuff of the I$, pipelined single instruction beating
>> multiple simpler instructions, etc) than the software non-cryptographic
>> hash.
> 
> In practice, I am skeptical whether any 128- or 256-bit crypto hashes
> will be as fast as the non-crypto hashes I mentioned, even on CPUs
> with specific instructions for the crypto hashes. The non-crypto
> hashes can (and do) take advantage of special CPU instructions as
> well.
> 
> But even if true that the crypto hashes approach the speed of
> non-crypto hashes on certain CPUs, that does not provide a strong
> argument for using the crypto hashes, since on the common x64 CPUs,
> the non-crypto hashes I mentioned are significantly faster than the
> equivalent crypto hashes.
> 
> So, you have some rare architectures where the crypto hashes may
> almost be as fast as the non-crypto, and common CPUs where the
> non-crypto are much faster. That makes the non-crypto hash functions I
> mentioned the obvious choice in the vast majority of systems.

And as I said upthread, one benefit of the Crypto API is that the filesystem 
developers _no longer have to choose_. By using the shash or ahash interface 
to the Crypto API, the _user_ can choose *any* hash the kernel supports. And 
the default is (and will almost certainly continue to be) crc32, so the user 
would need to specify a hash anyway - making whether some other non-
cryptographic hash is the "obvious choice" a completely moot point.

