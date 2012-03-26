From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Mon, 26 Mar 2012 11:00:58 -0400
Message-ID: <1332774058.22830.2.camel@ayu>
References: <87vclt99tg.fsf@falma.de> <20120324182104.GB14080@carfax.org.uk>
	 <20120326085134.GK2040@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Hugo Mills <hugo@carfax.org.uk>, Christoph Groth <cwg@falma.de>,
	linux-btrfs@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120326085134.GK2040@x2.net.home>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-03-26 at 10:51 +0200, Karel Zak wrote:
> On Sat, Mar 24, 2012 at 06:21:05PM +0000, Hugo Mills wrote:
> >    As Sadner says, you have to run "btrfs dev scan" before you try to
> > mount the FS. If you have root on btrfs, this will have to go in an
> > initrd; otherwise, it can go in your initscripts anywhere before the
> > non-root filesystem mounts.
> > 
> >    Basically, the kernel needs to know which devices hold which btrfs
> > filesystems (organised by UUID) before it tries to mount them. So,
> > there's an ioctl that is used for sending that data to the kernel, and
> > a userspace tool (btrfs dev scan) that enumerates all of the block
> > devices it can see, looks for a btrfs superblock on them, and tells
> > the kernel.
> 
>  Please, move all this logic to udev rules where we already scans all
>  devices. It's really bad to scan all device more than once. We spent
>  years to fix this problem for LVM, I don't think that btrfs has to
>  repeat the same mistakes.

Oh, this is already possible to do with udev rules, quite easily. In
fact, dracut ships with the appropriate udev rules, which it uses to
initialize btrfs filesystems in the initramfs:

http://git.kernel.org/?p=boot/dracut/dracut.git;a=blob;f=modules.d/90btrfs/80-btrfs.rules;hb=HEAD

which would be suitable with minor modifications for use in a system
udev installation as well.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

