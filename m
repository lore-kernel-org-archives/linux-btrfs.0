Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53533 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaLAUqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 15:46:42 -0500
Received: by mail-qc0-f178.google.com with SMTP id b13so9185557qcw.37
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 12:46:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5ihs4$cep$2@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
	<m5dcia$tk8$1@ger.gmane.org>
	<CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
	<547C618C.8020201@gmail.com>
	<CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
	<547CA870.9040904@gmail.com>
	<CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com>
	<m5ifgo$c1e$1@ger.gmane.org>
	<CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com>
	<m5ihkj$cep$1@ger.gmane.org>
	<m5ihs4$cep$2@ger.gmane.org>
Date: Mon, 1 Dec 2014 12:46:41 -0800
Message-ID: <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 12:08 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> Actually, I said "Sure" here, but this isn't strictly true. At some point,
> you're more memory-bound than CPU-bound, and with CPU intrinsic instructions
> (like SPARC and recent x86 have for SHA) you're often past that. Then,
> you're not going to see any real difference - and the accelerated
> cryptographic hashes may even win out, because the intrinsics may be faster
> (less stuff of the I$, pipelined single instruction beating multiple simpler
> instructions, etc) than the software non-cryptographic hash.

In practice, I am skeptical whether any 128- or 256-bit crypto hashes
will be as fast as the non-crypto hashes I mentioned, even on CPUs
with specific instructions for the crypto hashes. The non-crypto
hashes can (and do) take advantage of special CPU instructions as
well.

But even if true that the crypto hashes approach the speed of
non-crypto hashes on certain CPUs, that does not provide a strong
argument for using the crypto hashes, since on the common x64 CPUs,
the non-crypto hashes I mentioned are significantly faster than the
equivalent crypto hashes.

So, you have some rare architectures where the crypto hashes may
almost be as fast as the non-crypto, and common CPUs where the
non-crypto are much faster. That makes the non-crypto hash functions I
mentioned the obvious choice in the vast majority of systems.
