From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: feature request: btrfs-image without zeroing data
Date: Mon, 11 Jul 2011 13:58:26 +0100
Message-ID: <chaz20110711125826.GA18391@seebyte.com>
References: <CAJ1PRSn6TBnzXaSQSEffb15oH4+jncKE5ydCipcT6HHt1U=GLw@mail.gmail.com> <20110711093156.GB2537@yahoo.fr> <CAJ1PRSnyU5G5_08UtGKvhTQUEOvK+KSYo7WQV06N5Qn8efPXgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSnyU5G5_08UtGKvhTQUEOvK+KSYo7WQV06N5Qn8efPXgw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-11 14:39:18 +0200, krzf83@gmail.com :
> 2011/7/11 Stephane Chazelas <stephane_chazelas@yahoo.fr>:
[...]
> > See also
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/9675/focus=9820
> > for a way to transfer btrfs fs.
> >
> > (Add a layer of "copy-on-write" on the original devices (LVM
> > snapshots, nbd/qemu-nbd cow...), "btrfs add" the new device(s)
> > and then "btrfs del" of the cow'ed original devices.
[...]
> Copying on block level (dd, lvm) is old trick, however this takes same
> ammount of time regardless of actual space used in filesystem. Hence
> this feature request. Images inside filesystem can copy only actualy
> used data and metadata, which dramaticly reduces copy times in large
> volumes that are not filled up...

The method I suggest doesn't copy the whole disks, please read
more carefully. It can also work to copy from a 3 disk setup to
a 1 disk setup or the other way round.

With btrfs, you can add devices to a FS dynamically, you can
also delete devices in which case data is being transfered to
the other devices. The method I suggest uses that feature.

Cheers,
Stephane
