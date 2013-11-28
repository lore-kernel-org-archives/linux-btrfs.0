Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:60761 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab3K1Tgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 14:36:42 -0500
Date: Fri, 29 Nov 2013 01:36:38 +0600
From: Roman Mamedov <rm@romanrm.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after
 subvol delete
Message-ID: <20131129013638.01ede78a@natsu>
In-Reply-To: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eTIpJZ3_oSsb=1LQMw+MQSw"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/eTIpJZ3_oSsb=1LQMw+MQSw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Nov 2013 17:59:07 +0100
David Sterba <dsterba@suse.cz> wrote:

> Subvolume deletion does not do a full transaction commit. This can lead
> to an unexpected result when the system crashes between deletion and
> commit, the subvolume directory will appear again. Add options to request
> filesystem sync after each deleted subvolume or after the last one.
>=20
> If the command with sync option finishes succesfully, the subvolume(s)
> deletion status is safely stored on the media.

A feature that people pretty often request, is a way to delete a subvolume,
and have some way to "sync", i.e. pause execution of their script until all
the space freed up by the deletion has been recovered and made available (e=
.g.
for the next round of their backup to run).

Does this patch now make this possible?

Also, did you consider enhancing "btrfs fi sync" to sync the snapshot delet=
ion
(it currently doesn't), rather than adding the "sync" options to deletion
itself? E.g. comparing to traditional tools, people would logically do:

  $ rm /some/dir/some/file
  $ sync

rather than something akin to

  $ rm --sync /some/dir/some/file

--=20
With respect,
Roman

--Sig_/eTIpJZ3_oSsb=1LQMw+MQSw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKXm0YACgkQTLKSvz+PZwhozQCdGT0Rsjx11RZ7ghMjQwQ2mIVt
yNwAnAnd3Ao2BSXhzeT3rK5FiZtbOVtA
=j9LW
-----END PGP SIGNATURE-----

--Sig_/eTIpJZ3_oSsb=1LQMw+MQSw--
