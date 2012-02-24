From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Fri, 24 Feb 2012 16:51:57 +0100
Message-ID: <201202241651.57233.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201201211149.53403.Martin@lichtvoll.de> <201201211219.40433.Martin@lichtvoll.de> (sfid-20120121_123006_768632_E7FD03DC)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201211219.40433.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > I still have this with 3.2.0-1-pae - which is a debian kernel based
> > on 3.2.1.
> >=20
> > When I do btrfs scrub start / the machine locks immediately up hard=
=2E
> >=20
> > Then usually on next boot it stops on space_cache enabled message,
> > but not  the one for /, but the one for /home which is mounted
> > later.
> >=20
> > When I then boot with 3.1 it works. BTRFS redos the space_cache the=
n
> > while  the machine takes ages to boot - I mean ages - 10 minutes ti=
ll
> > KDM prompt is no problem there.
>=20
> I now tested scrubbing /home which is a different BTRFS filesystem on
> the same machine.
>=20
> Then the scrub is started, scrub status tells me so, but nothing
> happens, no block in/out activity in vmstat, no CPU related activity
> in top.
>=20
> btrfs scrub cancel then hangs, but not the complete machine, only the
> process.
>=20
> I had this once on my T520 with the internal Intel SSD 320 as well. T=
he
> other time it worked.
>=20
> Well maybe that is due to BTRFS doing something else on my T23 now:
>=20
> deepdance:~> ps aux | grep ino-cache | grep -v grep
> root      1992  5.5  0.0      0     0 ?        D    12:15   0:09
> [btrfs- ino-cache]
>=20
> Hmmm, so I just let it sit for a while, maybe eventually it will scru=
b
> /home.
>=20
> At least it doesn=C2=B4t lock up hard, so there might really be somet=
hing
> strange with /.

=46WIW a btrfs filesystem balance / does work. After this a btrfs scrub=
 start=20
/ still locks the kernel.

Anyway, I might be waiting for the new fsck and try it on the partition=
=2E=20
Or redo the filesystem from scratch, cause I think trying to debug this=
=20
will take way more time.

I might also as well redo /home as well. Two fresh 3.2 or 3.3 kernel BT=
RFS=20
and see whether they work better.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
