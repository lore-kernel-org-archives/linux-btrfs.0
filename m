Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54739 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbcGPAR7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 20:17:59 -0400
Date: Sat, 16 Jul 2016 00:17:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Wheeler <btrfs@lists.ewheeler.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How can I get blockdev offsets of btrfs chunks for a file?
Message-ID: <20160716001757.GN3041@carfax.org.uk>
References: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
In-Reply-To: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 15, 2016 at 04:21:31PM -0700, Eric Wheeler wrote:
> Hello all,
> 
> We do btrfs subvolume snapshots over time for backups.  I would like to 
> traverse the files in the subvolumes and find the total unique chunk count 
> to calculate total space for a set of subvolumes.

   btrfs fi du may help here. Alternatively, qgroups should be able to
tell you for groups of subvols, if it's set up correctly. You
shouldn't need to implement this at a low level yourself...

> This sounds kind of like the beginning of what a deduplicator would do, 
> but I just want to count the blocks, so no submission for deduplication.  
> I started looking at bedup and other deduplicator code, but the answer to 
> this question wasn't obvious (to me, anyway).
> 
> Questions:
> 
> Is there an ioctl (or some other way) to get the block device offset for a 
> file (or file offset) so I can count the unique occurances?

   This is very much an X/Y question. There already exist a couple of
things that are at least close to the thing you actually want to
do. :)

   Hugo.

> What API documentation should I review?
> 
> Can you point me at the ioctl(s) that would handle this?
> 
> 
> Thank you for your help!
> 
> 

-- 
Hugo Mills             | Reintarnation: Coming back from the dead as a
hugo@... carfax.org.uk | hillbilly
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXiX01AAoJEFheFHXiqx3kD+0P/1Z3pjm46YB82I99JT/3LKW5
gp6y0t1R8ypVahu7hPtqaLHh0yiz2EamKPSQykO1pX4eGP85+idVaIjLCDUKGRbx
DnLPMTyqJshX7UnVjZN4sWKKVmG/nvwcoU7acuAoOpo1/Z96sOc28o3BBnKNdiBG
CxdSuJvI/UudiIWAZpJwuGQslWabYp7z+U7PeshcS4eHeYf0LeUsreuJNQyqL578
J5cwUJzCpLqEXkbVTRTiOmZy9YOO6f5kA9N5M9rgg4Nw2fKq8EkvndIJrvrnHDgg
3AR6DyLnXMnTiOz2dw2Z7c8gcDtPiwiUSM09ek++xc0ltPuKGIYqCYJ1kdAJ7XkJ
pqXBszn+jIsaFidP9rp3Wa9zhPNGUz69NFyuhN7sXHHHtADwp1JbGuv88tSnhBZa
OA3Y+HCK7Xv9nXOthtD5Zt9PN2VbD6m8ZCTi3RhUbiVsuKyBLAfzWjGDRHu4hRmG
MKW2TSynTxRhdt8Bo+UAJNWnR3GnD/46rH44H3fpZgg1m3GwpFGRjpr3W3qrWpsq
vERtx39Tsk4OXAETUzsGXrP3NbrHil7R00N6LC9xRcLnqbAiMXK8fXLvgU2We63M
kK/MevM5TK8qBagQLHtYvS10n4kriXG7ZtlH7F9YyBgnufc7xNL8riqaDasPUVdi
AxJh5tTdtpFxY61EQJc1
=9SGe
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
