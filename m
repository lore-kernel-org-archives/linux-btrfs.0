From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fwd: module/kernel crash while trying to delete missing device/balance
Date: Tue, 19 Apr 2011 07:58:58 -0400
Message-ID: <1303214237-sup-2056@think>
References: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com> <BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: brandon lansing <imraven@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from brandon lansing's message of 2011-04-18 23:13:06 -0400:
> Hello,
>=20
> Distro: Ubuntu 10.10
> Kernel:=C2=A0Linux 2.6.35-28-generic #50-Ubuntu SMP Fri Mar 18 18:42:=
20 UTC
> 2011 x86_64 GNU/Linux
> Btrfs tools version:=C2=A0Btrfs Btrfs v0.19
>=20
> I currently have 2 X 500GB hard drives in 'raid1' mode with about
> 400GB used. =C2=A0Recently one of the hard drives crashed (but I have=
 a
> backup) but I'd like to help out if I can because I'm currently
> getting an error when trying to 'rebuild' the filesystem.
> I've mounted the array in degraded mode and added the new hard drive.
> Finally I issued the command to delete the missing device. =C2=A0The =
dmesg
> looks normal for a while with messages such as:=C2=A0btrfs: relocatin=
g
> block group 466167529472 flags 17. =C2=A0However, after a few minutes=
 of
> running I get the following:
>=20
> [ 1770.041623] ------------[ cut here ]------------
> [ 1770.041655] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/volu=
mes.c:3037!
> [ 1770.041684] invalid opcode: 0000 [#1] SMP
> [ 1770.041707] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/ueve=
nt
> [ 1770.041734] CPU 1
> [ 1770.041744] Modules linked in: btrfs sha256_generic cryptd

Could you please attached the fs/btrfs/volumes.c from this distro
kernel?  It'll help us figure out what is going wrong.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
