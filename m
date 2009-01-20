From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 20 Jan 2009 07:31:50 +0100
Message-ID: <20090120063150.GC5854@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090118174035.GG1944@ucw.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

* Pavel Machek (pavel@suse.cz) wrote:
> On Tue 2009-01-13 15:43:07, Eric Sesterhenn wrote:
> > * Chris Mason (chris.mason@oracle.com) wrote:
> > > On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > > > Hi,
> > > > 
> > > > when mounting an intentionally corrupted btrfs filesystem i get the
> > > > following warning and bug message. The image can be found here
> > > > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> > > 
> > > Thanks for looking at things
> > > 
> > > Aside from catching checksumming errors, we're not quite ready for
> > > fuzzer style attacks.  The code will be hardened for this but it isn't
> > > yet.
> > 
> > Does this mean i should stop trying to break it for now or are you interested
> > in further reports?
> 
> Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> production' and should survive it...

I regularly (once or twice a week) test 100 corrupted images of 
vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.

They are all pretty stable, one remaining thing on my list i didnt have
time to look into was an issue with fat (msdos) triggering a bug in
buffer.c the other is a warning with ext4 in jbd2/checkpoint.c:166

If there is a filesystem you are interested in thats not on the list
or that you want me to test a bit more, just let me know

Greetings, Eric
