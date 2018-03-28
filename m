Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34650 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751207AbeC1NxV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 09:53:21 -0400
Date: Wed, 28 Mar 2018 09:45:11 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call
 "subvolume list/show"
Message-ID: <20180328134501.GA2446@hungrycats.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 19, 2018 at 04:30:17PM +0900, Misono, Tomohiro wrote:
> This is a part of RFC I sent last December[1] whose aim is to improve nor=
mal users' usability.
> The remaining works of RFC are:=20
>   - Allow "sub delete" for empty subvolume

I don't mean to scope creep on you, but I have a couple of wishes related
to this topic:

  - allow "rmdir" to remove an empty subvolume, i.e. when a subvolume is
    detected in rmdir, try switching to subvol delete before returning
    an error.  This lets admin tools that are not btrfs-aware do 'rm
    -fr' on a user directory when it contains a subvolume.  Legacy admin
    tools (or legacy tools in general) can't remove a subvol, and there
    is no solution for environments where we can't just fire users who
    create them.

  - mount option to restrict "sub create" and "sub snapshot" to root only.
    If we get "rmdir" working then this is significantly less important.

>   - Allow "qgroup show" to check quota limit
>=20
> [1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWrucWAAKCRCB+YsaVrMb
nKiMAKCHVNNhlBxf6qwU6lr4WlE5w+yyJgCfV3fdienOo3iyWYQZ/dovmShNnqU=
=cR1t
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
