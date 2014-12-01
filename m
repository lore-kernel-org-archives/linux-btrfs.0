Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:61457 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaLARXA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 12:23:00 -0500
Received: by mail-qc0-f178.google.com with SMTP id b13so8822031qcw.37
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 09:22:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547C618C.8020201@gmail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
	<m5dcia$tk8$1@ger.gmane.org>
	<CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
	<547C618C.8020201@gmail.com>
Date: Mon, 1 Dec 2014 09:22:59 -0800
Message-ID: <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Alex Elsayed <eternaleye@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 4:39 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Just because it's a filesystem doesn't always mean that speed is the most
> important thing.  Personally, I can think of multiple cases where using a
> cryptographically strong hash would be preferable, for example:
>  * On an fs used solely for backup purposes
>  * On a fs used for /boot
>  * On an fs spread across a very large near-line disk array and mounted
>    by a system with a powerful CPU
>  * Almost any other case where data integrity is more important than
>    speed

What does data integrity have to do with whether the hash is
cryptographic or not? The primary difference between a cryptographic
and non-cryptographic hash is that the non-cryptographic hash can be
easily guessed / predicted (eg., an attack to deliberately create
collisions) whereas the cryptographic hash cannot (given reasonable
assumptions of CPU power).

For filesystem checksums it is difficult to imagine a deliberate
attack on the checksums. Consequently, the only really important
quality for the hash besides speed is collision resistance. The
non-crypto hashes that I have mentioned in this thread have excellent
collision resistant properties.

> The biggest reason to use the in-kernel Crypto API though, is that it gives
> a huge amount of flexibility, and provides pretty much transparent
> substitution of CPU optimized versions of the exported hash functions (for
> example, you don't have to know whether or not your processor supports
> Intel's CRC32 ISA extensions).

Which is worse than useless if the CPU-optimized crypto hash is slower
than the default non-crypto hash, and that will almost always be the
case. Besides, there is nothing magic happening in the Crypto API
library. If you implement your own hash, you can easily do a few
checks and choose the best code for the CPU.
