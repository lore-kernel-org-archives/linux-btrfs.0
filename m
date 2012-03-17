From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: "scrub" stops the machine
Date: Sat, 17 Mar 2012 19:14:28 +0100
Message-ID: <201203171914.28883.Martin@lichtvoll.de>
References: <C52r9Lpy1uB@helmut.hullen.de> (sfid-20120317_190725_615492_5DABFEFE)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "Helmut Hullen" <Hullen@t-online.de>,
	Arne Jansen <sensille@gmx.net>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52r9Lpy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. M=E4rz 2012 schrieb Helmut Hullen:
> Hallo, Arne,

Hi Helmut, Arne, Chris, hi everyone,

> Du meintest am 17.03.12 zum Thema Re: "scrub" stops the machine:
> > On 03/17/12 17:35, Helmut Hullen wrote:
> >>          btrfs scrub start /mnt/btr
> >>=20
> >> and all was dead. Really dead. No access via keybord, no access vi=
a
> >> SSH.
> >=20
> > what kernel are you using?
>=20
> As mentioned some hours ago: 3.2.9 (self made).
>=20
> > Are you by any chance on a 32 bit maschine?
>=20
> Yes.

Please review the thread I started with subject:

3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot

I had the same issue, but with some recent 3.2 debian kernel it went aw=
ay=20
and then the scrub just hang - process in D state. And a patch from Chr=
is=20
fixed that.

Arne had two patches to test that he thought might fix the lock up hard=
=20
issue, but I didn=B4t need those.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
