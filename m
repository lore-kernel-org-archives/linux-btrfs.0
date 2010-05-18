From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 09:13:04 -0400
Message-ID: <20100518131304.GX8635@think>
References: <4BF18525.8080904@gmail.com>
 <20100517193652.GC8635@think>
 <4BF1DBCD.7060208@gmail.com>
 <20100518003032.GK8635@think>
 <20100518005926.GM8635@think>
 <4BF28225.2000908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jakob Unterwurzacher <jakobunt@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF28225.2000908@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 02:03:49PM +0200, Jakob Unterwurzacher wrote:
> On 18/05/10 02:59, Chris Mason wrote:
> >>> Ok, I upgraded to 2.6.34 final and switched to defconfig.
> >>> I only did the rename test ( i.e. no overwrite ), the window is now
> >>> 1.1s, both with vanilla and with the patch.
> >>
> >> Thanks, so much for the easy fix.  I'll take a look.
> > 
> > Ohhhhh, I read your initial email wrong, I'm sorry.  The test we're
> > failing, the rentest, doesn't overwrite one file with another.  It is
> > just creating a file and then renaming it.
> 
> Yes, the overwrite test goes perfectly fine.
> 
> > Btrfs is explicitly choosing not to sync the file in this case because
> > the rename isn't replacing good old data with new unwritten data.  The
> > rename is taking new unwritten data and giving it a different name.
> > 
> > Are there applications that rely on this? 
> > 
> > -chris
> 
> Well, dpkg (the Debian/Ubuntu package manager) did. Then ext4 became the
> default fs in Ubuntu and massive breakage was reported [1]. Now dpkg is
> fsync()ing everything and is about 2x slower than it was with ext3 [2].
> 
> Btrfs is so close to getting it "right" that i wondered whether the new
> file name hitting the disk could be delayed that one second for the data
> to make it to disk first.
> 

The thing is that different apps have a different version of 'right'.  Rename
is atomically replacing one file with another, and I completely agree
that when we have an established file on disk, we shouldn't replace it
with something that is potentially garbage.

But for the zeros case we have a file that isn't on disk and we're just
giving it a new name.  I can see a different class of applications
getting upset about renames slowing the system down dramatically because
they suddenly imply a lot of IO.

I'm more than open to discussion on this one, but I don't see how:

rm -f foo2
dd if=/dev/zero of=foo bs=1M count=1000
mv foo foo2

Should be expected to write 1GB of data.

-chris
