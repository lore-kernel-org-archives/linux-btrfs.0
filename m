From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: feature request: btrfs-image without zeroing data
Date: Mon, 11 Jul 2011 10:31:56 +0100
Message-ID: <20110711093156.GB2537@yahoo.fr>
References: <CAJ1PRSn6TBnzXaSQSEffb15oH4+jncKE5ydCipcT6HHt1U=GLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSn6TBnzXaSQSEffb15oH4+jncKE5ydCipcT6HHt1U=GLw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-11 02:00:51 +0200, krzf83@gmail.com :
> Documentation says that btrfs-image zeros data. Feature request is for
> disabling this. btrfs-image could be used to copy filesystem to
> another drive (for example with snapshots, when copying it file by
> file would take much longer time or acctualy was not possible
> (snapshots)). btrfs-image in turn could be used to actualy shrink loop
> devices/sparse file containing btrfs - by copying filesystem to new
> loop device/sparse file.
> 
> Also it would be nice if copying filesystem could occour without
> intermediate dump to a file...
[...]

I second that.

See also
http://thread.gmane.org/gmane.comp.file-systems.btrfs/9675/focus=9820
for a way to transfer btrfs fs.

(Add a layer of "copy-on-write" on the original devices (LVM
snapshots, nbd/qemu-nbd cow...), "btrfs add" the new device(s)
and then "btrfs del" of the cow'ed original devices.

-- 
Stephane
