Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46220 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S934939AbcJHHCE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Oct 2016 03:02:04 -0400
Date: Sat, 8 Oct 2016 03:02:00 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Subject: Re: btrfs rare silent data corruption with kernel data leak (updated
 with some bisection results)
Message-ID: <20161008070200.GU21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
 <20161008061008.GT21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
In-Reply-To: <20161008061008.GT21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 08, 2016 at 02:10:08AM -0400, Zygo Blaxell wrote:
[...]
> The "write half" of the bug seems to appear first somewhere between v3.8
> and v3.9.  I have not been able to reproduce it with v3.8.13, v3.7.10, or
> v3.6.11.  I can reproduce it in v3.9.11, v3.12.64, and v3.18.13..v4.7.5.

After six more iterations of the 'repro' script, I can reproduce "write
half" on 3.8.13.

Bisection is hard.  Bisecting ancient bugs even more so.


--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf4megACgkQgfmLGlazG5zXLwCdGeW72AL2S4Vsso38HrxNmRt9
MasAn39mL+TT3CXUiiT8A+HFJTHxx9Ww
=6Sr+
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--
