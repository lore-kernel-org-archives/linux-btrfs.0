Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49759 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2I1UNj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 16:13:39 -0400
Date: Fri, 28 Sep 2012 21:13:32 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, kreijack@libero.it,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
Message-ID: <20120928201332.GF6136@carfax.org.uk>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
 <5064B96B.7060502@libero.it>
 <5064BEEB.1090707@libero.it>
 <20120928091759.6d096016@natsu>
 <20120928085840.GE6136@carfax.org.uk>
 <5065DDF4.8010907@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
In-Reply-To: <5065DDF4.8010907@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Goffredo,

On Fri, Sep 28, 2012 at 07:27:16PM +0200, Goffredo Baroncelli wrote:
> On 09/28/2012 10:58 AM, Hugo Mills wrote:
> >On Fri, Sep 28, 2012 at 09:17:59AM +0600, Roman Mamedov wrote:
> >>On Thu, 27 Sep 2012 23:02:35 +0200
> >>Goffredo Baroncelli<kreijack@libero.it>  wrote:
> >>
> [...]
[...]
> >>>Details:
> >>>     Chunk-type    Mode       Allocated        Used        Free
> >>>     ----------    ----       ---------    --------   ---------
[...]
> >>>     Data          Single        4.01GB      2.16GB      1.87GB
> >>>     System        DUP          16.00MB      4.00KB      7.99MB
> >>>     System        Single        4.00MB        0.00      4.00MB
> >>>     Metadata      DUP           6.00GB    429.16MB      2.57GB
> >>>     Metadata      Single        8.00MB        0.00      8.00MB
> >
> >    I think we need another column here, to indicate how much *actual*
> >disk space is used by each row, so adding up that column will give you
> >the "Allocated" value in the first clause. I think that's probably the
> >biggest cause of confusion. "Raw alloc.", maybe, and use the term
> >"raw" somewhere in the first clause to hammer the point home.
> 
> I think that there is a little misunderstanding. We are saying the
> same thing. Only I call "allocated" what you call "raw alloc"

   OK, I think we need both. We need to indicate somewhere (in the
"Details" section in my version) both the total number of bits of rust
used and the amount of data stored. It's not good to ask the user to
know that they need to multiply/divide by two for certain storage
modes (or even more complicated for RAID-5/6). Somewhere, they will
find that values change twice as fast as they expect (or at half the
speed), and that causes problems. We need to find some way of
connecting the two in a way that makes it reasonably obvious where the
figures come from..

