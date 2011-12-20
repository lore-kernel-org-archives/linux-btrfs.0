From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Tue, 20 Dec 2011 21:46:32 +0100
Message-ID: <201112202146.32265.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> (sfid-20111217_183419_764882_9192E97F)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171833.34720.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi again!

Any hints about this one?

Since scrubbing worked okay on other machines, I can also redo the BTRF=
S=20
filesystem on this machine. Maybe it really has gained a corruption. (S=
till=20
scrubbing should not lock up the kernel hard, but=E2=80=A6)

Thanks,
Martin

Am Samstag, 17. Dezember 2011 schrieb Martin Steigerwald:
> Hi!
>=20
> Finally I tried scrubbing the / BTRFS filesystem mentioned in the
> thread "speeding up slow btrfs filesystem". However the machine looks
> up hard then. It repeats the last few seconds of audio all over again=
,
> no mouse and no ssh connection anymore:
>=20
> deepdance:~> btrfs scrub start /
> scrub started on /, fsid [=E2=80=A6] (pid=3D5737)
> deepdance:~> Write failed: Broken pipe
>=20
>=20
> After the second attempt of doing this the machine stops on booting
> after the space cache enabled message. Then I get backtraced of hung
> tasks:
>=20
> http://martin-steigerwald.de/tmp/btrfs/2011-17-12-deepdance-hang-at-b=
oo
> t/
>=20
>=20
> I am able to mount the filesystem from grml 2011.12-rc1 with 3.1
> kernel:
>=20
> root@grml ~ # Start lvm2
> Setting up LVM Volume Groups  Reading all physical volumes.  This may
> take a while...
>   Found volume group "deepdance" using metadata type lvm2
>   3 logical volume(s) in volume group "deepdance" now active
> .
> root@grml ~ # mount /mnt/debian
> root@grml ~ # mount /mnt/home
> root@grml ~ # dmesg | tail
> [   55.479303] Installing knfsd (copyright (C) 1996 okir@monad.swb.de=
).
> [   64.352088] eth0: no IPv6 routers present
> [   75.744318] fuse init (API version 7.17)
> [   75.801245] ipmi message handler version 39.2
> [   90.213880] end_request: I/O error, dev fd0, sector 0
> [  229.117153] Btrfs loaded
> [  229.117962] device label debian devid 1 transid 201769
> /dev/mapper/deepdance-debian
> [  229.577244] btrfs: disk space caching is enabled
> [  245.375875] device label home devid 1 transid 72021
> /dev/mapper/deepdance-home
> [  245.433137] btrfs: disk space caching is enabled
> root@grml ~ # umount /mnt/{debian,home}
>=20
> root@grml ~ # cat /proc/version
> Linux version 3.1.0-2-grml-486 (Debian 3.1.0-2+grml.3) (ch@grml.org)
> (gcc version 4.6.2 (Debian 4.6.2-5) ) #1 Fri Dec 9 00:25:07 UTC 2011
>=20
>=20
> But after that 3.2-rc4 still doesn=C2=B4t boot.
>=20
> I am now trying to install a 3.1.0 debian kernel via chroot.
>=20
> Ok, after installing the 3.1.0 kernel it seems to work with 3.2.0-rc4
> as well again. Its again converting the old style inodes. Thus I thin=
k
> on a sudden crash there may be an issue with the inode cache in
> 3.2-rc4 that switching to 3.1.0, writing something, and then back to
> 3.2.0-rc4 works around.
>=20
> But then I had this after upgrading from 3.0 to 3.2-rc4 as well. I
> didn=C2=B4t report it here cause I thought it was a one-time issue.
>=20
> Hopefully you can make something out of the backtraces I tried to
> snapshot with my digicam.
>=20
> Should I be concerned about the state of the filesystem?
>=20
> I will not try scrubbing it again for now ;)
>=20
> BTW the performance of the BTRFS fs while updating the inode cache is
> abysmal. The machine is trying to boot for about 5 minutes now and
> still no KDM to see. Hmm, at least there is an SSH now. No nothing
> about these hard lock ups in syslog as I have suspected.
>=20
> Thanks,


--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
