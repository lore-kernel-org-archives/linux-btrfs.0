From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fwd: module/kernel crash while trying to delete missing device/balance
Date: Tue, 19 Apr 2011 12:05:43 -0400
Message-ID: <1303229129-sup-2091@think>
References: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com> <BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com> <1303214237-sup-2056@think> <BANLkTin9U-fzK0S39c2PiEsJ1N4s0fsL0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: brandon lansing <imraven@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTin9U-fzK0S39c2PiEsJ1N4s0fsL0A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from brandon lansing's message of 2011-04-19 11:42:26 -0400:
> On Tue, Apr 19, 2011 at 05:58, Chris Mason <chris.mason@oracle.com> w=
rote:
> > Excerpts from brandon lansing's message of 2011-04-18 23:13:06 -040=
0:
> >> Hello,
> >>
> >> Distro: Ubuntu 10.10
> >> Kernel:=C2=A0Linux 2.6.35-28-generic #50-Ubuntu SMP Fri Mar 18 18:=
42:20 UTC
> >> 2011 x86_64 GNU/Linux
> >> Btrfs tools version:=C2=A0Btrfs Btrfs v0.19
> >>
> >> I currently have 2 X 500GB hard drives in 'raid1' mode with about
> >> 400GB used. =C2=A0Recently one of the hard drives crashed (but I h=
ave a
> >> backup) but I'd like to help out if I can because I'm currently
> >> getting an error when trying to 'rebuild' the filesystem.
> >> I've mounted the array in degraded mode and added the new hard dri=
ve.
> >> Finally I issued the command to delete the missing device. =C2=A0T=
he dmesg
> >> looks normal for a while with messages such as:=C2=A0btrfs: reloca=
ting
> >> block group 466167529472 flags 17. =C2=A0However, after a few minu=
tes of
> >> running I get the following:
> >>
> >> [ 1770.041623] ------------[ cut here ]------------
> >> [ 1770.041655] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/v=
olumes.c:3037!
> >> [ 1770.041684] invalid opcode: 0000 [#1] SMP
> >> [ 1770.041707] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/u=
event
> >> [ 1770.041734] CPU 1
> >> [ 1770.041744] Modules linked in: btrfs sha256_generic cryptd
> >
> > Could you please attached the fs/btrfs/volumes.c from this distro
> > kernel? =C2=A0It'll help us figure out what is going wrong.
> >
> > -chris
> >
>=20
> Chris,
>=20
> Thanks for the prompt response, however, I think it may have had
> something to do with the version of btrfs I was running with the
> kernel 2.6.35-28-generic in Ubuntu.  I upgraded to Ubuntu 11.04
> (natty) and kernel 2.6.38-8-generic and this solved my problem.  I wa=
s
> able to rebuild all 374GB without error.

Great to hear, thanks for the update.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
