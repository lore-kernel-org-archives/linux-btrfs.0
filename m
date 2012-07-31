Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60900 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2GaAuK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 20:50:10 -0400
Received: by pbbrp8 with SMTP id rp8so10714910pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 17:50:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
References: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
Date: Tue, 31 Jul 2012 02:50:10 +0200
Message-ID: <CA+=FuiWE4QVFrbTY_dQyABABJyvD=xtpEFKe4Ob9pqeZQ9NysA@mail.gmail.com>
Subject: Re: subvolumes: default and IDs
From: Alexander Karbstein <alexander.karbstein@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

I believe Florian came across some odd behaviour of btrfs subvolume
set-default which might still not be perfect in the current btrfs-progs: It
does not seem to change the default subvolume to the original root fs tree
if he does "btrfs subvolume set-default 0 /path/to/fs".

I am referring to this mail of Chris Mason where he said "btrfs subvolume
set-default 0 /path" should set the default subvolume to the original root
tree:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04567.html
either this was not implemented, yet, or I just didn't find it.

So to answer Florians third question, and to provide a patch for discussion:
3. Why does btrfs subvolume set-default 0 /path/to/fs seemingly not change
the default subvol?
It goes like this:
3.1 Btrfs-progs:
btrfs subvolume set-default 0 /path/to/fs lands in:
do_set_default_subvol
and
ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
then sends the subvolid=0 to the kernel ioctl.

3.2 Kernel fs/btrfs:
ioctl.c reveals the function to look at:
long btrfs_ioctl(struct file *file, unsigned int
                cmd, unsigned long arg)
...
        case BTRFS_IOC_DEFAULT_SUBVOL:
                return btrfs_ioctl_default_subvol(file, argp);
...
=> static long btrfs_ioctl_default_subvol(struct file *file, void __user
*argp)
Here we got this:
        u64 objectid = 0;
...

       /* argp is the the pointer to the "0" supplied from btrfs subvolume
set-default 0 ... */
       if (copy_from_user(&objectid, argp, sizeof(objectid)))
                return -EFAULT;

    /* as objectid now is 0, we use the current mounted subvolumes (FS
tree) objectid */
        if (!objectid)
                objectid = root->root_key.objectid;

==> So, btrfs subvolume set-default 0 /path/to/fs does in fact change the
default subvolume, if the currently mounted subvolume is not the current
default-subvolume. In Florian's example the subvolume seemingly did't
change because he alway had the current default-subvolume mounted.

IMHO, when following the principle of least surprise calling "btrfs
subvolume set-default 0 /path/to/fs" should always change the default
subvolume to be the "root" subvolume. This would actually establish the
same behaviour as the automatic translation from 0ULL to 5ULL in mount -o
subvolid=0.

This can be done either in the kernel code(fs/btrfs/ioctl.c), by just
exchanging:
        if (!objectid)
-                objectid = root->root_key.objectid;
+                objectid = BTRFS_FS_TREE_OBJECTID;

Or in btrfs-tools, which I would prefer. I am gonna send a patch against
the integration branch of btrfs-progs for discussion shortly.

Best Regards,
Alex

2012/7/30 Florian Lindner <mailinglists@xgm.de>
>
> Hey!
>
> I recently starting playing with btrfs and subvolume, but it has left
> me puzzled:
> Distribution is Archlinux, Kernel is 3.4.6.
>
> >>>
> root@horus /mnt # mkfs.btrfs -L test /dev/sdb1
>
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> fs created label test on /dev/sdb1
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
> Btrfs Btrfs v0.19
> root@horus /mnt # mount /dev/sdb1 test
> root@horus /mnt # cd test
> root@horus /mnt/test # btrfs subvolume create sv1
> Create subvolume './sv1'
> root@horus /mnt/test # btrfs subvolume create sv2
> Create subvolume './sv2'
> root@horus /mnt/test # touch sv1/sv1.file
> root@horus /mnt/test # touch sv2/sv2.file
> root@horus /mnt/test # btrfs subvolume get-default .
> ID 256 top level 5 path sv1
> ID 259 top level 5 path sv2
> <<<
>
> What is the default subvolume now? How can I tell?
>
> >>>
> root@horus /mnt/test # btrfs subvolume set-default 259 .
> root@horus /mnt/test # btrfs subvolume get-default .
> ID 256 top level 5 path sv1
> ID 259 top level 5 path sv2
> <<<
>
> Seems to have changed nothing....?
>
> >>>
> root@horus /mnt/test # cd ..
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv2.file
> <<<
>
> Ah, sv2 seems to be default, like I had set it.
>
> >>>
> root@horus /mnt # btrfs subvolume set-default 5 test
> root@horus /mnt # umount test && /mnt # mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Ok, 5 seems to be the root subvolume id. Is it always like that? I
> remembered to have read somewhere it was 0 ? (which makes a kind of
> more sense for me)
>
> >>>
> root@horus /mnt # btrfs subvolume set-default 256 test
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1.file
> <<<
>
> Fine! But:
>
> >>>
> root@horus /mnt # btrfs subvolume set-default 0 test
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1.file
> <<<
>
> set-default 0 seems to do nothing but does not produce an error
> either. What about subvolume 0? Still I can do:
>
> >>>
> root@horus /mnt # umount test
> root@horus /mnt # mount -o subvolid=0 /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Ok, here 0 as subvolid works. What about subvolid=5?
>
> >>>
> root@horus /mnt # umount test
> root@horus /mnt # mount -o subvolid=5 /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Works too.
>
> Sorry for the lengthy posting, but writing this posting has puzzled me
> even more I was yesterday. I hope someone could shed some light on it.
>
> Thanks!
>
> Florian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
