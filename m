Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53564 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaGQUNI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 16:13:08 -0400
Received: from [192.168.0.6] (unknown [81.106.117.111])
	by mail.messagingengine.com (Postfix) with ESMTPA id 3B670C007AC
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 16:13:04 -0400 (EDT)
Message-ID: <1405627978.2630.39.camel@s-Air>
Subject: Questions on incremental backups
From: Sam Bull <sam.hacking@sent.com>
To: linux-btrfs@vger.kernel.org
Date: Thu, 17 Jul 2014 21:12:58 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/fnJtaJ6CQeweK7D4W1b"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-/fnJtaJ6CQeweK7D4W1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've a couple of questions on incremental backups. I've read the wiki
page, and would like to confirm my understanding of some features, and
also see if other features are possible that are not mentioned. I'm
looking to replace my existing backup solution, and hoping to match the
features I currently use, and go a little beyond.

=3D=3D=3D Daily snapshot =3D=3D=3D

So, if I understand correctly, I can make a daily snapshot of my
filesystem with very little overhead. Then these can later be synced
efficiently to another system (only syncing the differences), so I can
backup regularly over the internet to my server, and also to an external
HDD. After syncing, I can delete the snapshots (other than the trailing
one needed for the next backup).

In this way I can keep a constant stream of daily backups even when
offline, and simply sync them next time I am online before deleting them
locally.

=3D=3D=3D Ignore directories =3D=3D=3D

Due to storage limitations on my server, is it possible to ignore
certain directories? For example, ignoring the folder that stores all my
games, as this could be rather large, and the contents can easily be
re-downloaded. The instructions involve subvolumes, so maybe it's
possible to ignore a subvolume when syncing?

If that is possible, then is it also possible to have a separate backup
that does include the ignored directory? For example, having the smaller
sync to the storage-limited server, but having a full sync to an
external HDD.

=3D=3D=3D Display backups =3D=3D=3D

Is it possible to view the contents of all backups? So, the expected
interface would be something like a tree of all files from across all
snapshots. Any files that are not present in the latest snapshot would
be greyed out to show they have been deleted. Selecting a file would
show a list of versions of the file, with one version for each snapshot
the file has been modified in.

As long as I can get access to this information, maybe some kind of diff
between snapshots, I'm willing to write the actual software to display
this interface. (I suppose even if it's not supported, I could crawl
through the filesystems and generate some kind of database, but that
sounds like a painful process.)

=3D=3D=3D Merge snapshots down =3D=3D=3D

Is there some way to merge snapshots down? So, I could merge the last
week of daily snapshots into a single weekly snapshot. The new snapshot
should include all files across all the snapshots (even if deleted in
some of the snapshots), and include just the latest version of each
file.

This way, I'd like to maintain daily snapshots, which can be regularly
merged down into weekly snapshots, and then into monthly snapshots, and
then finally into yearly snapshots.


And, finally, there's no problem in deleting old snapshots? I'm assuming
any data from these snapshots used by other snapshots will still be
referenced by the other snapshots, and thus be retained, so nothing will
break?

--=-/fnJtaJ6CQeweK7D4W1b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlPILk8ACgkQX+kozZYmzitg7ACgwNC+kTsDfQfIqZJn2Q+1Do3J
EUgAoIZqJ3oWAM9/rwa9GTSJpUf+NKuN
=pGZn
-----END PGP SIGNATURE-----

--=-/fnJtaJ6CQeweK7D4W1b--

