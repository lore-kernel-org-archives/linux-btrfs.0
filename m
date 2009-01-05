From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 08:18:58 -0500
Message-ID: <1231161538.4290.12.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1230924749.7538.35.camel@think.oraclecorp.com>
	 <20090102210104.GC496@one.firstfloor.org>
	 <200901052107.43341.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901052107.43341.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-05 at 21:07 +1100, Chris Samuel wrote:
> On Sat, 3 Jan 2009 8:01:04 am Andi Kleen wrote:
> 
> > When it's in mainline I suspect people will start using it for that.
> 
> Some people don't even wait for that. ;-)
> 
> Seriously though, if that is a concern can I suggest taking the btrfsdev route 
> and, if you want a real belt and braces approach, perhaps require it to have a 
> mandatory mount option specified to successfully mount, maybe "eat_my_data" ?

I think ext4dev made more sense for ext4 because people generally expect
ext* to be stable.  Btrfs doesn't quite have the reputation for
stability yet, so I don't feel we need a special -dev name for it.

But, if Andrew/Linus prefer that unstable filesystems are tagged with
-dev, I'm happy to do it.

-chris


