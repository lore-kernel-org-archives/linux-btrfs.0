From: Andi Kleen <andi@firstfloor.org>
Subject: Re: file/extent checksums for dedup/sync...
Date: Wed, 27 Jan 2010 13:30:43 +0100
Message-ID: <87pr4venm4.fsf@basil.nowhere.org>
References: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com> (Daniel J. Blueman's message of "Wed, 27 Jan 2010 12:10:50 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

Daniel J Blueman <daniel.blueman@gmail.com> writes:

> For purposes of data deduplication and data synchronisation, it would
> be a powerful tool to expose file data checksums.
>
> Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
> the file's overall CRC from the accumulation of the CRCs from all it's
> extents' CRCs.
>
> For now, exposing this via an IOCTL may be sufficient, though any
> ideas for introducing it in a more standard way? (it's a pity that
> when stat64 was introduced, reserved fields weren't added)

The problem of doing it in any "standard way" is that it would
hard code the way the file system does checksums in the applications.
So the file system could never change it without breaking
user space.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
