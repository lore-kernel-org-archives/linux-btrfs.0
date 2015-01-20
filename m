Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41561 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbATXdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 18:33:39 -0500
Date: Tue, 20 Jan 2015 23:33:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs convert running out of space
Message-ID: <20150120233337.GA1654@carfax.org.uk>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
 <CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
 <CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
 <CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
 <CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
In-Reply-To: <CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 02:41:13PM -0700, Chris Murphy wrote:
> On Tue, Jan 20, 2015 at 2:25 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> > Yeah, I have updated btrfs-progs to 3.18. While it is plausible that
> > the bug was created by using 3.12, none of the behavior has changed
> > now I'm using 3.18.
> >
> > I was experimenting with -dusage values to try and process the blocks
> > in a different order to see if that made any difference. It did let me
> > get through more of the file system before erroring but now it errors
> > on the first block it tries.
> >
> > Using "btrfs balance start -v -dusage=2 /data" cleans up all the empty
> > block groups that "btrfs balance start -v
> > -dconvert=raid1,soft,limit=10 /data" creates. I'm using limit=10 to
> > speed up testing, I have tried without it and it just takes longer to
> > complete and the whole time the RAID1 total sky rockets while the
> > RAID1 used doesn't move.
> 
> Sounds like during the conversion, no longer needed raid1 chunks
> aren't quickly deallocated so they can be used as raid10 chunks.
> There's been some work on this in the 3.19 kernel, it might be worth
> testing.
> 
> I'm not sure if the significance of the change from flags 17 to flags
> 65 right before the enospc errors. The spacing between flags 17 chunks
> is exactly 1GB whereas the spacing between the values reported for
> flags 65 vary a lot, one is a 12GB gap.

   flags 17 is RAID-1 data. 65 is RAID-10 data. If you're converting,
I think that's the type *before* it gets converted. The values for
block group type are in the ctree.h header (kernel and userspace),
BTRFS_BLOCK_GROUP_*.

   Hugo.

-- 
Hugo Mills             | Putting U back in Honor, Valor, and Trth.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUvuXQAAoJEFheFHXiqx3kRGQP/RWfQDuT52htTNTwKitEZPLY
mCZunjhc4wOW0vqRsbOfj6RQDR6DJHB76qlaPD4YdINREoXmxi0fugftE5en0P7B
CNouwJaR7ip56It9sK8YAFSUCKeYmtEVsSZPR1PGs2M/FkGKps0XYefyioP7CEZ5
YFiGMM6nKi3pR5dhvg6C3PLKA81MxhqDio8Z0zVQ727M50KJ3LQgpCjm9ZFUrZkY
eMMMQ3gqTD6GRpsHE7ZQzlqvQc398+dJwJ19C5HwrvwjBiVFvIxViON6sLpVIaIP
trx6RNDCV2s+CObfznh6FWxZh1dK+MAKogPAh7dxDCGozXaAqex/KPyDEkh/AeWa
i6xalxfmF5FE2gHLIR4/QM8CuK5dJ4VJNLrPrtE++Lq32D8KxMeKOi6FoOQnvHC2
LcJ41TmxzLww9sMwmWE9Ij9Q9ZlPg8KIHyyEH6Zzi/Ib7zTnWOj65Yf4hTssG2cn
b/Stbs3bMplXv1f+mgdBwCkDEfd8lIAKzXHixE0Xr8gBg4GIGtYKPmKfKZpopf4l
lCydJVe0dYqAcI6DSfApe4aa1MoMZRTrZUX5/W4AATAqdJShMhQX5Sz82+cm7SMQ
nD8RrQxbWx93tKsisauhiK0D5Rrkalrf6y/SzzUDhcYOd0ujjWxa3yguz5aR76Ui
BGKvTC5vfoiPvaIYrvjq
=4GQ8
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
