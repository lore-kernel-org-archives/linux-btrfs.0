From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: "scrub" stops the machine
Date: Mon, 19 Mar 2012 18:10:19 +0100
Message-ID: <201203191810.19697.Martin@lichtvoll.de>
References: <C52rKdGT1uB@helmut.hullen.de> <201203190922.58586.Martin@lichtvoll.de> <201203192201.04671.chris@csamuel.org> (sfid-20120319_134324_451485_AED6CE07)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203192201.04671.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 19. M=C3=A4rz 2012 schrieb Chris Samuel:
> On Monday 19 March 2012 19:22:58 Martin Steigerwald wrote:
> > Maybe 3.2.10 oder 3.2.11 contains some related fixes?
>=20
> I don't believe that any btrfs fixes get pushed to the stable release=
s
> (at least, not yet), you'll need 3.3 for newer code.

Well maybe the second btrfs filesystem balance call or a possible upgra=
de=20
of btrfs-tools fixed it for me. Cause I didn=C2=B4t do anything specifi=
c to fix=20
the hard lock up issue. The getting stuck issue Chris Mason fixed by wi=
th=20
casting patch.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
