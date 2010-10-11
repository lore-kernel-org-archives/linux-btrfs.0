From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system crash at mounting of btrfs
Date: Mon, 11 Oct 2010 19:55:25 -0400
Message-ID: <20101011235525.GK22691@think>
References: <loom.20101007T155351-932@post.gmane.org>
 <20101008171635.GS4804@think>
 <loom.20101009T073143-310@post.gmane.org>
 <loom.20101009T150327-437@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gerhard Kulzer <gerhard@kulzer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20101009T150327-437@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 09, 2010 at 01:08:40PM +0000, Gerhard Kulzer wrote:
> Gerhard Kulzer <gerhard <at> kulzer.net> writes:
> 
> > 
> > Chris Mason <chris.mason <at> oracle.com> writes:
> > 
> > > > [    7.881078] Btrfs detected SSD devices, enabling SSD mode
> > > > [    7.923553] ------------[ cut here ]------------
> > > > [    7.923556] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs
> > /tree-log.c:813!
> > > > [    7.923558] invalid opcode: 0000 [#1] SMP 
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > Once you see kernel BUG() that's the crash ;)
> > > 
> > > This isn't from the btrfs scan, this is from mounting the FS.  Could you
> > > please mount the filesystems one at a time and see if they all fail or
> > > of it is just this one.
> > > 
> > > -chris
> > > --
> > Ahh big surprise, I can mount my other btrfs partitions (4 on 2 HDD) all of a
> > sudden. 
> > I wonder why, because I tried before and I got a crash with all of them. 
> > The only difference now is that I took the SSD with the 5th partition out.
> > I have a boot partition as ext4 on that same SSD drive which I can mount
> > w/o problems. So I think it's not the SSD itself that is buggy.
> > 
> 
> Ok, I understand a bit more now.
> a) when I boot my system from CD and the faulty SSD btrfs is physically present,
> then there's a little hick-up during boot resulting in my first trace and the
> system crashes if I subsequently mount ANY other btrfs partition.
> b) If I boot w/o the SSD, then there is no hick-up and I can mount all remaining
> btrfs partitions w/o crash and the data is there.

Ok, so tell me more about the SSD with the btrfs-of-death.  Is it a
multi-device SSD?

-chris

