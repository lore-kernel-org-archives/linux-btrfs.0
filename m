From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 21 Jan 2012 11:49:53 +0100
Message-ID: <201201211149.53403.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201112202146.32265.Martin@lichtvoll.de> (sfid-20111220_235230_709484_89771306)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112202146.32265.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 20. Dezember 2011 schrieb Martin Steigerwald:
> Hi again!
[=E2=80=A6]
> Am Samstag, 17. Dezember 2011 schrieb Martin Steigerwald:
> > Hi!
> >=20
> > Finally I tried scrubbing the / BTRFS filesystem mentioned in the
> > thread "speeding up slow btrfs filesystem". However the machine loo=
ks
> > up hard then. It repeats the last few seconds of audio all over
> > again, no mouse and no ssh connection anymore:
> >=20
> > deepdance:~> btrfs scrub start /
> > scrub started on /, fsid [=E2=80=A6] (pid=3D5737)
> > deepdance:~> Write failed: Broken pipe
> >=20
> >=20
> > After the second attempt of doing this the machine stops on booting
> > after the space cache enabled message. Then I get backtraced of hun=
g
> > tasks:
> >=20
> > http://martin-steigerwald.de/tmp/btrfs/2011-17-12-deepdance-hang-at=
-b
> > oot/
> >=20
> >=20
> > I am able to mount the filesystem from grml 2011.12-rc1 with 3.1
> > kernel:

I still have this with 3.2.0-1-pae - which is a debian kernel based on=20
3.2.1.

When I do btrfs scrub start / the machine locks immediately up hard.

Then usually on next boot it stops on space_cache enabled message, but =
not=20
the one for /, but the one for /home which is mounted later.

When I then boot with 3.1 it works. BTRFS redos the space_cache then wh=
ile=20
the machine takes ages to boot - I mean ages - 10 minutes till KDM prom=
pt=20
is no problem there.

I thought I just mention it here.

Since I got no hints on what to do, I probably redo both filesystems on=
 the=20
machine. Should that not work out, I switch the box to Ext4.

btrfs filesystem scrub works on my ThinkPad T520 with 64-bit debian and=
=20
Intel SSD 320 and one 2,5 inch external drive as well as a 3,5 inch=20
external backup drive both via eSATA, so this seems to be no principal=20
issue. It also works on a workstation at work which has 32-bit debian a=
s=20
well.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
