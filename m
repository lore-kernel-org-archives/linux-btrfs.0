From: Pavel Machek <pavel@suse.cz>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Sun, 18 Jan 2009 18:40:35 +0100
Message-ID: <20090118174035.GG1944@ucw.cz>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758066AbZASTNv@vger.kernel.org>
In-Reply-To: <20090113144307.GF16333@alice>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2009-01-13 15:43:07, Eric Sesterhenn wrote:
> * Chris Mason (chris.mason@oracle.com) wrote:
> > On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > > Hi,
> > > 
> > > when mounting an intentionally corrupted btrfs filesystem i get the
> > > following warning and bug message. The image can be found here
> > > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> > 
> > Thanks for looking at things
> > 
> > Aside from catching checksumming errors, we're not quite ready for
> > fuzzer style attacks.  The code will be hardened for this but it isn't
> > yet.
> 
> Does this mean i should stop trying to break it for now or are you interested
> in further reports?

Does ext2/3 and vfat survive that kind of attacks? Those are 'in
production' and should survive it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
