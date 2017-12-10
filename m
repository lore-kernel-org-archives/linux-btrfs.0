Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:54370 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdLJPiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 10:38:06 -0500
Date: Sun, 10 Dec 2017 16:38:05 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: constantine <costas.magnuse@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: ERROR: failed to repair root items: Input/output error
Message-ID: <20171210153804.GA32313@polanet.pl>
References: <CANcfdL3LFXYFcr-qJDNhEvCttc3yEKKWY53aun0eC_gF0CXrrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CANcfdL3LFXYFcr-qJDNhEvCttc3yEKKWY53aun0eC_gF0CXrrw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 10, 2017 at 15:18:32 +0000, constantine wrote:

> I have a laptop root hard drive (Samsung SSD 850 EVO 1TB), which is
> within warranty.
> I can't mount it read-write ("no rw mounting  after error").

There is a data-corruption issue with this controller!
The same as 840 EVO - just google this.

In short: either use recent kernel (AFAIR 4.0.5+ for 840 EVO and some
newer for entire 8* Samsung SSD family blacklisting) or disable NCQ.

Using queued TRIM on this drive leads to data loss! Firmware zeroes fist
512 bytes of a block, sorry.

If you only had smaller drive, as 850s up to 512 GB have different
controller...

> checksum verify failed on 103009173504 found 25334496 wanted 00003500
> bytenr mismatch, want=103009173504, have=889192478
> ERROR: failed to repair root items: Input/output error
> 
> What do these errors mean?
> What should I do to fix the filesystem and be able to mount it read-write?

You probably can't fix this - there is data missing on bare metal, so you should
recover using backups. If you don't have one, you need to perform manual
data recovery procedures (like photorec) with little chances to restore
complete files due to the nature of data loss (beginning of blocks).

-- 
Tomasz Pala <gotar@pld-linux.org>
