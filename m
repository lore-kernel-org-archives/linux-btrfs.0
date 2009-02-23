From: Chris Mason <chris.mason@oracle.com>
Subject: Re: SSDs and filesystem alignment...
Date: Mon, 23 Feb 2009 09:23:00 -0500
Message-ID: <1235398980.11205.5.camel@think.oraclecorp.com>
References: <6278d2220902220631r3d89fbcbgc3eef9570c452df3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220902220631r3d89fbcbgc3eef9570c452df3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-02-22 at 14:31 +0000, Daniel J Blueman wrote:
> Does BTRFS perform any journal and/or filesystem structure alignment
> (for benefit to SSD longevity and SSD, RAID array and large-sector
> device performance) at present?
> 
> ext4's Ted Tso will deliver 128KB alignment with the next release of
> e2fsprogs (ie 1.41.4) [1], so perhaps it's a good idea for btrfsprogs
> also, if not already available?
> 

The btrfs metadata works a little differently from ext4, since almost
nothing is in a fixed place.  The super blocks are aligned to 64k, and
the rest of the metadata is all dynamic.

Today, metadata allocations are 4k aligned but we do metadata
allocations in cluster of 256k in size (2MB in size in mount -o ssd
mode).  This results in larger metadata writes, and more contiguous
metadata writes.  The larger writes give the SSD FTL a better chance of
doing more optimal management of the flash.

Additional tuning for specific alignment is possible as well, the kernel
is growing the ability to discover device alignment characteristics, and
I plan on taking advantage of that.

-chris