> >    My only concern here is that we're a bit too close to the existing
> >solution (albeit merging the two sets of output), which has proven
> >itself over time to be somewhat confusing. I think the Alloc_Raw
> >column is the minimum necessary to link the two in some easily
> >determinable way. Adding totals to Alloc_Raw, and Used (but not Free
> >or Alloc) would help, I think. I don't think it's useful to add them
> >to the Free or Alloc columns, because those figures change as the FS
> >allocates chunks, and we'll end up with people querying the fact that
> >the total of Free doesn't add up to any of the figures in the
> >summary.
> >
> >    Say, something like this:
> >
> >Summary_(Raw):
> >   Total:                    135.00 GiB
> >   Allocated:            	 10.51 GiB
> >   Unallocated:            	124.49 GiB
> >   Free_(Estimated):          86.56 GiB
> >   Average_disk_efficiency:      62 %
> >
> >Details:
> >   Chunk_type  Mode    Alloc_Raw  Alloc      Used        Free
> >   Data        Single   4.01 GiB   4.01 GiB    2.16 GiB  1.87 GiB
> >   System      DUP     32.00 MiB  16.00 MiB    4.00 KiB  7.99 MiB
> >   System      Single   4.00 MiB   4.00 MiB    0.00 B    4.00 MiB
> >   Metadata    DUP     12.00 GiB   6.00 GiB  429.16 MiB  2.57 GiB
> >   Metadata    Single   8.00 MiB   8.00 MiB    0.00 B    8.00 MiB
> >   Total               16.04 GiB               2.59 GiB
> >
> >    The other thing is that there should be a switch (or possibly two)
> >to give highly machine-readable versions of the output -- no units
> >(units as bytes by default, with other units settable by a switch),
> >tab-separated, possibly a different option for each of the above
> >output clauses.
> I fully Agree. But my first concern was about the wording (if fact
> even though we are saying the same thing you didn't understood me).
> 
> Let me propose the following:
> 
> Summary:
>    Disk_size:     	         135.00 GiB
>    Disk_allocated:          	  10.51 GiB
>    Disk_unallocated:		 124.49 GiB
>    Used:			   2.59 GiB
>    Free_(Estimated):         	  91.93 GiB
>    Average_disk_efficiency:          70 %
> 
> Details:
>       Chunk-type    Mode     Disk-allocated     Used   Available
>       Data          Single        4.01GB      2.16GB      1.87GB
>       System        DUP          16.00MB      4.00KB      7.99MB
>       System        Single        4.00MB        0.00      4.00MB
>       Metadata      DUP           6.00GB    429.16MB      2.57GB
>       Metadata      Single        8.00MB        0.00      8.00MB
> 
> 
> 
> Where:
>   Disk-allocated	-> space used on the disk by the chunk
>   Disk-size		-> size of the disk
>   Disk-unallocated	-> disk not used in any chunk
>   Used 			-> space used by the files/metadata

   The problem here is that if you're using raw storage, the Used
value in the second stanza grows twice as fast as the user expects. I
think this second stanza should at minimum include the "cooked" values
used in btrfs fi df, because those reflect the user's experience. Then
adding [some of?] the raw values you've got here to help connect the
values to the raw data in the first stanza of output.

   As I said above, it's the connection between "I wrote a 1GiB file
to my filesystem" and "why have my numbers increased/decreased by
2GiB(*)/1.2GiB(**)?"

(*) RAID-1
(**) RAID-5-ish

>   Available 		-> space available in the *allocated* chunk
>   Free_(Estimated) 	-> Theoretical free space for files (Disk_size
> 			   * Average_disk_efficiency - Used)
> >
> >    Ultimately, I think the bikeshed should be turquoise.
> ? :-)

   http://www.freebsd.org/doc/en_US.ISO8859-1/books/faq/misc.html#bikeshed-painting

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- And what rough beast,  its hour come round at last / slouches ---  
                     towards Bethlehem,  to be born?                     

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGYE7L9z9OVl50rAAQKRTA//a7oh6rTnwhTAIU8Qs3Dx+DUmGOlzmzKQ
vmMxgDSfdu/t70leB6KLDvtFVKpn0BM97fiZnBkU/b9AWx1IZcbZVHHn4tITfho9
0+yLcZehBGX1DK+nnkexWo2z+Ct/uBnMqFLbYCgvwRilzTLRE5MdNwzwwVZl4x9V
buZ+maMvSa7cmT0cGNhW0VY6iS5e0bBZ/ChADJCmLvDScGYoDVbNG1zwXc5i7T57
qRH2B+mdq8WGuWjI52ignP6RmC4B/tyaLSn/654zrUM9dgx8fYifylJ8bbmHkRlS
ukMAxOj3LxFImaCbzo3Me/x02vpE7ZXxenfB3D8z5X5tDTlHnMdwYJ9JjRPcVIth
o0owAjEoJF4h0UeNtiY+zUsk4uV8TnOSisyWXiUM/EmnDVO0DNZEzz4OoNKe72xm
F6h+FNFrZrX7iX8qAHhuiqV8mkrqTUOC036+5WzBUk6HfS9rwxNephqFfg2oQnD7
x0MWWacgUxst17Rhoef0FtrKj78SmvZKf1rJ3cVxPNhX0DxtCNKwD6NKzm8w6Dj4
vZrN1ManNUkHAy4G0xqAVBD+P+TCT7ag29LiEoPScG7C7D/FL0fVhztc29m1+qDy
B1R/g7OUEcYITnBAnAeHiI4aCtqBmQ+cMBhMwGKpJBV8RyvkzcUw/zgZMTYW4bBM
dUOpP2sz2OY=
=byU1
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
