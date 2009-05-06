From: Michael Raskin <7c6f434c@mail.ru>
Subject: Re: [MISFEATURE] Size reporting on small devices
Date: Thu, 07 May 2009 00:27:23 +0400
Message-ID: <4A01F2AB.5010608@mail.ru>
References: <4A01C089.2080201@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A01C089.2080201@mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Raskin wrote:
> Maybe df -i could be useful until metadata/data split is flexible? Is
> there any way to inspect the metadata filling up and change the split?

By the way, resizing down and then up seems to help - at least I was
able to create more files..
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKAfKiAAoJEE6tnN0aWvw3/N8IAKyMasInfx1PVP1SfvHUe2eW
walrjCq/2y90uqxNyHEKET7aBeqmyZsrGp4t/Hn1s3iLxYVY9iMJvTIjfOsy3yWu
5ynVbncQehykjl5uYvy+cnPDDvradzoCqVhnz1X6TymKoL0B0EVlAA4VBQ0Kfhzf
1Ukbuoq1LxUKqhtPnF5o/1f09rMj8QgwfUlXyE1H37BJr5SeG4Q/1MlEjApa7kPR
6MvJ/MRmzi9uDJKKrjDp1r3sv6pKqFSaBrG1eofFMRWtdDpwYeBmp4QU8a/ff27E
1gsz0dzNXC4aTQhQiOgQnVwvfGeF7eaDQjwRjqn1JBz+OGcfSpTkNfwMGM858OE=
=iTqb
-----END PGP SIGNATURE-----
