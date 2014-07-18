Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59616 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932995AbaGRM5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 08:57:05 -0400
Message-ID: <1405688218.3085.16.camel@s-Air>
Subject: Re: Questions on incremental backups
From: Sam Bull <sam.hacking@sent.com>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Date: Fri, 18 Jul 2014 13:56:58 +0100
In-Reply-To: <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
References: <1405627978.2630.39.camel@s-Air>
	 <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fxAZKq/udPBDXu5EUU+i"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-fxAZKq/udPBDXu5EUU+i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the replies, I think that's most of the questions answered.
I'll not bother backing up any VMs, as they won't contain anything worth
backing up. Can anybody answer the last couple of remaining questions?

On ven, 2014-07-18 at 14:35 +1000, Russell Coker wrote:
> Ignoring directories in send/recv is done by subvol. Even if you use
> rsync it's a good idea to have different subvols for directory trees
> with different backup requirements.

So, an inner subvol won't be backed up? If I wanted a full backup, I
would presumably get snapshots of each subvol separately, right?

> Displaying backups is an issue of backup software. It is above the
> level that BTRFS development touches. While people here can probably
> offer generic advice on backup software it's not the topic of the
> list.

As said, I don't mind developing the software. But, is the required
information easily available? Is there a way to get a diff, something
like a list of changed/added/removed files between snapshots?

If I want to create a backup view, I could start with just a file view
of the most recent snapshot, but is there a way I can quickly get a list
of additional files in the other snapshots that are not present in the
most recent one (files that have been deleted)?



And, finally, nobody has mentioned on the possibility of merging
multiple snapshots into a single snapshot. Would this be possible, to
create a snapshot that contains the most recent version of each file
present across all of the snapshots (including files which may be
present in only one of the snapshots)?

--=-fxAZKq/udPBDXu5EUU+i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlPJGZ8ACgkQX+kozZYmzisf6wCfVb+IPf82fRgv9m/+JYhC+Zkw
NzwAni8ihd0dJo43+cQbp8l7cAnmCbgr
=lSpk
-----END PGP SIGNATURE-----

--=-fxAZKq/udPBDXu5EUU+i--

