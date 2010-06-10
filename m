From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Copy-on-write hard-links
Date: Thu, 10 Jun 2010 16:00:24 -0400
Message-ID: <20100610200024.GB4366@think.oraclecorp.com>
References: <4C111CCC.8070103@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C111CCC.8070103@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 10, 2010 at 06:11:40PM +0100, Gordan Bobic wrote:
> Is there a feature in btrfs to manually/explicitly mark hard-links
> to be copy-on-write? My understanding is that this is what happens
> when a snapshot is mounted rw and files modified.
> 
> Consider this scenario:
> 
> I have a base template fs. I make two snapshots of it that are
> identical. The files in the template and both snapshots are
> hard-links and have the same inode number.
> 
> I change a file in one of the snapshots, and it gets copied on
> write. I make the same change in the other snapshot, and that, too,
> gets copied on write. I now have two identical files that are not
> hard-links any more.
> 
> What happens if I remove one of those files and create a hard-link
> to the file in the other snapshot?

I'm afraid you can't do this.  hard linking between subvolumes isn't
allowed.  But, what you can do is use the clone ioctl to make a new
inode that references all of the data extents of an existing file, which
would be a kind of COW hard link.

Checkout bcp from btrfs-progs or cp --reflink from the latest..well
wherever cp comes from.

-chris
