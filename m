Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45900 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725734AbeIHEQC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2018 00:16:02 -0400
Date: Fri, 7 Sep 2018 19:32:21 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dduper - Offline btrfs deduplication tool
Message-ID: <20180907233221.GI13528@hungrycats.org>
References: <20180824043139.GA8263@giis.co.in>
 <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
 <20180907035728.GA7717@giis.co.in>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SdaPbLtAangIkrMZ"
In-Reply-To: <20180907035728.GA7717@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SdaPbLtAangIkrMZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 09:27:28AM +0530, Lakshmipathi.G wrote:
> >=20
> > One question:
> > Why not ioctl_fideduperange?
> > i.e. you kill most of benefits from that ioctl - atomicity.
> >=20
> I plan to add fideduperange as an option too. User can
> choose between fideduperange and ficlonerange call.
>=20
> If I'm not wrong, with fideduperange, kernel performs
> comparsion check before dedupe. And it will increase
> time to dedupe files.

Creating the backup reflink file takes far more time than you will ever
save from fideduperange.

You don't need the md5sum either, unless you have a data set that is
full of crc32 collisions (e.g. a file format that puts a CRC32 at the
end of each 4K block).  The few people who have such a data set can
enable md5sums, everyone else can have md5sums disabled by default.

> I believe the risk involved with ficlonerange is  minimized=20
> by having a backup file(reflinked). We can revert to older=20
> original file, if we encounter some problems.

With fideduperange the risk is more than minimized--it's completely
eliminated.

If you don't use fideduperange you can't use the tool on a live data
set at all.

> >=20
> > --=20
> > Have a nice day,
> > Timofey.
>=20
> Cheers.
> Lakshmipathi.G

--SdaPbLtAangIkrMZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW5MKggAKCRCB+YsaVrMb
nClZAKDNK9oRTGJM+UkuV6ovisjaY4DYUgCglP+2cNcofe1CDbT4/7JZC6TExcE=
=AfoQ
-----END PGP SIGNATURE-----

--SdaPbLtAangIkrMZ--
