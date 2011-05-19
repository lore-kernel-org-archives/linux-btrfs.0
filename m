From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: ssd option for USB flash drive?
Date: Thu, 19 May 2011 22:47:21 +0100
Message-ID: <20110519214721.GA4209@yahoo.fr>
References: <20110517220252.GA12323@yahoo.fr>
 <201105192104.58726.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105192104.58726.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-19 21:04:54 +0200, Hubert Kario:
> On Wednesday 18 of May 2011 00:02:52 Stephane Chazelas wrote:
> > Hiya,
> > 
> > I've not found much detail on what the "ssd" btrfs mount option
> > did. Would it make sense to enable it to a fs on a USB flash
> > drive?
> 
> yes, enabling discard is pointless though (no USB storage supports it AFAIK).
>  
> > I'm using btrfs (over LVM) on a Live Linux USB stick to benefit
> > from btrfs's compression and am trying to improve the
> > performance.
> 
> ssd mode won't improve performance by much (if any).
> 
> You need to remember that USB2.0 is limited to about 20-30MiB/s (depending on 
> CPU) so it will be slow no matter what you do

Thanks Hubert for the feedback.

Well, for hard drives over USB, I can get to 40MiB/s read and
write easily. Here, I believe the bottle neck is the flash
memory. With that particular USB flash drive Corsair Voyager GT
16GB, I can get 25MiB/s sequential read and 17MiB/s sequential
write, but that falls down to about 3-5MiB/s random write.

[...]
> aligning logical blocks to erase blocks can give some performance but the only 
> way to make it really fast is not to use USB
[...]

For something that fits in your pocket and is almost
universally bootable, there are not so many other options.

I tried changing the alignment on FAT32 and it didn't make
any difference. Playing with /proc/sys/vm/block_dump, I could see
chunks of 3, 4, 5 data sectors being written at once regardless
of the cluster size being used anyway. Interestingly when a user
process writes to /dev/sdx, block_dump shows 4k writes to
/dev/sdx only regardless of the size of the user writes while if
it goes via the filesystem I can see writes of up to 120k. Also,
I've very little knowledge of what happens at layers below the
block device (scsi interface, usb-storage, and the device
controller itself, for instance, I see
/sys/block/sdi/queue/rotational is 1 for that usb stick, why,
what does that mean in terms of performance and scheduling of
read-writes?)

I wonder now what credit to give to recommendations like in
http://www.patriotmemory.com/forums/showthread.php?3696-HOWTO-Increase-write-speed-by-aligning-FAT32
http://linux-howto-guide.blogspot.com/2009/10/increase-usb-flash-drive-write-speed.html

Doing a apt-get upgrade on that stick takes hours when the same
takes a few minutes on an internal drive.

If I boot a kvm virtual machine on that USB stick with a disk
cache mode of "unsafe", that is writes are hardly every flushed
to underlying storage, then that becomes lightning fast (at the
expense of possibly losing data in case of host failure, but I'm
not too worried about that), and flushing writes to device
upon VM shutdown only takes a couple of minutes.

So I figured that if I could make sure writing to the flash
device is asynchronous (and reads priviledged), that would help.

There's probably some solutions with aufs or some fuse
solutions, but I thought there might be some solution in btrfs
or some standard core layers usually underneath it.

-- 
Stephane
