Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48084 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754185AbbDTPTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 11:19:45 -0400
Date: Mon, 20 Apr 2015 11:19:44 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Gian-Carlo Pascutto <gcp@sjeng.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150420151943.GB20194@hungrycats.org>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <49296740.rPqQP4vAjc@merkaba>
 <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
 <20150420042731.GA20194@hungrycats.org>
 <mh2cfv$7rr$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
In-Reply-To: <mh2cfv$7rr$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2015 at 10:13:47AM +0200, Gian-Carlo Pascutto wrote:
> On 20-04-15 06:27, Zygo Blaxell wrote:
>=20
> >> I'm curious as to whether +C has any effect on BTRFS's durability, too.
> >=20
> > I would expect it to be strictly equal to or worse than the CoW
> > durability.
>=20
> In addition to the stuff pointed out, I've wondered about this:
> PostgreSQL full_page_writes copies 8k pages in order to prevent
> corruption from partial writes. But btrfs has 16k pages by default, so a
> corrupted FS page would corrupt more data than PostgreSQL protects.

There are multiple page sizes in a btrfs.

*Metadata* pages are 16K by default.  Metadata is always CoW in btrfs.

*Data* pages are 4K by default.  AIUI the btrfs code currently heavily
relies on data page and host CPU page sizes being identical.  I don't
know what happens on architectures with 8K page sizes--it's been years
since I booted an Alpha machine.

> Maybe it's not an issue if the underlying HW has 512b/4k sectors, or
> maybe I'm misunderstanding what the respective features assume, but
> unless informed to the contrary I wouldn't be entirely comfortable with
> this.

Usually writes are issued in multiples of 4K pages at a time from
the kernel, so the underlying sector size only comes into play when
something interrupts a disk between individual sector writes within
a page.

full_page_writes should handle no-CoW on btrfs (or any other filesystem)
just fine.  It's the *other* btrfs bugs you have to worry about.  ;)

> (With CoW enabled, you don't have partial writes, so the point is moot)
>=20
> --=20
> GCP
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU1GQ8ACgkQgfmLGlazG5zSGgCgl8kzr4GeM1PH0iRyUh+WjzFq
h44An2bzgeVU4P+cKV6lhNkjViIU8x8U
=9mW6
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
