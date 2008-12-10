From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 21:42:16 +0000
Message-ID: <1228945336.7571.26.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
	 <1228943437.7571.1.camel@mattos-laptop>
	 <20081210211903.GA29002@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <btrfs-devel@arbitraryconstant.com>,
	Chris Mason <chris.mason@oracle.com>,
	<linux-btrfs@vger.kernel.org>
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081210211903.GA29002@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>

I see quite a few uses for this, and while it looks like the kernel mode
automatic de-dup-on-write code might be performance costly, require disk
format changes, and be controversial, it sounds like the user mode
utility could be implemented today.

It looks like a simple script could do the job - just iterate through
every file in the filesystem, run md5sum on every block of every file,
whenever a duplicate is found call an ioctl to remove the duplicate
data.  By md5summing each block it can also effectively compress disk
images.

While not very efficient it should work, and having something like this
in the toolkit would mean as soon as btrfs gets stable enough for
everyday use it would immediately out-do every other linux filesystem in
terms of space efficiency for some workloads.

In the long term kernel mode de-duplication would probably be good.  I'm
willing to bet even the average user has say 1-2% of data duplicated
somewhere on the HD due to accidental copies instead of moves, same
application installed to two different paths, two users who happen to
have the same file each saved in their home folder, etc, so even the
average user will slightly benefit.

I'm considering writing that script to test on my ext3 disk just to see
how much duplicate wasted data I really have.

Thanks
Oliver


