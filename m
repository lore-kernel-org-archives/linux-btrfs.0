From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: scrub to delete files
Date: Sat, 24 Mar 2012 14:10:42 +0100
Message-ID: <201203241410.42465.Martin@lichtvoll.de>
References: <jkka60$qin$2@dough.gmane.org> (sfid-20120324_121234_115107_789A4EC7)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Lubos Kolouch <lubos.kolouch@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jkka60$qin$2@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 24. M=C3=A4rz 2012 schrieb Lubos Kolouch:
> Hello,

Hi Lubos,

> I have a (rather historical btrfs) filesystem running here.
> When I run scrub, I get a lot of messages like :
> btrfs: checksum error at logical 2153033760768 on dev /dev/md2, secto=
r
> 492918400, root 5232, inode 3360637, offset 217088, length 4096, link=
s
> 1 (path: ....)
>=20
> and
>=20
> btrfs: unable to fixup (regular) error at logical 2154979917824
>=20
> Is there a way how to have scrub delete the broken files?
> What to do with the unable to fixup messages?

What kernel version are you using?

I thought that with newer kernel versions it would put the name of the =
file=20
which failed into kernel log as well. Then you could grep for those, aw=
k=20
them out of the log file and delete them then.

Since my filesystems all scrub well I have no example log message.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
