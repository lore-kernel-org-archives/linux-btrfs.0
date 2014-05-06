Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48184 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934579AbaEFK7K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 06:59:10 -0400
Date: Tue, 6 May 2014 11:59:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
Message-ID: <20140506105907.GV24298@carfax.org.uk>
References: <5368BC62.2020701@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Avw2VvEbzfULB0h1"
In-Reply-To: <5368BC62.2020701@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Avw2VvEbzfULB0h1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 12:41:38PM +0200, Hendrik Siedelmann wrote:
> Hello all!
> 
> I would like to use btrfs (or anyting else actually) to maximize raid0
> performance. Basically I have a relatively constant stream of data that
> simply has to be written out to disk. So my question is, how is the block
> allocator deciding on which device to write, can this decision be dynamic
> and could it incorporate timing/troughput decisions? I'm willing to write
> code, I just have no clue as to how this works right now. I read somewhere
> that the decision is based on free space, is this still true?

   For (current) RAID-0 allocation, the block group allocator will use
as many chunks as there are devices with free space (down to a minimum
of 2). Data is then striped across those chunks in 64 KiB stripes.
Thus, the first block group will be N GiB of usable space, striped
across N devices.

   There's a second level of allocation (which I haven't looked at at
all), which is how the FS decides where to put data within the
allocated block groups. I think it will almost certainly be beneficial
in your case to use prealloc extents, which will turn your continuous
write into large contiguous sections of striping.

   I would recommend thoroughly benchmarking your application with the
FS first though, just to see how it's going to behave for you.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Ceci n'est pas une pipe:  | ---                   

--Avw2VvEbzfULB0h1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2jAelheFHXiqx3kAQJqrhAAqg/8NgXio0WWB2rfVUpUYTjEcNhTNEEY
daUl+SGlmc5LmVtPTNosdteBmOg+pjxpgJ8fUib4ilMz6iYO6MCmqAo1osxa3w51
C6o8oQzLn6x1tqd/lwnrcXR8atrZ7zvddhAVulAFW8j7MSoD69jwU1d1x0eqfmKD
HnfPtNKn4MkuVTp8336LPeq35AEVIo47531dfq4lSFXDnKdQe3fsF7QKmMe+W6GT
dMFyWKd+I4RGYk5N16+9GAhh/VRgzrY4w/ndYIPzCUqsKFbFU1hR+LNGC02yu/rk
TWCNu3f+Hg3rg/P4MiNEWAQYvniA+qhLE3JUTqI0KnjQgy2nY+35ZjJ+aPlWhHbf
NtCEdG8O4ORCX1WkadbrAQSzt6BW4+TbsQ68Ez94pQoljc/EUXONzyzQXawJ1fhN
Po8d9gq43uKRUILOE5Oq7EPWm4iJLA5EhwXpFmFUY6/bMvNp+H4JUi1kL0WfwnRu
0XkPrtXT+S/HARyIZqZg+1b4MTunkzqbIT8AdpgHTsgVka4Hku3RQ3av/I477LjY
NRC6Ok673GWC9FjTmNxWePg0DFE3lmmn67DLZe9FnoL1pPcb0/DjRZ0MEdy1j/JR
iEUF68TZlvgIDgYJkwpOaRv7+h+KUlbTPVA0SznM+73RoLHT0xa+yCnD6bR4q/Sj
fD82LcrNz04=
=7tRj
-----END PGP SIGNATURE-----

--Avw2VvEbzfULB0h1--
