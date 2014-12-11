Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38787 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933251AbaLKC1p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 21:27:45 -0500
Date: Wed, 10 Dec 2014 21:27:43 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Message-ID: <20141211022742.GA25614@hungrycats.org>
References: <547BCB43.5020505@cn.fujitsu.com>
 <547BE8A5.7050900@pobox.com>
 <547C0834.7090706@cn.fujitsu.com>
 <547CAF2E.7070109@pobox.com>
 <547D1339.10404@cn.fujitsu.com>
 <547F61F6.7020707@pobox.com>
 <548005B7.40503@cn.fujitsu.com>
 <20141210215729.GC22023@hungrycats.org>
 <5488FBE0.7060309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
In-Reply-To: <5488FBE0.7060309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2014 at 10:05:20AM +0800, Qu Wenruo wrote:
>=20
> -------- Original Message --------
> Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with S=
QL?
> From: Zygo Blaxell <zblaxell@furryterror.org>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014=E5=B9=B412=E6=9C=8811=E6=97=A5 05:57
> >On Thu, Dec 04, 2014 at 02:56:55PM +0800, Qu Wenruo wrote:
> >>The main memory usage in btrfsck is extent record, which
> >>we can't free them until we read them all in and checked, so even we
> >>mmap/unmap, it can only help with
> >>the extent_buffer(which is already freed if not used according to refs).
> >I'm thinking aloud here, but is it *really* necessary to read everything
> >into memory?
> Totally agreed to only read what we need.
> But some backref and counts on refs can only be determined after a
> full scan, especially for leaf/node corruption
> case.

It might be faster (and smaller) to pipe them out to sort (with gzip/lzma
compression on temporary files) than to try to insert them in a tree.
I have used that technique in some of my deduplicating programs.  It can
cut the working set size by several orders of magnitude (trading it for
an O(n log n) sort, which will mostly read and write sequentially).

e.g. duplicate refs will all sort together, so when you are sequentially
reading the sorted data and the current key value changes, you know you've
seen everything that could be a duplicate, and can discard everything
in RAM.


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSJAR4ACgkQgfmLGlazG5yo+QCfZC9XUSOMn1ljmnPcQWMgzgSN
b4MAoOiM5IRN4VcXhMLdhDTjFCackWzl
=hY2b
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
