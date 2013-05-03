Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62498 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851Ab3ECUp2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 16:45:28 -0400
Received: by mail-wi0-f178.google.com with SMTP id hm14so998316wib.17
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 13:45:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <km17fq$4k0$1@ger.gmane.org>
References: <km17fq$4k0$1@ger.gmane.org>
From: Harald Glatt <mail@hachre.de>
Date: Fri, 3 May 2013 22:45:06 +0200
Message-ID: <CAFWF=a=nDcJiOTHwv83gXf3sA8rh0xHpxtd2V2W01=-Y17Vorw@mail.gmail.com>
Subject: Re: grub/grub2 boot into btrfs raid root and with no initrd
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 3, 2013 at 10:42 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> I've made a few attempts to boot into a root filesystem created using:
>
> mkfs.btrfs -d raid1 -m raid1 -L btrfs_root_3 /dev/sda3 /dev/sdb3
>
> Both grub and grub2 pick up a kernel image fine from an ext4 /boot on
> /dev/sda1 for exaample, but then fail to find or assemble the btrfs root.
>
> Setting up an initrd and grub operates fine for the btrfs raid.
>
>
> What is the special magic to do this without the need for an initrd?
>
> Is the comment/patch below from last year languishing unknown? Or is
> there some problem with that kernel approach?
>
>
> Thanks,
> Martin
>
>
> See:
>
> http://forums.gentoo.org/viewtopic-t-923554-start-0.html
>
>
> Below is my patch, which is working fine for me with 3.8.2.
> Code:
>
> $ cat /etc/portage/patches/sys-kernel/gentoo-sources/earlydevtmpfs.patch
> --- init/do_mounts.c.orig   2013-03-24 20:49:53.446971127 +0100
> +++ init/do_mounts.c   2013-03-24 20:51:46.408237541 +0100
> @@ -529,6 +529,7 @@
>     create_dev("/dev/root", ROOT_DEV);
>     if (saved_root_name[0]) {
>        create_dev(saved_root_name, ROOT_DEV);
> +      devtmpfs_mount("dev");
>        mount_block_root(saved_root_name, root_mountflags);
>     } else {
>        create_dev("/dev/root", ROOT_DEV);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The initrd has to run btrfs-scan so that btrfs can find the other
devices that have btrfs on them. Alternatively you can give all
involved devices in the fstab and kernel command line with
device=/dev/name
