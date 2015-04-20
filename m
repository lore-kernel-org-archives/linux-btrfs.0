Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbbDTG1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 02:27:12 -0400
Date: Mon, 20 Apr 2015 16:27:00 +1000
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-cachefs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] fscache/cachefiles: optionally use SEEK_DATA
 instead of ->bmap.
Message-ID: <20150420162700.3e69c7db@notabene.brown>
In-Reply-To: <20150420060818.GA32675@infradead.org>
References: <20150420052558.26554.97143.stgit@notabene.brown>
	<20150420052752.26554.52672.stgit@notabene.brown>
	<20150420060818.GA32675@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NotRydnzzEpYrqMVuunxyls"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/NotRydnzzEpYrqMVuunxyls
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Apr 2015 23:08:18 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> Please just usse SEEK_HOLE/DATA support unconditioanlly.  ->bmap is a
> horrible hack that is completely unsafe.
>=20

A worthwhile goal, but I certainly wouldn't consider pursuing it until what=
 I
have submitted so far as been accepted - let's not reject "good" while
waiting for "perfect".

NeilBrown

--Sig_/NotRydnzzEpYrqMVuunxyls
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTScNDnsnt1WYoG5AQL1hhAAj5ug4OEhGU3tm5mE4furUb7PFtLkE40d
k3sSBkyMuc6foHFz5e3JQWKUVg2kbk/PFz5+nsNf4EMBbIy57nw4xYKfyD3sjsVo
hcYVGzDxzjgQK5UFvfgSnWycZM4SLeoSeN8iyUMYABLmiu2Iu3Wv9iM9mTZizx0t
8KycFib2TWRq2hx3txeHVZltQwu0NzRSzyeed4BS1ecco3CPGsHFE1BUY8Kef1mt
VaZMyqak1KxTTBNp/AW0h4nnaHC+NBWAHYj6lYJMrjPCbswbzae5kHL0qVnZ2y5B
yyBtczdqeBcYv2vzCMA23w0OaTPtpYF1gLi1UqULBHkk+z3vkPLUIphlc87NE3r0
SktDFPjldxNoAjkl6pX4spHDlnRgD3RdYF2B5QF2Eq8i0gvvaoH9pvqN31ukM2L4
wIyAh26wCgtmOPmfRs5eYevUEm6Zgk9KlMNg269GZdDZckmfwIijAWHXzHvSYJ7r
q4Et6W4G87A8jJ//jC206B/0oWCB15KA0Z0ePoazxTzUUBcU8nsD0tp0t4FLtPMZ
c2L87Wo/xY9KorntW9O46Z32QsBuDc+Xn0E/EDge18Sg8F/nRvC02CI6aTF4i4Fz
F2PkNkPBigeWXwl+mBshO3yUUrXO6vZTJVohFzDMuoYKBJFJBhG2AlU268NrPToQ
xW4dBGOJM8Y=
=53xJ
-----END PGP SIGNATURE-----

--Sig_/NotRydnzzEpYrqMVuunxyls--
