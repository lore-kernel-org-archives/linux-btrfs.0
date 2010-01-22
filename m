From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 22 Jan 2010 09:23:57 +0100
Message-ID: <201001220923.57416@fortytwo.ch>
References: <201001212029.26681.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6518130.A9VlM6r2ph";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001212029.26681.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart6518130.A9VlM6r2ph
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

I like this very much, I found myself wondering which program did what agai=
n=20
and again when I started to use btrfs, too.

On Thursday 21 January 2010 20.29:26 Goffredo Baroncelli wrote:
>        btrfs resize|-r [+/-]<newsize>[gkm]|max <filesystem>
>                Resize the file system. If 'max' is passed, the filesystem
>                will occupe all available space on the device.

Switch the arguments, and if the 2nd is missing do what you propose for=20
"max".

>         btrfs scan|-S [<device> [<device>..]
>                 Scan all device for or the passed device for a btrfs
> filesystem.

This is the only that *migt* be sensible to have as a separate tool, if=20
"btrfs" ends up requiring additional runtime dependencies: the scan utility=
=20
should be small since it will need to be included in the initrd.

=2D-=20
Protect your privacy - encrypt your email: http://fortytwo.ch/gpg/intro

--nextPart6518130.A9VlM6r2ph
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktZYJ1gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6sEIAnRwepZA/g44Q2MAqZcYOxTnY
9pNsAJ9IxDgprjuGXPDxRGCcmQIN7pLaXQ==
=jWNr
-----END PGP SIGNATURE-----

--nextPart6518130.A9VlM6r2ph--
