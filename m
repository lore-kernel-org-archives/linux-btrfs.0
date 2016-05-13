Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41308 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918AbcEMGVs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 02:21:48 -0400
Date: Fri, 13 May 2016 02:21:42 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160513062142.GF15597@hungrycats.org>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
 <4b7f7a0e-2fc4-8a08-c391-54be1d26ec51@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
In-Reply-To: <4b7f7a0e-2fc4-8a08-c391-54be1d26ec51@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 13, 2016 at 11:44:40AM +0800, Qu Wenruo wrote:
> Although maybe out of your expectation, inband de-dedupe did exposed some
> existing bugs we didn't ever found before.
> And they are all reproducible without inband dedupe.
>=20
> Some examples:
> [...]
> 3) Slow backref walk.
>    Already in the comment of backref.c from ancient days, but we didn't
>    put much concern until inband dedupe/heavily reflink work load.

Out-of-band dedup definitely hits that.  Most blocks are duplicated only
a few times, but a few common blocks are _really_ common.  I have some
filesystems where some extents have a few tens of thousands of references
by dedup, then a dozen snapshots are created to increase the ref count by
another order of magnitude.  'btrfs ins logical' takes hours to run on
these blocks--assuming the host doesn't run out of RAM and crash before
giving an answer.

Try doing a balance on a filesystem where some extents have a million+
references on a machine with 2G of RAM.  I _dare_ you.

It would be nice to get the bug fixes in sooner, whether or not the
upper layers of the in-band dedup feature are ready.

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlc1cnYACgkQgfmLGlazG5ynTwCfaFmXheYwz/+QkAaFI/N1gcwY
oBQAoLfTsLs2gyzXdDL9Zbpeg3K+RBi+
=Ud8k
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
