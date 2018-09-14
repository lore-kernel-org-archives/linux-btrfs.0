Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41715 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbeINXeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 19:34:00 -0400
Received: by mail-qt0-f196.google.com with SMTP id t39-v6so9571688qtc.8
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 11:18:21 -0700 (PDT)
Date: Fri, 14 Sep 2018 14:18:19 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Rafael =?iso-8859-1?Q?Jes=FAs_Alc=E1ntara_P=E9rez?=
        <ralcantara@idedalo.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Problem with BTRFS
Message-ID: <20180914181818.rnef5ml3wgelwjm5@DigitalMercury.dynalias.net>
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
 <20180914224612.07a5db1b@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nonmqprldxaawwyp"
In-Reply-To: <20180914224612.07a5db1b@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nonmqprldxaawwyp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 14, 2018 at 10:46:12PM +0500, Roman Mamedov wrote:
> On Fri, 14 Sep 2018 19:27:04 +0200
> Rafael Jes=FAs Alc=E1ntara P=E9rez         <ralcantara@idedalo.com> wrote:
>=20
> > BTRFS info (device sdc1): use lzo compression, level 0
> > BTRFS warning (device sdc1): 'recovery' is deprecated, use
> > 'usebackuproot' instead
> > BTRFS info (device sdc1): trying to use backup root at mount time
> > BTRFS info (device sdc1): disk space caching is enabled
> > BTRFS info (device sdc1): has skinny extents
> > BTRFS error (device sdc1): super_total_bytes 6010266660864 mismatch with
> > fs_devices total_rw_bytes 6010266663424
>=20
> There is a recent feature added to "btrfs rescue" to fix this kind of
> condition: https://patchwork.kernel.org/patch/10011399/
>=20
> You need a recent version of the Btrfs tools for it, not sure which, I see
> that it's not in version 4.13 but is present in 4.17.

btrfs-progs_4.17-1~bpo9+1_amd64.changes is waiting to pass through NEW
(due to the new library packages in the backport).  It will take
between 24h and several weeks to pass to stretch-backports.  The
variability in expected delivery is because a Debian FTP Master will
need to manually ACK the changes.

If 4.17.1 is required, please 'reportbug btrfs-progs' and take care to
set the "found" version to 4.17-1, plus provide a citation for why
4.17.1 is required--without this justification the bug severity could
be downgraded to wishlist.  This hypothetical bug would be for the
"unstable" suite (packages migrate to testing after a period of
testing, and then become eligible for backporting).

Take care!
Nicholas

--nonmqprldxaawwyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlub+2gACgkQWogwR199
EGEvhhAAhFlzAlSv0fjPAYZAWnNH4BHxazyVPeNi/kKKaWrDMByqYcOqkazu8eCG
nWyPOPHD47SEeHMXz/QS27PQz3f6dKglbPRsahn0rTr/DZ0LiIQ8AMhZXcBt3zTN
rKk5o5XoueBsdzJBJ8T9deH3WYt3fPLVCXnTTYLhIN2+99U8vu+ZmsSJ8LGuniAq
ugjfcUAUCmoigQ3OZNPMxgpOYkswzZFbHxEM0BaJRJnOHn7HPD/XsonsP9jvlX1W
BERmWzDr/MNaPoDtDmpt1/U7xfSqg5QTxS6nAy/y9iIFlFu6bLIulOYGhn5HWUHD
P/53co5WdVWZ3+B6pNdXWdKDi17KVBZ+tzsfcm4485DU8LxP5gli5C3ncrSVENI9
GLblvQ+iRQGLLdAVDzyokAGJKVM7gYP0VXhGrBgSgG8PXV9LYWW+UKoAMjejtX4a
J0DH3GCOtHCnzUNHkhzzEKLiocJckj1p1NbKtvgJLQVefY2MGMWzWHbUOCNoJ5GJ
nAlyq2o/BYGrhDAKFepUt/+4SNq9eoBN+N7gEaxsWFkqu0IovbV2nzHLdeJr/0Zx
J2NfDzS1dQfTUp42surbkXrlvggkEHd3X0XLMkkGzA1T4L9F/7IrQxNf860Tk3pc
H/ml4qPmexaPpPhQhj28Us9aEvmdgRlWXconWk6tGxCCZ4Ho7IA=
=ZjJH
-----END PGP SIGNATURE-----

--nonmqprldxaawwyp--
