Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:52606 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaLARtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 12:49:08 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so7453497qae.41
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 09:49:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547CA870.9040904@gmail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
	<m5dcia$tk8$1@ger.gmane.org>
	<CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
	<547C618C.8020201@gmail.com>
	<CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
	<547CA870.9040904@gmail.com>
Date: Mon, 1 Dec 2014 09:49:07 -0800
Message-ID: <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 9:42 AM, Austin S Hemmelgarn > Except most of
the CPU optimized hashes aren't crypto hashes (other than the
> various SHA implementations).  Furthermore, I've actually tested the speed
> of a generic CRC32c implementation versus SHA-1 using the SHA instructions
> on an UltraSPARC processor, and the difference ammounts to a few
> microseconds in _favor_ of the optimized crypto hash; and I've run the math
> for every other ISA that has instructions for computing SHA hashes (I don't
> have the hardware for any of the others), and expect similar results for
> those as well.

I think the confusion here is that I am talking about 128-bit and
256-bit hashes, which is what you would choose for filesystem
checksums if you want to have extremely strong collision resistance
(eg., you could also use it for dedup).

You seem to be talking about 32-bit (and maybe 64-bit) hashes.

The speed difference between crypto 128- and 256-bit hashes and
non-crypto equivalents that I have mentioned is an order of magnitude
or more.
