Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:35262 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790Ab3DBREZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 13:04:25 -0400
Date: Tue, 2 Apr 2013 23:04:21 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Moving...
Message-ID: <20130402230421.016afe58@natsu>
In-Reply-To: <515A95C7.5090607@petaramesh.org>
References: <515A95C7.5090607@petaramesh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KifHl6Z_tfnJevexKDG7lnr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/KifHl6Z_tfnJevexKDG7lnr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Apr 2013 10:24:39 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Goodbye BTRFS, hello ZFS :-)
>=20
> I'm finally making the move, I couldn't stand the terrible BTRFS
> performance anymore, and spending 2 long minutes waiting for the HD LED
> to come off everytime I clicked anywhere.
>=20
> Did what I could, got the latest kernels, defragged, removed BTRFS
> snapshots, to no avail...
>=20
> So I'm in process of moving the 3 main laptops in here from BTRFS to ZFS.=
..


Whatever works for you --

but at this point I trust my data to BTRFS more, than I would trust ZFS.

(of course having current backups etc).

The following may not sound like a compliment to BTRFS; but on my filesyste=
ms
with heavy snapshotting, recently I am trialling a practice to run major ap=
ps
like a mail client and a browser via "eatmydata", which overrides and NOOPs
fsync. Since in any case I have "sync; btrfs sub snap...." on those machines
set to every 30 minutes in crontab, the potential of data loss due to
"eatmydata" is never too great.

I noticed the general experience is a lot snappier this way. You could try =
at
least to verify whether or not your HD LED issues (:D) are indeed caused by
slow fsyncs, or by something else.

I should note that I currently use a 3.7 series kernel, and haven't upgraded
to 3.8 and 3.9 yet, AFAIK those had some fsync improvements which might ren=
der
this trick useless. But this still doesn't change the fact that apps in
general seem to over-use fsync.

--=20
With respect,
Roman

--Sig_/KifHl6Z_tfnJevexKDG7lnr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFbD5UACgkQTLKSvz+PZwjFSACfbP1ZiWzsOoB8s2Fkm7vj7ffw
XQEAn3cLoUMLhUF6UV6WZTe2Nha5CYbT
=959x
-----END PGP SIGNATURE-----

--Sig_/KifHl6Z_tfnJevexKDG7lnr--
