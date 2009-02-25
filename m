From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: questions about GRUB and BTRFS
Date: Wed, 25 Feb 2009 12:53:17 +1100
Message-ID: <3a7f57190902241753s6738fcdl1b7573dcbf23e151@mail.gmail.com>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2009 at 12:32 PM, Anthony Roberts
<btrfs-devel@arbitraryconstant.com> wrote:
> Hi,
>
> A quick googling turns up posts that GRUB support for BTRFS is planned. My
> curiosity is more towards how this will be managed, because the way this is
> currently implemented with software RAID/LVM is quite haphazard. I
> therefore have some questions about GRUB + BTRFS:

IANAGD (I Am Not A GRUB Developer), but I'll post some intuitive respones.

> -With GRUB booting, it's easy to think of awkward use cases and limitations
> unless it's capable of discovering BTRFS instances, and can boot by
> specifying BTRFS UUID + subvolume. That seems quite ambitious, but is this
> planned "eventually"?

I don't know how much filesystem code can be crammed into the
pre-/boot parts of GRUB, but I doubt it's enough to support btrfs'
advanced features like object-level striping.

For comparison with how the two major ZFS operating systems support root on ZFS:

*Solaris (Open, Nexenta, etc.) support booting from ZFS using GRUB,
but ONLY plain or mirrored, not striped or raid-z. Not sure about
linear, if the kernel is installed on anything but the first vdev.

FreeBSD unofficially supports / on ZFS very well, but you still need a
/boot to let the bootloader find the kernel and modules. However the
kernel itself can be given a ZFS pool and path such as
"zfs:pool/freebsd/root" and it will find all of the ZFS metadata it
needs on disk blocks and the small cache in /boot. However in return
for this /boot you get the ability to boot right off RAID-Z or
whatever you like, because it's using the kernel with full driver and
filesystem code instead of very limited bootloader code.

> -Might it be possible to tweak the userspace component of GRUB to install
> the bootloader to every member device? This seems necessary for reliable
> booting and rebuilding after a dead disk.

Even if you couldn't tweak grub, device-mapper already has an easy way
to mirror just the boot blocks per disk. However GRUB would get
confused since the virtual device does not map to a BIOS boot device.
Legacy BIOS booting is a pain that way. You may as well just write a
shell script to automatically invoke grub-install for each device
individually.

> -64 kb at the beginning of the device is plenty for MBR + GRUB stage 1 +
> 1.5. Might this allow bootable BTRFS without paritions being used at all?
> The space used for partitioning is negligible, however we're on the cusp of
> disks that are too big to partition with MBR, and GPT booting doesn't seem
> well supported yet.

As far as I know, we don't even have a way to boot straight off LVM
(because GRUB doesn't support it, and for a kernel and initrd you need
a supported partition), and btrfs would only be more difficult.

> There's obviously no point in getting worked up about this before
> production ready support is available in the first place. :) However, I am
> curious about what sort of implementation is planned.

Well before production ready support is there, people will already
want to test btrfs as their / (which should be automagic like for
FreeBSD ZFS) and /boot (because they're difficult that way). Long
before reiser4 was even proposed for mainline merge, it already had
GRUB support. Enthusiasts will always believe that even /boot should
be fortified with COW, checksums and snapshotting :)

Especially if btrfs is intended to be the "next default Linux
filesystem" as quoted in many places, it will need /boot support in
some form. I'll personally keep an ext3 /boot for a long time just
because recovery is easier that way.

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
