From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 19:51:16 +0600
Message-ID: <20120213195116.26e64e16@natsu>
References: <4F38B8F0.5020506@yahoo.com>
	<4F38BE53.4080204@parallels.com>
	<20120213140921.5a009404@natsu>
	<4F39133F.50908@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iIK6+m6vXa4XsDdoe+L=Kix"; protocol="application/pgp-signature"
Cc: <linux-btrfs@vger.kernel.org>
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F39133F.50908@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/iIK6+m6vXa4XsDdoe+L=Kix
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Feb 2012 22:42:23 +0900
dima <dolenin@parallels.com> wrote:

> > gcc -o /usr/local/bin/nocow nocow.c
> > ln -sf /usr/local/bin/nocow /usr/local/bin/cow

> I don't seem to be able to 'unset' the NOCOW flag.  Looking at the code=20
> I would guess that it is supposed to alternate between 'cow' and 'nocow'=
=20
> states, but the condition
>      printf("Remove NOCOW flag for %s\n", argv[1]);
> never shows for me. What should I do to make it working?
> Maybe it would be nice to have a switch to just check if nocow is set on=
=20
> file without actually changing the flag.

If you place it in /usr/local/bin and also make a symlink "nocow -> cow" as
described in the quoted part above, you can then just run:=20

# cow ./filename

and the program will instead unset the NOCOW flag.

Of course it remains to be a very basic program, I'm not sure if it's worth
developing it further, or to add this to 'btrfs', as Liu Bo in the adjacent
thread said that there are patches to chattr/lsattr for using the COW
attribute.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/iIK6+m6vXa4XsDdoe+L=Kix
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk85FVQACgkQTLKSvz+PZwhPlQCeP8SyMWB7K2WumZBX82EwGH7W
nOMAn1QrbfzH740jMqoXKGBggeQ0vozV
=41FG
-----END PGP SIGNATURE-----

--Sig_/iIK6+m6vXa4XsDdoe+L=Kix--
