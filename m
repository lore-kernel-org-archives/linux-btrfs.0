Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52159 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbaLAUEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 15:04:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvXDD-0003ND-1s
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 21:04:47 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 21:04:47 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 21:04:47 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 12:04:34 -0800
Message-ID: <m5ihkj$cep$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 11:28 AM, Alex Elsayed <eternaleye@gmail.com>
> wrote:
> 
>> I think there's a fundamental set of points being missed.
> 
> That may be true, but it is not me who is missing them.
>> * The Crypto API can be used to access non-cryptographic hashes. Full
>> stop.
> 
> Irrelevant to my point. I am talking about specific non-cryptographic
> hashes, and they are not currently in the Crypto API.

Yes, but they're not anywhere else in the kernel either.

>> * He was comparing CRC32 (a 32-bit non-cryptographic hash, *via the
>> Crypto API*) against SHA-1 (a 128-bit cryptographic hash, via the Crypto
>> API), and SHA-1 _still_ won. CRC32 tends to beat the pants off 128-bit
>> non- cryptographic hashes simply because those require multiple registers
>> to store the state if nothing else; which makes this a rather strong
>> argument that _hardware matters a heck of a lot_, quite possibly _more_
>> than the algorithm.
> 
> Again, irrelevant. The Spooky2, CityHash256, and Murmur3 hashes that I
> am talking about can and do take advantage of CPU architecture. For
> 128- and 256-bit hashes, one (or more) of those three will be
> significantly faster than any crypto hash in the Crypto API,
> regardless of the CPU it is run on.

Sure.

> As for the possibility of adding more hash functions to Crypto API for
> btrfs to use, I do not believe I have argued against it, so I am not
> sure why you repeated the point. It seems to me that is a discussion
> that must be had with the maintainer(s) of Crypto API (will they
> accept additional non-crypto 128- and 256-bit hash functions, etc.)

In that case, I'm not sure what the reason for the thread continuing is? If 
they go in the Crypto API, there's no need to argue against cryptographic 
hashes either - it becomes the user's choice. That's pretty much the entire 
reason I kept responding; I figured that arguing against the cryptographic 
hashes _was_ an objection to the Crypto API, since they're basically a 
freebie for no effort if we use it.

