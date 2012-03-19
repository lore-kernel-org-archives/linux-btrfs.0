From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: "scrub" stops the machine
Date: Mon, 19 Mar 2012 09:22:58 +0100
Message-ID: <201203190922.58586.Martin@lichtvoll.de>
References: <C52rKdGT1uB@helmut.hullen.de> (sfid-20120317_203424_664783_F75EACFD)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org, helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52rKdGT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. M=E4rz 2012 schrieb Helmut Hullen:
> Du meintest am 17.03.12:
> >>>>          btrfs scrub start /mnt/btr
> >>>>=20
> >>>> and all was dead. Really dead. No access via keybord, no access
> >>>> via SSH.
>=20
> Kernel 3.2.9
>=20
> [...]
>=20
> > Please review the thread I started with subject:
> >=20
> > 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
>=20
> Your system has run for some seconds and has sent messages. My syste
> seems to die immediately after receiving "scrub start".

Initially mine did as well as I wrote in the initial posting.

Then possibly after some kernel upgrade, I did a btrfs filesystem balan=
ce=20
on it and then the scrub didn=B4t die immediately, but got stuck. Did y=
ou=20
try whether a balance works?

Maybe 3.2.10 oder 3.2.11 contains some related fixes? But then I don=B4=
t=20
think that the Debian Wheezy kernel already has 3.2.10 or 3.2.11.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
