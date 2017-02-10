Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35495 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932080AbdBJULW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 15:11:22 -0500
Received: by mail-yw0-f196.google.com with SMTP id l16so3327316ywb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 12:11:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 10 Feb 2017 13:03:30 -0700
Message-ID: <CAJCQCtQKj0yJS3SUb1fLJfg9rAvA-kebndk53mc=oTP3rxr0xg@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: John Hendy <jw.hendy@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is not a Btrfs problem yet. Syslinux isn't even getting the
kernel and initramfs loaded, otherwise you'd get a failure during
boot. But instead you're at the bootloader still.

One thing to realize is that syslinux only finds kernels and initramfs
on the local file system. So assuming this syslinux is on /dev/sda1:
UUID="37441f68... ext2 volume; then it can only load kernels and
initramfs from that file system. So I'm not sure what the purpose of
/dev/sdb1: UUID="e046823f ext4 is for, but if you use it for the boot
volume, you have to use extlinux install extlinux there *and* you have
to make sure the MBR has sdb1's active bit set *and* you have to make
sure the firmware boot manager is pointed to /dev/sdb.

But I don't think that's necessary, mainly you just need a really big
ext4 volume to hold all the distro kernels in one volume so that
syslinux has access to them. If you want separate boot volumes for
each distro then you have no choice but to use GRUB which can find and
load kernel/initramfs on any drive, any volume, with pretty much any
file system.

So the question is why won't that boot entry load the already working
kernel and initramfs? I don't have a good explanation for that. What
should happen if anything in APPEND is wrong, is you still get kernel
and initramfs loading, but then end up at a dracut shell. Or maybe it
crashes earlier due to some incompatibility by mixing kernel/initramfs
with the wrong rootfs (different kernel versions for example since all
the modules are version specific and those will be on Btrfs not on
boot).

I'd say you need some syslinux debug option set to find out what it's
tripping up on, because there's not enough information without that.
Maybe there's something in APPEND that it doesn't like, but I don't
think syslinux parses that line, it just adds it to the kernel boot
param line handed off to the kernel. But it's not even getting that
far.

The UUID e1284231- is the correct one to use for Btrfs.

I have not tried a double nested subvolume. I think you're better off
with directories at the top level for each distro, and then use
subvolumes in those directories for root and home. Note that the
Ubuntu and opensuse GUI installers will make this impossible, they
will not install to a user defined subvolume, they insist on creating
things at the top level. Fedora's installer will let you do this
except for rootfs, it requires that it be a new subvolume which you
can name but the UI won't let you stick it in a directory, or create
nested subvolumes. You could troubleshoot your existing APPEND by
using rootflags=subvolid= and specifying the ID of the arch/root
subvolume. But I'm suspicious whether that's a problem. You could try
removing the leading / because the path to the subvolume is really
subvol=arch/root. Hmmm.

That's all I'm thinking of at the moment.

Chris Murphy
