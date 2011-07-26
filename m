From: cwillu <cwillu@cwillu.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1693!
Date: Tue, 26 Jul 2011 01:57:30 -0600
Message-ID: <CAE5mzvisUva+TdisJbJ7dfx2Ky1FUibAgCZ42GeNtHkBAjN-XA@mail.gmail.com>
References: <CAA_Wi2K7w9mwGS3LO-eEydZ3R6fSeQWOSoNz6dNMkO4w8DohsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Markus Suvanto <markus.suvanto@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAA_Wi2K7w9mwGS3LO-eEydZ3R6fSeQWOSoNz6dNMkO4w8DohsQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 26, 2011 at 1:51 AM, Markus Suvanto
<markus.suvanto@gmail.com> wrote:
> This is what I get =C2=A0if I use command:
> bcp file file_copy
> I can reproduce this every time when using bcp command.
>
> Filesystem is under lvm:
> /dev/mapper/vg_md1-btrfs on /mnt/btrfs type btrfs (rw,noatime,subvol=3D=
=2E)
>
> This filesystem is created using linux-3.0 and
> mkfs.btrfs, part of Btrfs v0.19-1-g4f89b6e-dirty
>
> Ok, I don't have any kernel debug stuff there but maybe you can
> reproduce this....
>
> -Markus

Appears to be an unhandled ENOSPC error; hard to tell much else
without the debug info and the details on the volume (size, mkfs args,
etc).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
