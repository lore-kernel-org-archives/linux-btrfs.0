From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 13 Jan 2009 09:40:43 -0500
Message-ID: <1231857643.29164.28.camel@think.oraclecorp.com>
References: <20090113142147.GE16333@alice>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090113142147.GE16333@alice>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> Hi,
> 
> when mounting an intentionally corrupted btrfs filesystem i get the
> following warning and bug message. The image can be found here
> www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2

Thanks for looking at things

Aside from catching checksumming errors, we're not quite ready for
fuzzer style attacks.  The code will be hardened for this but it isn't
yet.

-chris


