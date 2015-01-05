Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52457 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbbAETgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 14:36:17 -0500
Date: Mon, 5 Jan 2015 19:36:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance is inexplicably dieing (repeatedly)
Message-ID: <20150105193616.GG32182@carfax.org.uk>
References: <CAAe=sHXgd0J+rm-w4cHC-P9T=PUCRx6vmLH0U3Uyhr03EZ_r5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5CUMAwwhRxlRszMD"
In-Reply-To: <CAAe=sHXgd0J+rm-w4cHC-P9T=PUCRx6vmLH0U3Uyhr03EZ_r5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5CUMAwwhRxlRszMD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 01:18:20PM -0600, sys.syphus wrote:
> I start it. I check it and its like 2% done
> Several hours its stopped and the re-balance clearly didn't finish
> because I can see one member of the array has a fraction of the usage
> of the others. Dmesg shows no errors.

   How large are the devices in question?

   Hugo.

> Thoughts? should start it again in the foreground with verbosity or
> something? any logs i can check other than dmesg?
> 
> 
> dmesg only shows similar to below
> 
> [342210.304169] BTRFS info (device dm-4): relocating block group ##### flags 17
> [342219.191141] BTRFS info (device dm-4): found 129 extents
> [342233.029425] BTRFS info (device dm-4): found 129 extents
> [342235.434779] BTRFS info (device dm-4): relocating block group ##### flags 17
> [342252.264736] BTRFS info (device dm-4): found 67 extents
> [342266.630318] BTRFS info (device dm-4): found 67 extents

-- 
Hugo Mills             | What do you give the man who has everything?
hugo@... carfax.org.uk | Penicillin is a good start...
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--5CUMAwwhRxlRszMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUquewAAoJEFheFHXiqx3k9e0P/Rg5o0Pd97Eto8r3rzZWmAMT
/Dnv+qPogdpsxeWUmnHTizrGMjCQx81FHJatvJ+wrNgtgn/kr5VK8q/u2lxQxvPN
INGrEw9tRagp8ScdL3iPEdmLpdLkQBZJbJKu8bcEqmxs2gsrMoB+dOANe2Sul5p2
2jy8VtCsDXP979njISwXM3xuZc465cR5Uce+bB3lA6pU/AHcNbyGq6ZJG5i/3qBL
bPlJTI+qwxg6ZnBtd7X/M6QN3R/+ZxI1tTK25pf9NmMxcuvbsH1deZvP3i9q4gdu
JQddfTz5C3rm7CL4sIf2G2OhnpA9A/rcq7VlhG757Hnw+vT7y/7H/V3YzWbtCjYf
4E/HwUFa+HyThAvL9udYY0K3j2JZc9yWQp/rR1abI0YLhqfoYBt0pfo3I0RXOz8V
3GTo2Ud63M549CumDKwH9Gsy408I6Sv9uiHx84RjfsOeb64fRDiKN6Jv5+2qGJlw
9dw/2PtbjnjVdTL8rfal3bAHcco4oWjnIatTZ6zdp+E8gPCOmX6/SX+5yLf0qZ3F
C70Rz+mdgO14DZ/PuLPwdH2Z5Tb6fWLs8YMCBIIsyn5hKzFMu7f03aFlsUABDQ7a
yCw3y68m8g8mzC8srgmKcszRthh3hzXPzriSR4VT5S8IBrEOjfHaVopSatgsNLyT
teRxjNl02QGcMYDASKRI
=dt00
-----END PGP SIGNATURE-----

--5CUMAwwhRxlRszMD--
