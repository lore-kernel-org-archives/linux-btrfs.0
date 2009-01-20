From: Pavel Machek <pavel@suse.cz>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 20 Jan 2009 10:34:55 +0100
Message-ID: <20090120092522.GC2576@elf.ucw.cz>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090120063150.GC5854@alice>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

> > > > Thanks for looking at things
> > > > 
> > > > Aside from catching checksumming errors, we're not quite ready for
> > > > fuzzer style attacks.  The code will be hardened for this but it isn't
> > > > yet.
> > > 
> > > Does this mean i should stop trying to break it for now or are you interested
> > > in further reports?
> > 
> > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > production' and should survive it...
> 
> I regularly (once or twice a week) test 100 corrupted images of 
> vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> 
> They are all pretty stable, one remaining thing on my list i didnt have
> time to look into was an issue with fat (msdos) triggering a bug in
> buffer.c the other is a warning with ext4 in jbd2/checkpoint.c:166

Good, I did not expect filesystems to be in so good state. Thanks!
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
