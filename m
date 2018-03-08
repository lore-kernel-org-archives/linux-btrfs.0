Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965761AbeCHFzL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 00:55:11 -0500
Subject: Re: [PATCH 10/20] btrfs-progs: help: convert ints used as bools to
 bool
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-11-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5914f26b-ccf0-8225-e802-575978ef2677@gmx.com>
Date: Thu, 8 Mar 2018 13:55:00 +0800
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-11-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mQMHvWvChGqbaA7KyiVtFGpnU2dPe4oCP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mQMHvWvChGqbaA7KyiVtFGpnU2dPe4oCP
Content-Type: multipart/mixed; boundary="1rBxj2RyLohIa2e7Rw9LnME7GTxYQt31d";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <5914f26b-ccf0-8225-e802-575978ef2677@gmx.com>
Subject: Re: [PATCH 10/20] btrfs-progs: help: convert ints used as bools to
 bool
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-11-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-11-jeffm@suse.com>

--1rBxj2RyLohIa2e7Rw9LnME7GTxYQt31d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> We use an int for 'full', 'all', and 'err' when we really mean a boolea=
n.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  btrfs.c | 14 +++++++-------
>  help.c  | 25 +++++++++++++------------
>  help.h  |  4 ++--
>  3 files changed, 22 insertions(+), 21 deletions(-)
>=20
> diff --git a/btrfs.c b/btrfs.c
> index 2d39f2ce..fec1a135 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -109,7 +109,7 @@ static void handle_help_options_next_level(const st=
ruct cmd_struct *cmd,
>  			argv++;
>  			help_command_group(cmd->next, argc, argv);
>  		} else {
> -			usage_command(cmd, 1, 0);
> +			usage_command(cmd, true, false);
>  		}
> =20
>  		exit(0);
> @@ -125,7 +125,7 @@ int handle_command_group(const struct cmd_group *gr=
p, int argc,
>  	argc--;
>  	argv++;
>  	if (argc < 1) {
> -		usage_command_group(grp, 0, 0);
> +		usage_command_group(grp, false, false);
>  		exit(1);
>  	}
> =20
> @@ -212,20 +212,20 @@ static int handle_global_options(int argc, char *=
*argv)
> =20
>  void handle_special_globals(int shift, int argc, char **argv)
>  {
> -	int has_help =3D 0;
> -	int has_full =3D 0;
> +	bool has_help =3D false;
> +	bool has_full =3D false;
>  	int i;
> =20
>  	for (i =3D 0; i < shift; i++) {
>  		if (strcmp(argv[i], "--help") =3D=3D 0)
> -			has_help =3D 1;
> +			has_help =3D true;
>  		else if (strcmp(argv[i], "--full") =3D=3D 0)
> -			has_full =3D 1;
> +			has_full =3D true;
>  	}
> =20
>  	if (has_help) {
>  		if (has_full)
> -			usage_command_group(&btrfs_cmd_group, 1, 0);
> +			usage_command_group(&btrfs_cmd_group, true, false);
>  		else
>  			cmd_help(argc, argv);
>  		exit(0);
> diff --git a/help.c b/help.c
> index 311a4320..ef7986b4 100644
> --- a/help.c
> +++ b/help.c
> @@ -196,8 +196,8 @@ static int do_usage_one_command(const char * const =
*usagestr,
>  }
> =20
>  static int usage_command_internal(const char * const *usagestr,
> -				  const char *token, int full, int lst,
> -				  int alias, FILE *outf)
> +				  const char *token, bool full, bool lst,
> +				  bool alias, FILE *outf)
>  {
>  	unsigned int flags =3D 0;
>  	int ret;
> @@ -223,17 +223,17 @@ static int usage_command_internal(const char * co=
nst *usagestr,
>  }
> =20
>  static void usage_command_usagestr(const char * const *usagestr,
> -				   const char *token, int full, int err)
> +				   const char *token, bool full, bool err)
>  {
>  	FILE *outf =3D err ? stderr : stdout;
>  	int ret;
> =20
> -	ret =3D usage_command_internal(usagestr, token, full, 0, 0, outf);
> +	ret =3D usage_command_internal(usagestr, token, full, false, false, o=
utf);
>  	if (!ret)
>  		fputc('\n', outf);
>  }
> =20
> -void usage_command(const struct cmd_struct *cmd, int full, int err)
> +void usage_command(const struct cmd_struct *cmd, bool full, bool err)
>  {
>  	usage_command_usagestr(cmd->usagestr, cmd->token, full, err);
>  }
> @@ -241,11 +241,11 @@ void usage_command(const struct cmd_struct *cmd, =
int full, int err)
>  __attribute__((noreturn))
>  void usage(const char * const *usagestr)
>  {
> -	usage_command_usagestr(usagestr, NULL, 1, 1);
> +	usage_command_usagestr(usagestr, NULL, true, true);
>  	exit(1);
>  }
> =20
> -static void usage_command_group_internal(const struct cmd_group *grp, =
int full,
> +static void usage_command_group_internal(const struct cmd_group *grp, =
bool full,
>  					 FILE *outf)
>  {
>  	const struct cmd_struct *cmd =3D grp->commands;
> @@ -265,7 +265,8 @@ static void usage_command_group_internal(const stru=
ct cmd_group *grp, int full,
>  			}
> =20
>  			usage_command_internal(cmd->usagestr, cmd->token, full,
> -					       1, cmd->flags & CMD_ALIAS, outf);
> +					       true, cmd->flags & CMD_ALIAS,
> +					       outf);
>  			if (cmd->flags & CMD_ALIAS)
>  				putchar('\n');
>  			continue;
> @@ -327,7 +328,7 @@ void usage_command_group_short(const struct cmd_gro=
up *grp)
>  	fprintf(stderr, "All command groups have their manual page named 'btr=
fs-<group>'.\n");
>  }
> =20
> -void usage_command_group(const struct cmd_group *grp, int full, int er=
r)
> +void usage_command_group(const struct cmd_group *grp, bool full, bool =
err)
>  {
>  	const char * const *usagestr =3D grp->usagestr;
>  	FILE *outf =3D err ? stderr : stdout;
> @@ -350,7 +351,7 @@ __attribute__((noreturn))
>  void help_unknown_token(const char *arg, const struct cmd_group *grp)
>  {
>  	fprintf(stderr, "%s: unknown token '%s'\n", get_argv0_buf(), arg);
> -	usage_command_group(grp, 0, 1);
> +	usage_command_group(grp, false, true);
>  	exit(1);
>  }
> =20
> @@ -372,13 +373,13 @@ void help_ambiguous_token(const char *arg, const =
struct cmd_group *grp)
> =20
>  void help_command_group(const struct cmd_group *grp, int argc, char **=
argv)
>  {
> -	int full =3D 0;
> +	bool full =3D false;
> =20
>  	if (argc > 1) {
>  		if (!strcmp(argv[1], "--full"))
>  			full =3D 1;
>  	}
> =20
> -	usage_command_group(grp, full, 0);
> +	usage_command_group(grp, full, false);
>  }
> =20
> diff --git a/help.h b/help.h
> index efeded30..a69ea6b2 100644
> --- a/help.h
> +++ b/help.h
> @@ -57,8 +57,8 @@ struct cmd_group;
> =20
>  __attribute__((noreturn))
>  void usage(const char * const *usagestr);
> -void usage_command(const struct cmd_struct *cmd, int full, int err);
> -void usage_command_group(const struct cmd_group *grp, int all, int err=
);
> +void usage_command(const struct cmd_struct *cmd, bool full, bool err);=

> +void usage_command_group(const struct cmd_group *grp, bool all, bool e=
rr);
>  void usage_command_group_short(const struct cmd_group *grp);
> =20
>  __attribute__((noreturn))
>=20


--1rBxj2RyLohIa2e7Rw9LnME7GTxYQt31d--

--mQMHvWvChGqbaA7KyiVtFGpnU2dPe4oCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqg0DQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh2/Af+KE1qM6Rb57MwkBRxIAJm2hLh
nOPZoUwJlVyaeOnzNRgyQV9GGLPURM+TXpCjb+Ya5uptTkgLjxn0nL44AaCIcYJk
XzGiYgIzmi3zOVmmb2fY7L0DBFgJNe3b3r4vqyULk3GAUtJANi7tvOgPZ96N/hsR
1hN2yiTwc+hAFeydCNaK/YNych/uuGmvT+fzps+bvZVtX3CICSbQq9pWA+b20QNN
amFME02KCxBM0EEOzccHb7+cuRKVz2SYy+wLcEozcRoBXjadrM9PDx4XIEn1UQpj
Gqxy4OImHf46Nj5BoRFiLsTK2dWGXULRfT25uEtOvulWbZWZ4UHZmUymXe+qeg==
=nibr
-----END PGP SIGNATURE-----

--mQMHvWvChGqbaA7KyiVtFGpnU2dPe4oCP--
