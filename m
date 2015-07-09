Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49318 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbGIWGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 18:06:11 -0400
Date: Thu, 9 Jul 2015 22:06:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Concurrent write access
Message-ID: <20150709220609.GI10539@carfax.org.uk>
References: <2035607.hrq9oNetle@discus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
In-Reply-To: <2035607.hrq9oNetle@discus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 09, 2015 at 11:34:40PM +0200, Wolfgang Mader wrote:
> Hi,

> I have a btrfs raid10 which is connected to a server hosting
> multiple virtual machine. Does btrfs support connecting the same
> subvolumes of the same raid to multiple virtual machines for
> concurrent read and write? The situation would be the same as, say,
> mounting user homes from the same nfs share on different machines.

   It'll depend on the protocol you use to make the subvolumes visible
within the VMs.

   btrfs subvolumes aren't block devices, so that rules out most of
the usual approaches. However, there are two methods I've used which I
can confirm will work well: NFS and 9p.

   NFS will work as a root filesystem, and will work with any
host/guest, as long as there's a network connection between the two.
9p is, at least in theory, faster (particularly with virtio), but
won't let you boot with the 9p device as your root FS. You'll need
virtualiser support if you want to run a virtio 9p -- I know qemu/kvm
supports this; I don't know if anything else supports it.

   You can probably use Samba/CIFS as well. It'll be slower than the
virtualised 9p, and not be able to host a root filesystem. I haven't
tried this one, because Samba and I get on like a house on fire(*).

   Hugo.

(*) Screaming, shouting, people running away, emergency services.

-- 
Hugo Mills             | Alert status mauve ocelot: Slight chance of
hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVnvBRAAoJEFheFHXiqx3kgZcP/34oJatRO32ct/swvBDXTtsO
wyT788UAe15oAi5hYb0KxtOjMyPJ0kZ2x5NlqoItQP5wQJJS6v3r7D1Y7COWuKTr
a+h8XaGxJd3OJv/8QuX6STnosgRYNzRS4RgZBkeK114Nd6kR3dZgnQy+v0AIKAeA
WRAq2myUN5eDEFyCy54FAlP/F/LRrlDYuYq2OJ9XZnltixBz+3vo1Q0A5QwvxhH8
qTRsFX0THTGPcVGJOlHz9Q5UsPSt3ZXwg5OTqT+kr9RZVp+6/XA/D91MaNsFev44
j9SNFGO/2B9U7fpjlisa3xG/gpUCd28ef6ndydPcYfgn+E10WbZHESdBOKA3oNbE
Ex3mGYexWLKbj9BGHyT5a/MhDXMoMnVULtR9uh/MRVHbm8Bof0wtKfn2t+Q9EajB
3R7PqwJeiq2wcsRXDN6zDleEPX5A1bKE11XHyzmln9AFhcEnPB+fn8xaUaIAH3y1
Tg8CeMiwvIyTrOYr71FvvBbxh6htlKkm53iMSr06HJfk4XjRwC4xkElQ9XKrIdLJ
jJZhRYJ60Ogcie0e20S/uFkFcbfdFmvnse4TYrBv1P2BOoY5ad7ywni4nSQF977F
y2ik0yobL9VaHY8+J1ZjPPYwJChVKxXLKL6GVYnsRy0DW7KXtS2BM3dPribx0ADp
e4vYbF11kBvMoK4bdcYU
=UwoQ
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
