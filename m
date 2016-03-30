Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-pro1.mana.pf ([202.3.225.198]:39631 "EHLO
	smtp-pro1.mana.pf" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbcC3QE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 12:04:56 -0400
Subject: Re: btrfs: page allocation failure
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <ndfmob$ed5$1@ger.gmane.org>
 <20160330135051.GC27917@twin.jikos.cz>
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Message-ID: <56FBF76C.7030106@sysnux.pf>
Date: Wed, 30 Mar 2016 05:57:32 -1000
MIME-Version: 1.0
In-Reply-To: <20160330135051.GC27917@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NnPqNw6kfk5KRsTqhW2WGQ6WPHIfomLSq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NnPqNw6kfk5KRsTqhW2WGQ6WPHIfomLSq
Content-Type: multipart/mixed; boundary="8I8L5xCDT2xBXiUTXXfMl21hLQl2IVUIj"
From: Jean-Denis Girard <jd.girard@sysnux.pf>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <56FBF76C.7030106@sysnux.pf>
Subject: Re: btrfs: page allocation failure
References: <ndfmob$ed5$1@ger.gmane.org>
 <20160330135051.GC27917@twin.jikos.cz>
In-Reply-To: <20160330135051.GC27917@twin.jikos.cz>

--8I8L5xCDT2xBXiUTXXfMl21hLQl2IVUIj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi David,


Le 30/03/2016 03:50, David Sterba a =E9crit :
> On Tue, Mar 29, 2016 at 07:04:10PM -1000, Jean-Denis Girard wrote:
>>
>> [ 3734.651439] btrfs: page allocation failure: order:4, mode:0x2404040=

>=20
> Order 4 is 64k, and most probably it's the allocation of a nodesize, th=
e
> IP offset in the function is close to beginning, there are two other
> allocations that are served from the slab.
>=20
> So do you have a filesystem with a 64k nodesize? Just checking.

Yes, I do. Both the main filesystem and the backup filesystem were
created with btrfs -4.4 using: mkfs.btrfs --nodesize 64K ...

> The memory is fragmented so a contiguous 64k cannot be found, what we
> can do is a fallback to vmalloc, that can assemble th 64k memory from
> smaller pages. I'll send a patch.

Great!


Thanks,
--=20
Jean-Denis Girard

SysNux                Syst=E8mes   Linux   en   Polyn=E9sie   fran=E7aise=

http://www.sysnux.pf/ T=E9l: +689 40.50.10.40 / GSM: +689 87.79.75.27


--8I8L5xCDT2xBXiUTXXfMl21hLQl2IVUIj--

--NnPqNw6kfk5KRsTqhW2WGQ6WPHIfomLSq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlb792wACgkQuu7Rv+oOo/gHZgCeMfFSYqq7NpAAujJVdYFriIH/
23sAnRjs/XMTPqo+epnrbOpg8jRlOqza
=z9zk
-----END PGP SIGNATURE-----

--NnPqNw6kfk5KRsTqhW2WGQ6WPHIfomLSq--
