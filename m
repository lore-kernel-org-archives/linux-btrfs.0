Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35058 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdBJXef (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 18:34:35 -0500
Received: by mail-io0-f178.google.com with SMTP id j18so61964766ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 15:34:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQKj0yJS3SUb1fLJfg9rAvA-kebndk53mc=oTP3rxr0xg@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <CAJCQCtQKj0yJS3SUb1fLJfg9rAvA-kebndk53mc=oTP3rxr0xg@mail.gmail.com>
From: John Hendy <jw.hendy@gmail.com>
Date: Fri, 10 Feb 2017 17:34:34 -0600
Message-ID: <CA+M2ft9Aoj8S=i3N1G78BDm=4VOXkqM_dph1kXoyw2x9-thiig@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 2:03 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is not a Btrfs problem yet. Syslinux isn't even getting the
> kernel and initramfs loaded, otherwise you'd get a failure during
> boot. But instead you're at the bootloader still.
>
> One thing to realize is that syslinux only finds kernels and initramfs
> on the local file system. So assuming this syslinux is on /dev/sda1:
> UUID="37441f68... ext2 volume; then it can only load kernels and
> initramfs from that file system. So I'm not sure what the purpose of
> /dev/sdb1: UUID="e046823f ext4 is for, but if you use it for the boot
> volume, you have to use extlinux install extlinux there *and* you have
> to make sure the MBR has sdb1's active bit set *and* you have to make
> sure the firmware boot manager is pointed to /dev/sdb.

For sure. The whole install is on /dev/sdb
- sdb1 is ext4 /boot partition
- sdb1 was mounted to /path/to/boot when I installed Arch
- I did extlinux --install on sdb1
- boot flag set on sdb1
- syslinux mbr dd'd to /dev/sdb

I think that part is ok.

>
> But I don't think that's necessary, mainly you just need a really big
> ext4 volume to hold all the distro kernels in one volume so that
> syslinux has access to them. If you want separate boot volumes for
> each distro then you have no choice but to use GRUB which can find and
> load kernel/initramfs on any drive, any volume, with pretty much any
> file system.

This is encouraging as I was particularly hoping to *avoid* separate
boot partitions.

>
> So the question is why won't that boot entry load the already working
> kernel and initramfs? I don't have a good explanation for that. What
> should happen if anything in APPEND is wrong, is you still get kernel
> and initramfs loading, but then end up at a dracut shell. Or maybe it
> crashes earlier due to some incompatibility by mixing kernel/initramfs
> with the wrong rootfs (different kernel versions for example since all
> the modules are version specific and those will be on Btrfs not on
> boot).
>

I did a couple of things after I sent this. For one, I ditched
arch/root. Now I just have arch. That let me get away from the call to
a nested subvol.

That on it's own didn't work, but I started playing with the
rootflags. I haven't tried one by one, but re-specifying my mount
options seems to work. So instead of just rootflags=subvol=arch, I
have:

rootflags=compress=lzo,subvol=arch,ssd,discard

Is there a reason that would make a difference? I started wondering
about the compression immediately and I admit I'm not savvy on how
that works. When I installed things were mounted with compress=lzo.
Would this mean syslinux was maybe trying to mount it uncompressed and
thus files are jumbled (like trying to run cat on a .zip)? Just wild
imagining here.

Short story is I can now boot! I just want to figure out what happened
and update the Arch wiki as I haven't seen much definitive material on
this.

> I'd say you need some syslinux debug option set to find out what it's
> tripping up on, because there's not enough information without that.
> Maybe there's something in APPEND that it doesn't like, but I don't
> think syslinux parses that line, it just adds it to the kernel boot
> param line handed off to the kernel. But it's not even getting that
> far.
>
> The UUID e1284231- is the correct one to use for Btrfs.
>
> I have not tried a double nested subvolume. I think you're better off
> with directories at the top level for each distro, and then use
> subvolumes in those directories for root and home. Note that the
> Ubuntu and opensuse GUI installers will make this impossible, they
> will not install to a user defined subvolume, they insist on creating
> things at the top level. Fedora's installer will let you do this
> except for rootfs, it requires that it be a new subvolume which you
> can name but the UI won't let you stick it in a directory, or create
> nested subvolumes. You could troubleshoot your existing APPEND by
> using rootflags=subvolid= and specifying the ID of the arch/root
> subvolume. But I'm suspicious whether that's a problem. You could try
> removing the leading / because the path to the subvolume is really
> subvol=arch/root. Hmmm.

As a separate question, I noticed that if I did:

mount -o subvol=arch/root /mnt/btr  ## note no leading slash

and then looked at `genfstab -p -U /mnt/btr`, I got both of these in
the options:

subvol=arch/root, subvol=/arch/root

So that tripped me up big time. In blogs/forums I don't tend to see
folks specifying a leading slash, but the system seemed to use it?


Thanks for the assistance!
John


>
> That's all I'm thinking of at the moment.
>
> Chris Murphy
