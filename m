Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35302 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbDZLTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 07:19:47 -0400
Date: Sun, 26 Apr 2015 11:19:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lauri =?iso-8859-1?Q?V=F5sandi?= <lauri.vosandi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
Message-ID: <20150426111943.GZ18187@carfax.org.uk>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LvqQYVlCa9hUs6nS"
In-Reply-To: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LvqQYVlCa9hUs6nS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 26, 2015 at 12:12:45PM +0200, Lauri V=F5sandi wrote:
> This patch adds command-line flag -p to btrfs receive
> which makes it possible to disable automatic parent
> search for incremental snapshots and use explicitly
> specified path instead.

   As I said when we discussed this on IRC, I think this is absolutely
the wrong way to go about solving this problem. This -p option has two
failure modes: the first is that a referenced file simply doesn't
exist in the supplied parent, and the receive fails hard partway
through. The second failure mode is more subtle and not checked for in
any way, which is that the referenced file exists, but doesn't contain
the same data as the original parent subvolume on the send side. In
that case, you will end up with silent corruption of files.

   This is a NAK from me.

   I believe that the correct way of dealing with the issue of
non-transitive sends is twofold:

1) When sending a subvolume which already has a received-uuid field,
   preserve that field in the receiving side rather than overwriting
   it.

2) When specifying the parent to the receiving side, send both the
   uuid and received-uuid fields, and search against both of these in
   the subvolumes on the receiving side to find the parent. This will
   (I think) probably involve a bump of the stream format, and adding
   the received-uuid to the UUID tree.

   Part 1) means that, writing (U, R) for UUID and Received-UUID, we
currently have the following situation:

Subvol A on source side: (A, -)
Send this to A' on target side: (A', A)
Send this back to A'' on source side: (A'', A')

and would change this behaviour to:

Subvol A on source side: (A, -)
Send this to A' on target side: (A', A)
Send this back to A'' on source side: (A'', A) <-- Note the A here, not A'

   More later, when I've had a little time to play with things and
think through the semantics properly.

   Hugo.

