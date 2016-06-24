Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48084 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcFXQ5J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:57:09 -0400
Date: Fri, 24 Jun 2016 16:56:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624165657.GL3325@carfax.org.uk>
References: <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAJCQCtR1Bbh4atCu+oo7VpKwN4H14M6-mZrKcCSvszRa=cC13g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VBq/nvTu32OVLBUP"
In-Reply-To: <CAJCQCtR1Bbh4atCu+oo7VpKwN4H14M6-mZrKcCSvszRa=cC13g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VBq/nvTu32OVLBUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 24, 2016 at 10:52:53AM -0600, Chris Murphy wrote:
> On Fri, Jun 24, 2016 at 2:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> >    Checksums are not parity, correct. However, every data block
> > (including, I think, the parity) is checksummed and put into the csum
> > tree.
> 
> I don't see how parity is checksummed. It definitely is not in the
> csum tree. Two file systems, one raid5, one single, each with a single
> identical file:

   It isn't -- I was wrong up there, and corrected myself in a later
message after investigation. (Although in this case, I regard reality
as being at fault ;) ).

   Hugo.

> raid5
>     item 0 key (EXTENT_CSUM EXTENT_CSUM 12009865216) itemoff 16155 itemsize 128
>         extent csum item
> 
> single
> 
>     item 0 key (EXTENT_CSUM EXTENT_CSUM 2168717312) itemoff 16155 itemsize 128
>         extent csum item
> 
> That's the only entry in the csum tree. The raid5 one is not 33.33%
> bigger to account for the extra parity being checksummed.
> 
> Now, if parity is used to reconstruction of data, that data *is*
> checksummed so if it fails checksum after reconstruction the
> information is available to determine it was incorrectly
> reconstructed. The notes in btrfs/raid56.c recognize the possibility
> of parity corruption and how to handle it. But I think that corruption
> is inferred. Maybe the parity csums are in some other metadata item,
> but I don't see how it's in the csum tree.
> 
> 

-- 
Hugo Mills             | Great oxymorons of the world, no. 2:
hugo@... carfax.org.uk | Common Sense
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--VBq/nvTu32OVLBUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXbWZZAAoJEFheFHXiqx3kHVwQAKUoTs4mfnArl/UckBKBLt8s
1TxHFr46zTBqX24pmt1f4/Kv82OKc+XwTyFMkgLEGzWSddqQojoNbrl9uDXSje2F
S/AvtV92hJ9/8P5rX8f32l+DOUp5J9RgyE20/a2ZBF8sB+lheaFuJEuGYiKdWmIB
Tj8n64M8u++uLU5Y6GZB2BlVxCtu39oVx/GzbnAGTFkyE+E/PzUk7zvHibWVYdU3
bD3uELEZmH+wEMNVhLAoNJVpDRzvUzzIfrECkzNVBEdZwKTts7ZOXLIK8jyfra5C
AyiPfKSh6CCf6+RBI22Fqnln4nrYGzCrj6kBM3f2pgy+JUYawiTCnVCJTjb+UAyr
3uwAb7gfb2bW6KSH7BBz4bAe+kF6PmZr7X197pnjqBAz9E3Th1qRrjRIWaGQKD32
7Tn4ljPpTZhRXNtOsN5sN2fkfq/8wWz8VIm6qd7arcHuf9rLJeAyXqEw4UxPm1Au
0/Yiqix0TzSfErlH0WcYzhJ1uX/EQSJLcqUSTb+lTn7OskG7jk1hY7uyQp/6qVZU
85R5KHgFnarJURJ45u4HmQWVsSGQLnfHA7DeHP/R5U6Y71p+lsFsLqeFYLT2jAEm
50pUJshoO1aWVxPO01YcTg7VeqnD2yC442l4v6j3giOlQg3JIPt7lpzEa6ptw3yz
OgFWxPiaBO4BsZwN4apC
=GAYI
-----END PGP SIGNATURE-----

--VBq/nvTu32OVLBUP--
