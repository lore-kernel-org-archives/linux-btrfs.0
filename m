Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43490 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaANVsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:48:17 -0500
Date: Tue, 14 Jan 2014 21:47:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mitchel Humpherys <mitch.special@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Minor grammar nitpick
Message-ID: <20140114214756.GA3314@carfax.org.uk>
References: <1389735843-11685-1-git-send-email-mitch.special@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <1389735843-11685-1-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 01:44:02PM -0800, Mitchel Humpherys wrote:
> This patch removes the word `to' from the `Can't access to X' error
> messages.

   Thanks. That's been annoying me intermittently for years. (Just not
quite enough to do anything about it).

   Hugo.

> Mitchel Humpherys (1):
>   btrfs-progs: fix minor grammar issues
> 
>  cmds-balance.c    | 10 +++++-----
>  cmds-device.c     |  4 ++--
>  cmds-filesystem.c |  6 +++---
>  cmds-scrub.c      |  2 +-
>  cmds-subvolume.c  | 10 +++++-----
>  5 files changed, 16 insertions(+), 16 deletions(-)
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtWwi1heFHXiqx3kAQJ33BAAhOtLo7zo0GuiXXtu4E1Ssw8XrW2kr/RW
OsNY1vscfPEwybVWSHNDeQcgPUagW3hVWY/IUnQrlqxhKnwL/EinhuEXBnkSae7W
6E7TgffuggYV0Lwg/T+jRM8wENoL3AWtkWCV6RNHRxU9Qo2gBKew56g95i7dUDVA
zV506k5yJCuVM+FQfMA+3xVAfLAYDuDeXH04uhX0MgutK7RS2iqmUxCV72OELC0l
SNsf/KeRyzC8G4iR1nVln59CYbZrQSWHh4RKpRcMZE2FFtAnT2yh/tBNOzTov2nI
r3MOdGAw8+ytJVoVAI5JLMVgiaEAwl+WR9BtU97oDLgcoXHr4AjokMxVMXpqBW8c
wZJEvteuot+4e7ttPNdlcw+6aotOB01CczK0D14ukV0ASbjlHpFIBrlIkNqwTm+E
UcNYcs5g15tUI0TMzITmrs6uvki1fIad6fv1bxFKSCBlzHKXlKtzphmXqCEhX4+y
oxdrAi7r+JBweJ0kQcLL4L6dWKZNimJIZUqueiPolNhjrvN2nPMJyfUyF4Duj+s7
XCax90R9TrfmyQruxTSUUXj74aEx8m8ERmvdVP8tkeLfaZBjK1SHu1xdjFN4OPyJ
Teys3GIn45rWBLe0/nKsR+CqVIU4lskqi08tXtK3l9ba1Jz5exPZSJTVqxlm8Py/
wUGxfR740R4=
=Gnu9
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
