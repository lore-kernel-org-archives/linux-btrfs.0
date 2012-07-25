Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2GYQCS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 12:02:18 -0400
Message-ID: <1343232376.4060.202.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 07/16] btrfs: nuke write_super from comments
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: cwillu <cwillu@cwillu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Date: Wed, 25 Jul 2012 19:06:16 +0300
In-Reply-To: <CAE5mzvg178UUj4eRmL-VE+=jXSnBJvAUgNPooY3f2ihbwSbBOg@mail.gmail.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1343229134-29487-8-git-send-email-artem.bityutskiy@linux.intel.com>
	 <CAE5mzvg178UUj4eRmL-VE+=jXSnBJvAUgNPooY3f2ihbwSbBOg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-95OoLSqEcB/3SpQeF8Pd"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-95OoLSqEcB/3SpQeF8Pd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-25 at 09:46 -0600, cwillu wrote:
> >         mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
> >         list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->dev=
ices);
> >         list_add(&device->dev_alloc_list,
>=20
> Is the locking still required for approximately the same reason?

I do not know, I assume Chris would check that.

--=20
Best Regards,
Artem Bityutskiy

--=-95OoLSqEcB/3SpQeF8Pd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQEBl4AAoJECmIfjd9wqK0u34P/3TAb3pQdKPPT4OCm0COftc3
nWBYGc5aOQwQFWRCHQRNA31HmZ0bFm9y80mNakBwFZY/l/ylgRIVfStykhJVYp3h
B7O/thSyOivLaNsVH9zpE7gKQbECKlXMlKCr1t/oYMBBWo9MvyrG8x3qQMrCAMQ7
y0xN9x1xalSIuQprFI08RK2I1lVdPXwufhtbDPYMNyQheEc+mh0vchK48aSsg7dw
HsjNroIvHybIDZJ/qTy7pMU4uhHnHdpyXZaxfiX/fdfCFeJiVeW0SAZlqec5gg5n
USqE4iOwmB21qtuHgRzogUQjRSv6NpUvbrCTygR9N7LtVqQIbmlHrLwkJfNA7gdz
oTXpLVjPuBeBXWQNCLomKPEDFBhsLdXpHN2uBbq6CPDkHZ5D4XPrwBJzH7CQIf6Z
BK45mOByZ+fdukEQT0SkYWb7lt2hnBd8hDzc1XzW70Bnf2FW8nfd1WZ7RZQqPtmu
BHWK+o0qvYfUFYbBK7dRG9xWnceD57zucefcDiXLNTTQvHOBxqLHyrzPZDl01NDW
+1upJDkDt/UBQsfEecdh5yqm6jq5/a4ObRtH9VYLrHKy1zvgnTruEqMhnkkiiuON
4FA4vaf59UJw3KGO6FtDfk5HIOUc5Qj7scEAci7ZNWDbLNXK5QoKMsGJhC5HFbGn
aFe18tZqUAR21ENJM7kY
=oXXn
-----END PGP SIGNATURE-----

--=-95OoLSqEcB/3SpQeF8Pd--

