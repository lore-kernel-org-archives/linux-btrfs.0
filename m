From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: scrub to delete files
Date: Sat, 24 Mar 2012 13:22:43 +0000 (UTC)
Message-ID: <jkkhr3$26m$1@dough.gmane.org>
References: <jkka60$qin$2@dough.gmane.org>
	<201203241410.42465.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald, Sat, 24 Mar 2012 14:10:42 +0100:

> Am Samstag, 24. M=C3=A4rz 2012 schrieb Lubos Kolouch:
>> Hello,
>=20
> Hi Lubos,
>=20
>> I have a (rather historical btrfs) filesystem running here.
>> When I run scrub, I get a lot of messages like :
>> btrfs: checksum error at logical 2153033760768 on dev /dev/md2, sect=
or
>> 492918400, root 5232, inode 3360637, offset 217088, length 4096, lin=
ks
>> 1 (path: ....)
>>=20
>> and
>>=20
>> btrfs: unable to fixup (regular) error at logical 2154979917824
>>=20
>> Is there a way how to have scrub delete the broken files?
>> What to do with the unable to fixup messages?
>=20
> What kernel version are you using?
>=20
> I thought that with newer kernel versions it would put the name of th=
e
> file which failed into kernel log as well. Then you could grep for
> those, awk them out of the log file and delete them then.
>=20
> Since my filesystems all scrub well I have no example log message.
>=20
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de GPG: 03B0 0D6C
> 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Hallo Martin,

Thank you for reply...

I'm using 3.3.0 - yes, it is in the log file so I will do that. Just=20
though if scrub does not have a (non-documented) option to do it.

Thanks

Lubos

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
