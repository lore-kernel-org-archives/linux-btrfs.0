From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 13 Jan 2009 15:43:07 +0100
Message-ID: <20090113144307.GF16333@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231857643.29164.28.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Chris Mason (chris.mason@oracle.com) wrote:
> On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > Hi,
> > 
> > when mounting an intentionally corrupted btrfs filesystem i get the
> > following warning and bug message. The image can be found here
> > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> 
> Thanks for looking at things
> 
> Aside from catching checksumming errors, we're not quite ready for
> fuzzer style attacks.  The code will be hardened for this but it isn't
> yet.

Does this mean i should stop trying to break it for now or are you interested
in further reports?

Greetings, Eric
