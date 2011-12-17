From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 17:10:52 +0100
Message-ID: <201112171710.53140.Martin@lichtvoll.de>
References: <201112171254.47334.Martin@lichtvoll.de> <2297283.SPUU0GRYgu@venice> (sfid-20111217_153859_857968_5C12DFCF)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: Goffredo Baroncelli <kreijack@inwind.it>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2297283.SPUU0GRYgu@venice>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Goffredo Baroncelli:
> > Adding new possibilities is one thing. And supporting snapshots
> > properly would depend on some support side from the applications. I
> > think that using snapshots for upgrades is a good idea.
> >
> >=20
> >
> > But OTOH I think that BTRFS should not break or slow down existing
> > userspace. I think that existing approaches like using fsync() like
> > according to quite some filesystem developers it should be used
> > should continue to work nicely.
>=20
> Nobody wants to slowdown the application. But the life is full of
> compromises. If you want the speed of ext4, you can use ext4. If you
> want the snapshot capability and the COW guarantee you can use BTRFS,
> but you have some slowness.
>=20
> Of course the best would be have the speed of the ext4 with the
> capabilities  of btrfs.... :-) Unfortunately today this is not
> available.

Its perfectly acceptable for me that BTRFS does not deliver this yet.

I understood your initial answer that its just that BTRFS is different =
and=20
thus performs poorly in fsync() based workloads and thats about it. Tha=
t=20
its a principal issue. That part I didn=B4t agree too. Heck from the de=
sign=20
differences of COW filesystem it might even be some sort of a principal=
=20
issue. But then I like to see this as a challenge, not as a show stoppe=
r.

Actually for me especially for that Amarok Thinkpad T23 there is no hur=
ry.=20
Its play BTRFS play machine. I just want to see what I can do with=20
filesystem maintenance to bring it up to speed.

Everything else is following development and upgrading kernels ;).

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
