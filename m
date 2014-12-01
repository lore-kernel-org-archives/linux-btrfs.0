Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:48668 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaLAT6K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 14:58:10 -0500
Received: by mail-qa0-f44.google.com with SMTP id i13so7665755qae.17
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 11:58:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5ifgo$c1e$1@ger.gmane.org>
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
Date: Mon, 1 Dec 2014 11:58:09 -0800
Message-ID: <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 11:28 AM, Alex Elsayed <eternaleye@gmail.com> wrote:

> I think there's a fundamental set of points being missed.

That may be true, but it is not me who is missing them.
> * The Crypto API can be used to access non-cryptographic hashes. Full stop.

Irrelevant to my point. I am talking about specific non-cryptographic
hashes, and they are not currently in the Crypto API.

> * He was comparing CRC32 (a 32-bit non-cryptographic hash, *via the Crypto
> API*) against SHA-1 (a 128-bit cryptographic hash, via the Crypto API), and
> SHA-1 _still_ won. CRC32 tends to beat the pants off 128-bit non-
> cryptographic hashes simply because those require multiple registers to
> store the state if nothing else; which makes this a rather strong argument
> that _hardware matters a heck of a lot_, quite possibly _more_ than the
> algorithm.

Again, irrelevant. The Spooky2, CityHash256, and Murmur3 hashes that I
am talking about can and do take advantage of CPU architecture. For
128- and 256-bit hashes, one (or more) of those three will be
significantly faster than any crypto hash in the Crypto API,
regardless of the CPU it is run on.

As for the possibility of adding more hash functions to Crypto API for
btrfs to use, I do not believe I have argued against it, so I am not
sure why you repeated the point. It seems to me that is a discussion
that must be had with the maintainer(s) of Crypto API (will they
accept additional non-crypto 128- and 256-bit hash functions, etc.)
