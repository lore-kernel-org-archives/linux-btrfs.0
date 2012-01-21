From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 21 Jan 2012 12:19:40 +0100
Message-ID: <201201211219.40433.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201112202146.32265.Martin@lichtvoll.de> <201201211149.53403.Martin@lichtvoll.de> (sfid-20120121_121222_392984_DBC5368F)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201211149.53403.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> I still have this with 3.2.0-1-pae - which is a debian kernel based o=
n=20
> 3.2.1.
>=20
> When I do btrfs scrub start / the machine locks immediately up hard.
>=20
> Then usually on next boot it stops on space_cache enabled message, bu=
t
> not  the one for /, but the one for /home which is mounted later.
>=20
> When I then boot with 3.1 it works. BTRFS redos the space_cache then
> while  the machine takes ages to boot - I mean ages - 10 minutes till
> KDM prompt is no problem there.

I now tested scrubbing /home which is a different BTRFS filesystem on t=
he=20
same machine.

Then the scrub is started, scrub status tells me so, but nothing happen=
s,=20
no block in/out activity in vmstat, no CPU related activity in top.

btrfs scrub cancel then hangs, but not the complete machine, only the=20
process.

I had this once on my T520 with the internal Intel SSD 320 as well. The=
=20
other time it worked.

Well maybe that is due to BTRFS doing something else on my T23 now:

deepdance:~> ps aux | grep ino-cache | grep -v grep
root      1992  5.5  0.0      0     0 ?        D    12:15   0:09 [btrfs=
-
ino-cache]

Hmmm, so I just let it sit for a while, maybe eventually it will scrub=20
/home.

At least it doesn=C2=B4t lock up hard, so there might really be somethi=
ng=20
strange with /.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
