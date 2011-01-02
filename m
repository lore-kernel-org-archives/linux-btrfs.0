From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Odd mkbtrfs behavior inside of chroot
Date: Sun, 2 Jan 2011 16:06:20 -0500
Message-ID: <7042580597121616144@unknownmsgid>
References: <915110.93115.qm@web112501.mail.gq1.yahoo.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: J G <yoosty_cmn@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <915110.93115.qm@web112501.mail.gq1.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Did you try using -o bind on /proc and /sys as well? Just in case mkfs
uses /sys too, I'm not sure if /proc reacts differently to multiple
mounts or bind neither?

Envoy=E9 de mon appareil mobile.

J=E9r=F4me Poulin
Solutions G.A.

On 2011-01-02, at 14:53, J G <yoosty_cmn@yahoo.com> wrote:

> I just encountered some odd behavior from mkbtrfs.
> The end goal is to restore a backup to newly created BTRFS partitions=
 while using the latest btrfs-tools.
> Here's the steps to what I did:
> * Booted SystemRescueCD
> * Partitioned the drives (two 750GB drives with 12 partitions each)
> * Created an extra partition on sda as a temporary holding place for =
the backed up files and so I can update btrfs-tools
> * Formatted/mounted/restored backup files to the temporary partition =
which I mounted on /mnt/backup
> * mount -t proc none /mnt/backup/proc; mount -o bind /dev /mnt/backup=
/dev
> * chroot /mnt/backup /bin/bash
> * Updated btrfs-tools to the latest git pull from today (v0.19-35-g1b=
444cd-dirty).
> * mkbtrfs /dev/sda5 /dev/sdb5 -L root
>
> mkbtrfs returned with:
>
> error checking /dev/sda5 mount status
>
> So I used strace to find out how it was checking for the mount status=
=2E Now, I'm no expert here, but I'm confused as to just why it failed.=
 The last thing of note:
>
> lstat("/boot", {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =3D 0
> lstat("/boot/sysrcd.dat", 0x7fffb29681e0) =3D -1 ENOENT (No such file=
 or directory)
> close(3)                                =3D 0
> munmap(0x7f11df372000, 4096)            =3D 0
> write(2, "error checking /dev/sda5 mount s"..., 38error checking /dev=
/sda5 mount status
> ) =3D 38
>
>
> doesn't explain much. I see that it's checking /proc/mounts to see wh=
at's mounted, and then it fails on stating /boot/sysrcd.dat (which does=
n't exist in the non-chrooted FS, btw).
>
> To make this even weirder, if I format sda5/sdb5 using the SysRescCD =
version of mkbtrfs (v0.19) and then format sda5/sdb5 using the chroot v=
ersion, it works fine.
>
> Any ideas here? I would expect that mkbtrfs would work inside of a ch=
root without any assistance from the original root.
>
> I have the full strace from the chrooted mkbtrfs failing and from it =
succeeding, if that's helpful.
>
>
> .:Justin:.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
