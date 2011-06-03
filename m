From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: linux-next: build warninga in Linus' tree
Date: Fri, 3 Jun 2011 14:25:34 +0200
Message-ID: <BANLkTim-0xj7Pr2EkZs2JEkyVw_7F9eM=g@mail.gmail.com>
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 30, 2011 at 3:36 AM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> Hi all,
>
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
>
> fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not u=
sed
> fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not =
used
> fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but n=
ot used
> fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but no=
t used
>
> I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
> difference.

I see the same warnings with Debian's gcc-4.6 (here: next-20110603),
plus some more:

fs/btrfs/ioctl.c: In function 'btrfs_ioctl_fs_info.isra.24':
fs/btrfs/ioctl.c:2080:1: warning: the frame size of 1032 bytes is
larger than 1024 bytes [-Wframe-larger-than=3D]

fs/btrfs/delayed-inode.c: In function 'btrfs_batch_insert_items':
fs/btrfs/delayed-inode.c:690:9: warning: 'nitems' may be used
uninitialized in this function [-Wuninitialized]

- Sedat -

> --
> Cheers,
> Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
