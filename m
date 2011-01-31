From: cwillu <cwillu@cwillu.com>
Subject: Re: BUG while writing to USB btrfs filesystem
Date: Sun, 30 Jan 2011 21:11:40 -0600
Message-ID: <AANLkTinFq=EfJDU6EUTGN6J9rP2aw849o+KvGV_C-L4G@mail.gmail.com>
References: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>
	<AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com>
	<AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>
	<4D46250D.2090403@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D46250D.2090403@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 30, 2011 at 8:57 PM, Chris Samuel <chris@csamuel.org> wrote=
:
> On 31/01/11 12:33, cwillu wrote:
>
>> [33159.490003] kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/ino=
de.c:1629!
>
> It looks like this happens when btrfs_drop_extents() returns
> an error, and in the code the only time that seems to happen
> without already calling BUG_ON() is if it runs out of memory
> at the very start:
>
> =A0 =A0 =A0 =A0path =3D btrfs_alloc_path();
> =A0 =A0 =A0 =A0if (!path)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> Is there anything in the log from before that oops ?
>
> NB: I just did a quick scan of btrfs_drop_extents() so it's
> possible I missed something..

There's a bunch of places it could be (any ret =3D foo followed by a
break will exit with that ret rather than oops).

Possibly relevant is that this generally occurs while building a
rootfs in a tmpfs chroot, which gets fairly sizeable (~2gb, on a
machine with 8gb ram).  The previous trace I posted occurred after the
tmpfs was tarred and unmounted, while the tarball was being written
out to a usb card reader, which seems like an odd time for an overly
huge tmpfs to cause trouble.

I've adjusted the job to not use the tmpfs for now, so the chroot is
on btrfs (combined with libeatmydata in order to continue to build
images in 40 minutes rather than 4 hours; dpkg).  We'll see if that
makes a difference.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
