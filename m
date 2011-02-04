From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: mkfs.btrfs doesn't work inside loopback mounted chroot jails:
 error checking /dev/sda3 mount status
Date: Fri, 4 Feb 2011 10:51:52 +0100
Message-ID: <20110204105152.0000151d@unknown>
References: <2b8c-4d4bc900-1-18251900@152037387>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: "Bernhard Rosenkraenzer" <bero@arklinux.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2b8c-4d4bc900-1-18251900@152037387>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

you should search the mailinglist before you write patches :)

That problem is known and a patch is available:

https://patchwork.kernel.org/patch/449001/


But it isn't in the btrfs-progs git yet.


Regards,
Felix

Am Fri, 04 Feb 2011 10:38:25 +0100
schrieb "Bernhard Rosenkraenzer" <bero@arklinux.ch>:

> Hi,
> mkfs.btrfs aborts unconditionally with "error checking [whatever]
> mount status" under some circumstances.
> 
> I'm running into it when using a live CD that boots from a minimal CD
> image, then does
> 
> mount -o loop -t squashfs /squashfs.img /mnt/realsystem
> chroot /mnt/realsystem
> [stuff you actually want to do here]
> 
> strace shows mkfs.btrfs aborting after trying to
> 
> lstat("/squashfs.img", 0x7fff2c712c90) = -1 ENOENT (No such file or
> directory)
> 
> [obviously, it can't access /squashfs.img after chroot]
> 
> 
> I'm attaching a "fix" that allows circumventing the problem with a
> --force switch, patch is relative to "next" branch in git. I'm also
> adding this patch to the Ark Linux package of btrfs-progs unless
> someone screams very loudly. ;)
> 
> ttyl
> bero
