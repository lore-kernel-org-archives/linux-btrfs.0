From: C Anthony Risinger <anthony@extof.me>
Subject: Re: quick question...
Date: Sun, 8 Aug 2010 21:13:32 -0500
Message-ID: <AANLkTinc_9RoGnt9OPrVLBGuGfEvQrTiM1s2ui3tZDp1@mail.gmail.com>
References: <AANLkTimTTr0pFw5Y_O7nNUjH4z1UCRUsfYpe+NYtc7wZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Evert Vorster <evorster@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimTTr0pFw5Y_O7nNUjH4z1UCRUsfYpe+NYtc7wZ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

i'm not an expert, but ill do my best to answer.  replies interspersed below.

On Sun, Aug 8, 2010 at 8:57 PM, Evert Vorster <evorster@gmail.com> wrote:
> Hi there.
>
> Has anybody got a btrfs root filesystem that is running on a bare
> block device? Would lilo be able to boot an initramfs that is living
> on such a filesystem?

i haven't [ever] used lilo, but AFIAK no bootloader, with the
exception of maybe syslinux (extlinux), can boot from a btrfs device;
you won't have to worry about the initramfs, because the loader won't
even be able to find the kernel.  you'll need a boot partition with a
filesystem supported by the loader.

> What I intend to do is to erase all the partitions off my system, make
> a btrfs volume on /dev/sda, and then just use subvolumes in stead of
> partitions.
>
> Is this folly?

not at all.  this is what many of us would like to do, but we run into
the bootloader issues above.

> Would having an initramfs be a boon or a bane in this endeavour?

a non-issue, as the bootloader cannot even get the kernel (unless your
booting the kernel/initramfs from a different device...)

> Would lilo writing to the mbr of a device that is claimed by btrfs
> break the file system?

i don't think so, but i'm not sure.

> Do you need to have a partition table to have an MBR?

i just read about this recently.  IIRC, the partition table is within
the 512 byte MBR; it's a 64 byte section starting at byte 446.  so...
no :-)

C Anthony
