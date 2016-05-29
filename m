Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35572 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbcE2GyD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 02:54:03 -0400
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Adam Borowski <kilobyte@angband.pl>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de> <20160528015922.GI15597@hungrycats.org>
 <20160529002103.GA31105@angband.pl> <20160529005639.GA3576@hungrycats.org>
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <574A91FF.8010704@gmail.com>
Date: Sun, 29 May 2016 09:53:51 +0300
MIME-Version: 1.0
In-Reply-To: <20160529005639.GA3576@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QJ80FsmQOfIJh8469UEvvQ4TU69Rfjhf9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QJ80FsmQOfIJh8469UEvvQ4TU69Rfjhf9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

29.05.2016 03:56, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>> I don't think this can happen on btrfs: the superblock is updated only=
 after
>> a barrier when both the data and extent refs are already on the disk.
>=20
> If and only if the filesystem is mounted with the flushoncommit option,=

> that's true.  This is not the default, though, and I lost a fair amount=

> of time and data before I discovered this.
>=20

According to wiki, this is default on "reasonably recent kernels";
unfortunately it does say what kernel is recent enough. I am surprised
it can be disabled at all.


--QJ80FsmQOfIJh8469UEvvQ4TU69Rfjhf9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAldKkgYACgkQR6LMutpd94x9SwCeIpI70m+EyGdCnWuvwUbO7IkQ
N0IAn1S+O43i4RYKkHgp4ald84HQCGCI
=BXpk
-----END PGP SIGNATURE-----

--QJ80FsmQOfIJh8469UEvvQ4TU69Rfjhf9--
