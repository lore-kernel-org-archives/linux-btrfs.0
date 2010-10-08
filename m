From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system crash at mounting of btrfs
Date: Fri, 8 Oct 2010 13:16:35 -0400
Message-ID: <20101008171635.GS4804@think>
References: <loom.20101007T155351-932@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gerhard Kulzer <gerhard@kulzer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20101007T155351-932@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 07, 2010 at 02:12:33PM +0000, Gerhard Kulzer wrote:
> I have a weird problem concerning 5 btrfs partitions on 3 different disks:
> My system became slow and started to hang and go, so I shut it down and it 
> hang totally whilst shutting down. With the sysrq shortcut I could kill it 
> and restart.
> 
> Booting didn't work any more throwing me into a shell at initramfs.

Ok, I'd like to go through each of these btrfs partitions one at a time.

> Here is a dmesg trace during booting from the CD, it not the crash yet.
> 
> [    7.782823] Btrfs loaded
> [    7.786081] xor: automatically using best checksumming function: pIII_sse
> [    7.804000]    pIII_sse  : 11626.000 MB/sec
> [    7.804001] xor: using function: pIII_sse (11626.000 MB/sec)
> [    7.805746] device-mapper: dm-raid45: initialized v0.2594b
> [    7.851186] device fsid 3a4b4bc6c07de70b-2b32b3df70d2459f devid 1 transid
> 407064 /dev/sda2
> [    7.881078] Btrfs detected SSD devices, enabling SSD mode
> [    7.923553] ------------[ cut here ]------------
> [    7.923556] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/tree-log.c:813!
> [    7.923558] invalid opcode: 0000 [#1] SMP 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you see kernel BUG() that's the crash ;)

This isn't from the btrfs scan, this is from mounting the FS.  Could you
please mount the filesystems one at a time and see if they all fail or
of it is just this one.

-chris
