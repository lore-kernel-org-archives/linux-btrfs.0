Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B38DC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4908222C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732563AbfBLWLI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 17:11:08 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35368 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727957AbfBLWLI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 17:11:08 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 2C9A32195AF; Tue, 12 Feb 2019 17:11:07 -0500 (EST)
Date:   Tue, 12 Feb 2019 17:11:07 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190212221107.GC23918@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
 <CAJCQCtT1K4RY+_nmcWZdzHVSno-ijHZYLfJz4vu-irN4p+ZYxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <CAJCQCtT1K4RY+_nmcWZdzHVSno-ijHZYLfJz4vu-irN4p+ZYxA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 12, 2019 at 02:48:38PM -0700, Chris Murphy wrote:
> Is it possibly related to the zlib library being used on
> Debian/Ubuntu? That you've got even one reproducer with the exact same
> hash for the transient error case means it's not hardware or random
> error; let alone two independent reproducers.

The errors are not consistent between runs.  The above pattern is quite
common, but it is not the only possible output.  Add in other processes
reading the 'am' file at the same time and it gets very random.

The bad data tends to have entire extents missing, replaced with zeros.
That leads to a small number of possible outputs (the choices seem to be
only to have the data or have the zeros).  It does seem to be a lot more
consistent in recent (post 4.14.80) kernels, which may be interesting.

Here is an example of a diff between two copies of the 'am' file copied
while the repro script was running, filtered through hd:

	# diff -u /tmp/f1 /tmp/f2
	--- /tmp/f1     2019-02-12 17:05:14.861844871 -0500
	+++ /tmp/f2     2019-02-12 17:05:16.883868402 -0500
	@@ -56,10 +56,6 @@
	 *
	 00020000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-00021000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-00022000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	 00023000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |............=
=2E...|
	 *
	 00024000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	@@ -268,10 +264,6 @@
	 *
	 000a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-000a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-000a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	 000a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |............=
=2E...|
	 *
	 000a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	@@ -688,10 +680,6 @@
	 *
	 001a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-001a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-001a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	 001a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |............=
=2E...|
	 *
	 001a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	@@ -1524,10 +1512,6 @@
	 *
	 003a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-003a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-003a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	 003a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |............=
=2E...|
	 *
	 003a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	@@ -3192,10 +3176,6 @@
	 *
	 007a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-007a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-007a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	 007a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |............=
=2E...|
	 *
	 007a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	@@ -5016,10 +4996,6 @@
	 *
	 00c00000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	 *
	-00c01000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |............=
=2E...|
	-*
	-00c02000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
	-*
	[etc...you get the idea]

I'm not sure how the zlib library is involved--sha1sum doesn't use one.

> And then what happens if you do the exact same test but change to zstd
> or lzo? No error? Strictly zlib?

Same errors on all three btrfs compression algorithms (as mentioned in
the original post from August 2018).

> --
> Chris Murphy
>=20

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXGNEdwAKCRCB+YsaVrMb
nHliAJ9B1lSHVAyGKJPhB58DggzakyYTGwCdH5OkzGHkfQ7xjIqSxne4gvQiZoI=
=qR6Z
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
