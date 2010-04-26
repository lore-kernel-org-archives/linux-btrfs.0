From: sniper <s3c24xx@gmail.com>
Subject: Re: list subvolumes with new btrfs command
Date: Mon, 26 Apr 2010 10:09:15 +0800
Message-ID: <q2j9bd6b5361004251909j8dcf6ccbzd978d627e137fadb@mail.gmail.com>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/4/26 C Anthony Risinger <anthony@extof.me>:
> hello,
>
> i maintain an unofficial initrd hook in Arch Linux that allows BTRFS
> to be used as the root device. =C2=A0i am trying to update the hook t=
o use
> the more extensive "btrfs" command, adding support for users to chang=
e
> their default subvolume from within the initrd (i'm creating a sort o=
f
> rollback feature, in conjunction with automatic snapshotting via the
> package manager), and adding support for hot spares (via a second
> BTRFS pool in which devices are "stolen" to repair the primary array)=
=2E
>
> anyways, i'm having trouble getting a listing of subvolumes:
>
> $ btrfs subvolume list /
> ERROR: can't perform the search
>
> the machine has a BTRFS root. =C2=A0i have also tried creating a snap=
shot
> and pointing the command at that, but i get the same results. =C2=A0a=
m i
> using the command wrong? =C2=A0relevant code is from btrfs-list.c:
>
> ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> if (ret < 0) {
> =C2=A0fprintf(stderr, "ERROR: can't perform the search\n");
> =C2=A0return 0;
> }
>
need super root? in my ubuntu10.04 with latest btrfs-progs:

$ ./btrfs subvolume list /media/sda3-100g/
ERROR: can't perform the search
$ sudo ./btrfs subvolume list /media/sda3-100g/
ID 258 top level 5 path misc/snap/snap-4-26

> kernel:
>
> $ uname -r
> 2.6.33-ARCH
>
> is there a new CONFIG_* kernel parameter that needs to be set since
> 2.6.32? =C2=A0everything seems to be in order and working fine... any=
 help
> appreciated.
>
> thanks,
> C Anthony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
