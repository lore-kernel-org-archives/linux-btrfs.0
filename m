Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51852 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbE1MXF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 May 2015 08:23:05 -0400
Date: Thu, 28 May 2015 12:23:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: conchur@web.de
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: Metadata size limitations of btrfs
Message-ID: <20150528122302.GK16826@carfax.org.uk>
References: <trinity-4b189d7e-816b-4903-87ba-0cfd9972d4e4-1432801960117@3capp-webde-bs21>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dxRQSzdsN/lOP445"
In-Reply-To: <trinity-4b189d7e-816b-4903-87ba-0cfd9972d4e4-1432801960117@3capp-webde-bs21>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dxRQSzdsN/lOP445
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2015 at 10:32:40AM +0200, conchur@web.de wrote:
> I am working a lot with multiple Linux + OpenWrt builds on top of a btrfs
> filesystem. But I am encountering often that my filesystem is considered
> full by btrfs (beside having more than 40% free space). The only thing
> looking full is the metadata. I've tried to run the balance command with
> -dusage=0 but it didn't help. The metadata size stayed at 10G and was
> filled up to nearly 10G.

   Try with -dusage=5, or with -dlimit=3.

   The kernel should be automatically freeing up completely empty
chunks (i.e. usage=0), so if no chunks are being freed, there's some
data in all of them, and -dusage=0 won't do anything. Increase the
limit slightly (usage=5), or simply tell the balance to pick the
smallest chunks and stop when it's balanced three of them (limit=3),
should do the trick.

> My question is: Can this metadata size limit be changed to allow more
> small files on the filesystem? And if yes, how?

   Free up some of the data allocation with a balance command. You're
doing the right sort of thing, but with a parameter that's probably
not helpful in your situation.

> According to the kernel btrfs documentation, metadata_ratio= is
> currently off by default. So I would guess that this ratio is not
> the thing I should play with.

   Not really.

> Here the requested information of my fs (after removing a lot of build
> directories):
> 
> franzbroetchen#   uname -a
> Linux franzbroetchen 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux
> franzbroetchen#   btrfs --version
> btrfs-progs v4.0
> franzbroetchen#   btrfs fi show
> Label: 'root'  uuid: 57fe2100-0510-11e5-977e-0021ccb48233
>         Total devices 1 FS bytes used 182.55GiB
>         devid    1 size 467.68GiB used 206.06GiB path /dev/mapper/franzbroetchen_vg-root

   Hmm. You shouldn't be seeing any kind of ENOSPC with this
allocation -- there's plenty of space for it to allocate from. I think
you've hit the horrible undiagnosed bug which prevents the FS from
allocating more space. I know josef was looking at this one but kept
getting distracted by data-corruption issues. He may be able to
comment more on it.

   Given the information above, I'm not sure that the usage=5 or
limit=3 suggestion I made above will have any benefit for you.

   Hugo.

> btrfs-progs v4.0
> franzbroetchen#   btrfs fi df /         
> Data, single: total=190.00GiB, used=176.47GiB
> System, DUP: total=32.00MiB, used=48.00KiB
> Metadata, DUP: total=8.00GiB, used=6.08GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

-- 
Hugo Mills             | emacs: Eighty Megabytes And Constantly Swapping.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dxRQSzdsN/lOP445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZwilAAoJEFheFHXiqx3k8s8P/0LbI73sw20saXDE3O28+vHL
9MKfdSgYsO1htVBFrAFxjP09Svs8mfEFVpRZVdq61FJebV8y6fM4qk2iLTlg5uzR
JxSyg7mDXGdBOtE1gHv2yRunRWskf5wfL7aBHK8uQF+SQcBDP+qGzt3OC2F8ifDZ
EVvoiAafekpI3stO1TIyyb+gC6GFM4SdlEDiF8MJtgWXWIwGgoLOPfZSxun1dQmL
vsyJv4igBPogpEF33rC4PXFNbkmQHO7VKd4Fe0sYyofQ/Fe5V+pGaxoBZx1yo4sk
MiSKH/QnTkSCh7BagHR0UH7NgYQuqilo8ZzJ3E0oB2QaRDIl6wfIVa/4Q5Etxtzl
fMxI4+uK9Gs+WIK5dCjD8FOblP9QfYIsElZpVzasYkdzamm3heXXDLcMadrnUIB6
zuJ29MNyF9mXRj6lIjbjWWVDhjh/HoATbuSBudLml2ppW0Z8Itgin0r7qiW+KQ+W
u78wXBh5bHZqfTL8mLnVrp+xUGRnoPidyQss/WUbQK1It858QvnQdccPhVmSU0mU
R9tIEFgHHNF41x58C8uCMXY3IOq3fKer8w3NJw750H5fxuxSY5otJDy83ISLmXSc
3k1KGmv8cViVWldO+rV1P50+/4f0QwKsSFTtaop8Zq/+JzYT9Kni/RR7H5/KdvZN
U91IaQ2M/FoN1nKXGhPW
=8Jz7
-----END PGP SIGNATURE-----

--dxRQSzdsN/lOP445--
