Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36671 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaJ0Sdm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 14:33:42 -0400
Date: Mon, 27 Oct 2014 18:33:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Cc: David Sterba <dsterba@suse.cz>, Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: suspicious number of devices: 72057594037927936
Message-ID: <20141027183338.GL18164@carfax.org.uk>
References: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
 <CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com>
 <20141027153532.GF22943@twin.jikos.cz>
 <alpine.DEB.2.19.4.1410271117030.9302@trent.utfs.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYrjF+tKt+ApYAdb"
In-Reply-To: <alpine.DEB.2.19.4.1410271117030.9302@trent.utfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aYrjF+tKt+ApYAdb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 11:21:13AM -0700, Christian Kujau wrote:
> On Mon, 27 Oct 2014 at 16:35, David Sterba wrote:
> > Yeah sorry, I sent the v2 too late, here's an incremental that applies
> > on top of current 3.18-rc
> > 
> > https://patchwork.kernel.org/patch/5160651/
> 
> Yup, that fixes it. Thank you! If it's needed:
> 
>   Tested-by: Christian Kujau <lists@nerdbynature.de>
> 
> @Filipe: and thanks for warning me about 3.17 - I used 3.17.0 since it 
> came out and compiled kernels on the btrfs partition and haven't had any 
> issues. But it wasn't used very often, so whatever the serious issues 
> were, I haven't experienced any.

   If you make read-only snapshots, there's a good chance of metadata
corruption. It's fixed in 3.17.2.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Our so-called leaders speak/with words they try to jail ya/ ---   
        They subjugate the meek/but it's the rhetoric of failure.        
                                                                         

--aYrjF+tKt+ApYAdb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUTpACAAoJEFheFHXiqx3kizQP/iJ13byResxtdlbVW+r9q8JE
gEwo5fjb6qDOEp14iJCZRxWdttLdLj+Z6Fw2/CLZplJ99+htUKp9aKUioLk4Ts/g
lVO0gkR1U29wixWb/B6GOAHjKCpFrUoO/rqTdLmbBsCMlvPvuRxXk9YBZtm0tOTp
KJJrimAYuE+520woUjSCDZpqZP2fPxYh/TfTwbsCS16U33JkKWeQSeUdr5LKzxE2
WBn9xnDQREZAzl7j9QvbZpsiAYHJI0eTRNLGfYzWBmbW2HCeozM3zzPci+6Mlxjm
5PHPI+nXnVgc+v/YV4od0pzPAk2t2rDhOU0c+5iMx1ufTTFQfOkOLhlVAUG97POc
pNK0TZUykcrJBoP2/J/rVzQDvfYbJLFlyn+Mu2d7wzRVKcjQMr+SVU21L9Md1MN6
7b9khEqupI5TlbMSONboYL+G+54nFJMH9JSBLbp43chx/TUkeunzLrSxFMMTJVEs
Fv2LqBsToGRxHZ9FYMgStlHcwy7Lk3vsLlsgixpoufMj+TWQ6zGbloHg+z6Xt7tA
ey9Fp466jKPos0d2LcykCCMrNJc8gX3BkoTadVaypefLNK5WNjvW4dD1dS4lecYb
Zslqw15f0a1F3AHQrhpkVLr7TahesSoni5RDtEIWkSJWzy5xRJ/YRyNz05iPvyJ7
nXI3fkRGJj7N3t8VPLLD
=NA0q
-----END PGP SIGNATURE-----

--aYrjF+tKt+ApYAdb--
