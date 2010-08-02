From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Number of hard links limit
Date: Mon, 2 Aug 2010 14:40:46 +0300
Message-ID: <20100802114046.GA29926@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There's been discussion before on this list on the very small number
of hard links supported by btrfs.[1][2] In those threads, an often
asked question has been if there's a real world use case the limit
breaks. Also it has been pointed out that a fix for this would need a
disk format change.

As discussed in bug #15762 [3], there are certainly real-world use
cases this limitation breaks. I don't usually like to bring up my pet
bugs on mailing lists, and I'm sorry for doing it here, but if it
indeed needs a disk format change, I think this should be considered
before the format is set in stone. I won't personally lose my sleep if
this is not fixed - I can use other filesystems for backuppc and other
similar systems, although I'd be disappointed to see a production
backup system unexpectedly fail because of this - just that I think
it's better to think about this before things are set in stone.

I'd venture to guess that if I have hit this limit with the very small
amount of btrfs use I've done, thousands of others are going to hit it
when btrfs is the default filesystem of distributions.

	Sami


[1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/4589
[2] http://thread.gmane.org/gmane.comp.file-systems.btrfs/3427
[3] https://bugzilla.kernel.org/show_bug.cgi?id=15762

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJMVq69AAoJEKLT589SE0a0UBcP/RGVnbcXXeHEW2uDl4t+5W6u
6VpFSl4hacwX95r61/+Yf7uOzG2sZIvvuOBaerHMEayx2/QsrtSNXYmMQWKt8GL1
E4fkNixN5ZEfIi0HCiE9c6uLx1R+m09FOOmnwmVGlmioOeo3Sh2rdtkgQpEZcua8
ZyyqvFrkIGoKoT+fLNTyV6qiKMnNler6E5OGCvv8j8FKtyh6TeORohNJGSY8J/PI
fnXqTmSO5u50ctxx3RSo1+Y+dfPJRpp+JggA3BBMDiJ/sm+Em80CrGUCnPmClKNu
fBhQmZdhDCV0jujfPuwg1uaekZTYWY0E/ZfAYo72M48ktlbr+CJIJuRB4NypZusP
vQBhzA0JoNDhCreDBVjFX5qAGUWETFOvyjJyTnE3EHPGKt7VJw32afpNIKhTA8n2
QOby4RJff5II8SwwMbNm3A2ZfBG8mW0RrFn7Xm+q5j08p7QnM0TG/YF7vSI7Cu/m
8I4vmjHk+yk7Wkf6lRIPWicFlVtUb6oYdThx9GtH/qV3yGsrvaxrekobG8le4Hda
twMcUcrWiWZLvJroqt38NEybADmEgDRuqSP0EMytRA5p9VGrdgREUlNkkZJHBz2w
0cuWL00azhvtQql8XRVBj8BqE6hkDCq2AXllmceAnQSzUIYKkZ5Y1ty3yN8M9VJF
NhJ49BaPld/0aTaJaNDL
=vAFw
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