> Signed-off-by: Lauri V=F5sandi <lauri.vosandi@gmail.com>
> ---
>  cmds-receive.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
>=20
> diff --git a/cmds-receive.c b/cmds-receive.c
> index b7cf3f9..391d281 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -61,6 +61,7 @@ struct btrfs_receive
>  	char *root_path;
>  	char *dest_dir_path; /* relative to root_path */
>  	char *full_subvol_path;
> +	char *explicit_parent_path;
>  	int dest_dir_chroot;
> =20
>  	struct subvol_info *cur_subvol;
> @@ -220,20 +221,32 @@ static int process_snapshot(const char *path, const=
 u8 *uuid, u64 ctransid,
>  		fprintf(stderr, "receiving snapshot %s uuid=3D%s, "
>  				"ctransid=3D%llu ", path, uuid_str,
>  				r->cur_subvol->stransid);
> -		uuid_unparse(parent_uuid, uuid_str);
> -		fprintf(stderr, "parent_uuid=3D%s, parent_ctransid=3D%llu\n",
> -				uuid_str, parent_ctransid);
>  	}
> =20
>  	memset(&args_v2, 0, sizeof(args_v2));
>  	strncpy_null(args_v2.name, path);
> =20
> -	parent_subvol =3D subvol_uuid_search(&r->sus, 0, parent_uuid,
> -			parent_ctransid, NULL, subvol_search_by_received_uuid);
> -	if (!parent_subvol) {
> +	if (r->explicit_parent_path) {
> +		if (g_verbose) {
> +			fprintf(stderr, "using explicit parent %s\n",
> +					r->explicit_parent_path);
> +		}
> +		parent_subvol =3D subvol_uuid_search(&r->sus, 0, NULL,
> +			0, r->explicit_parent_path, subvol_search_by_path);
> +	} else {
> +		if (g_verbose) {
> +			uuid_unparse(parent_uuid, uuid_str);
> +			fprintf(stderr, "parent_uuid=3D%s, parent_ctransid=3D%llu\n",
> +					uuid_str, parent_ctransid);
> +		}
>  		parent_subvol =3D subvol_uuid_search(&r->sus, 0, parent_uuid,
> -				parent_ctransid, NULL, subvol_search_by_uuid);
> +			parent_ctransid, NULL, subvol_search_by_received_uuid);
> +		if (!parent_subvol) {
> +			parent_subvol =3D subvol_uuid_search(&r->sus, 0, parent_uuid,
> +					parent_ctransid, NULL, subvol_search_by_uuid);
> +		}
>  	}
> +
>  	if (!parent_subvol) {
>  		ret =3D -ENOENT;
>  		fprintf(stderr, "ERROR: could not find parent subvolume\n");
> @@ -962,11 +975,14 @@ int cmd_receive(int argc, char **argv)
>  			{ NULL, 0, NULL, 0 }
>  		};
> =20
> -		c =3D getopt_long(argc, argv, "Cevf:", long_opts, NULL);
> +		c =3D getopt_long(argc, argv, "Cevf:p:", long_opts, NULL);
>  		if (c < 0)
>  			break;
> =20
>  		switch (c) {
> +		case 'p':
> +			r.explicit_parent_path =3D optarg;
> +			break;
>  		case 'v':
>  			g_verbose++;
>  			break;
> @@ -1028,6 +1044,8 @@ const char * const cmd_receive_usage[] =3D {
>  	"                 in the data stream. Without this option,",
>  	"                 the receiver terminates only if an error",
>  	"                 is recognized or on EOF.",
> +	"-p <subvol>      Disables the automatic searching for parents",
> +	"                 if incremental streams are received.",
>  	"-C|--chroot      confine the process to <mount> using chroot",
>  	"--max-errors <N> Terminate as soon as N errors happened while",
>  	"                 processing commands from the send stream.",

--=20
Hugo Mills             | Questions are a burden, and answers a prison for
hugo@... carfax.org.uk | oneself
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                          The Priso=
ner

--LvqQYVlCa9hUs6nS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPMnOAAoJEFheFHXiqx3kGK0P/2MdgE0HZ4FP+ou2e5rEaD7L
JINDrdCpp6BHB5tsVM9R6RjXZEI+CnOijNeOFha66PVMe1S+K88c1cfCOxwWA5cN
ThSN+9OPbu3NY+h/oAQFYrbi/7vCX+zCEMjsyuyO3VmVoalbckGPKgmaOzmclBSu
u/mJXfELuErdn1CYQ13qOYKcCrXP9Um0ymr8P620B5nJqx5S0C9Wq8/tfj24a8NZ
I86ExzKsl7ImZWNKCmLU0Mv/OxHemOCPXBCbcqrUqJGZqKxpWZQ03wRDEP996/lQ
3wk/rzcNlbQ/XaTnEW+lGD9GF/Hbft3FDzjhSNcEjs/lbpv1+CSdffyw9f+Qzekc
c2+mxR0qPuW4iNHaHqkCRr9JnyaGNlDqj1nudkk22yvk0Cs5fQTDN60LKoudmsOX
qJCFQ1Hj0Kswd1MV5QtJ5DE1NjlbwitErZRyQTHuDYOG4ugNnSxMWOWAC/Uo6Cdg
QX9hQYATMjHyB5zKqq6kFxeHxClFyLRqInf169a1F12HFbyt5gPP4lXbdF0SY5TB
jEIiBpAeZALvsG/hatWsXnPfdtHJHhkcngWiL4C2H367JaJTdjI2v+1y6GtvGT/w
blz+7MpRsr+bpDtEB1yxgeBPg5Y8ixD9PAff/26RthrIKc8s6MM33aNf3CZf8spj
79/bqxOgNc2it5KGaD1V
=BIgC
-----END PGP SIGNATURE-----

--LvqQYVlCa9hUs6nS--
