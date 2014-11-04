Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36012 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056AbaKDWe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 17:34:28 -0500
Date: Tue, 4 Nov 2014 17:34:27 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
Message-ID: <20141104223427.GP17395@hungrycats.org>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
 <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
 <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
 <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
 <5455B7E7.3020404@pobox.com>
 <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
 <20141103034337.GM17395@hungrycats.org>
 <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
 <20141104043130.GN17395@hungrycats.org>
 <BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqN4RWvJTb9VNux/"
In-Reply-To: <BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tqN4RWvJTb9VNux/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 11:28:39AM -0700, Chris Murphy wrote:
> On Nov 3, 2014, at 9:31 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> > It needs to be more than a sequential number.  If one of the disks
> > disappears we need to record this fact on the surviving disks, and also
> > cope with _both_ disks claiming to be the "surviving" one.
>=20
> I agree this is also a problem. But the most common case is where we
> know that sda generation is newer (larger value) and most recently
> modified, and sdb has not since been modified but needs to be caught
> up. As far as I know the only way to do that on Btrfs right now is
> a full balance, it doesn't catch up just be being reconnected with a
> normal mount.

The data on the disks might be inconistent, so resynchronization must
read from only the "good" copy.  A balance could just spread corruption
around if it reads from two out-of-sync mirrors.  (Maybe it already does
the right thing if sdb was not modified...?).

The full resync operation is more like btrfs device replace, except that
it's replacing a disk in-place (i.e. without removing it first), and it
would not read from the non-"good" disk.

>=20
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tqN4RWvJTb9VNux/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRZVHMACgkQgfmLGlazG5yeVwCdE30lRZE3mh8TSR6Zi153/in8
GykAnjcB1bb9/RoJ6QigxNdRih3KRilr
=NsAF
-----END PGP SIGNATURE-----

--tqN4RWvJTb9VNux/--
