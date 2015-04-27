Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39525 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbbD0RhT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 13:37:19 -0400
Date: Mon, 27 Apr 2015 17:37:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: sri <toyours_sridhar@yahoo.co.in>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs freeze/thaw when using with LVM2
Message-ID: <20150427173717.GD18187@carfax.org.uk>
References: <loom.20150427T140306-446@post.gmane.org>
 <20150427121521.GB18187@carfax.org.uk>
 <loom.20150427T163556-13@post.gmane.org>
 <20150427145549.GC18187@carfax.org.uk>
 <20150427223442.47e254c4@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cf/4ySkkvY6jtT1l"
In-Reply-To: <20150427223442.47e254c4@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Cf/4ySkkvY6jtT1l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2015 at 10:34:42PM +0500, Roman Mamedov wrote:
> On Mon, 27 Apr 2015 14:55:49 +0000
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > > This is strange considering that I wanted a consistent snapshot of 
> > > entire btrfs filesystem at volume level.
> > > 
> > > Is there a way to achive this? or btrfs just cannot provide?
> > 
> >    No, there's no way to manage it with the current btrfs code.
> 
> Why not. fsfreeze, dd to a file (optionally with compression), unfreeze.

   OK, point taken, but if you want to use the frozen volume to make a
file-level backup of the FS contents, you've still got to turn it into
a block device and mount it... at which point, you get hit by the
explosion again...

   Hugo.

-- 
Hugo Mills             | The future isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Cf/4ySkkvY6jtT1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPnPMAAoJEFheFHXiqx3krkkP/3x1psrXPTNS/ixWLagtwGAg
YBewUTtWYdJamnPVtMdNDaVRUueABFDXmjv6siDkl5w46g7g6OxaBDAk4XCw/Oj9
qnpjUWoZMMbN1RKeyW0Oz2ytSkPMtxXoTU/z0K2GMH0hIIZcSGhVG9WygflX7111
x2eb0wlVKM2Qe3ooIeMOI4MGlulFV5G85urEQlgFYF5D5qdr52NXk/Apdxnd56gI
tamCMJwwznMqMjP5Fnavy7KCvPTVgEMKLnII7E0AUQC5eW8uLy1+fOZUVtecWaim
+IB6O7M9ularLF/KVustLZm1yFYml+/nCnnsEdKkAy9s0edyOO4aRvxdzsqb/tRZ
D9uIUTOaHy90Wij7lYkMvSEMdWtEk32H1Kx2GMjw8KAzHP6OBMSOgYYExWUpD6dJ
CcOh7mqtIbugJDRT7EHQuR8rUrZA8XrBOIqySOt3VH1sMYI56UuUSaN/JELiTVvO
slSZbCtjOIcheZcg17pXoBpiWpZkiEVHtydVvd32+RRJTJFhRK1ug67ij5ECXTjr
7oINC4cC6iAEsCW9yO7YYxj7SMB7orncutbq6dc4MlTvvQUc49vKs/zcedD1Wj7q
49qhyUgaw1M2us5A9hENvZu1oqiYkOE04p4/aSyBKJBpflcUij9TBHgX6eXRhsP2
t2NDTqEDJjww/v/o/2b9
=/ynb
-----END PGP SIGNATURE-----

--Cf/4ySkkvY6jtT1l--
