Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([5.39.87.147]:59220 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaG3MDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 08:03:08 -0400
Date: Wed, 30 Jul 2014 17:55:19 +0600
From: Roman Mamedov <rm@romanrm.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: wait until all subvolumes are cleaned
Message-ID: <20140730175519.55905112@natsu>
In-Reply-To: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
References: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+ozg1dHybg8RLe6WAX/bOhP"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/+ozg1dHybg8RLe6WAX/bOhP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jul 2014 22:56:13 +0200
David Sterba <dsterba@suse.cz> wrote:

> Enhance the 'subvolume' subcommand to wait until a given list of
> subvolumes or all currently scheduled for deletion are cleaned
> completely from the filesystem.
>=20
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>=20
> 'wait' seemed too generic, 'sync' is not completely accurate but IMHO bet=
ter,
> I'm open to other suggestions
>=20
>  cmds-subvolume.c | 231 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 231 insertions(+)
>=20
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 5e821c712e74..07485acbc1bd 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -1035,6 +1035,236 @@ out:
>  	return !!ret;
>  }
> =20
> +static const char * const cmd_subvol_sync_usage[] =3D {
> +	"btrfs subvolume sync <path> [<subvol-id>...]",
> +	"Wait until given subvolume(s) are completely cleaned",
> +	"Wait until given subvolume(s) are completely cleaned after deletion.",

I find "cleaned" to be confusing here. "OK, this subvolume is now clean"? At
the very least this gives an impression that the desired condition is that
subvolume *still exists*, but is empty.

How about "Wait until given subvolume(s) are completely removed from the
filesystem. Does not return until all ongoing deletion requests (if any) on
given subvolume(s) are complete". And yeah, 'sync' sounds good and intuitive
enough.

> +	"If no subvolume id is given, wait until there are no more snapshots",

Please don't intermix "subvolume" and "snapshot" like that. Better to use
"subvolume" in all cases to avoid confusion.

> +	"to be cleaned. This may take long if new deleted subvolumes appear",
> +	"during the sleep interval.",
> +	"",
> +	"-s <N>       sleep N seconds between checks (default: 1)",
> +	NULL
> +};
> +
> +static int is_subvolume_cleaned(int fd, u64 subvolid)
> +{
> +	int ret;
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_key *sk =3D &args.key;
> +
> +	sk->tree_id =3D BTRFS_ROOT_TREE_OBJECTID;
> +	sk->min_objectid =3D subvolid;
> +	sk->max_objectid =3D subvolid;
> +	sk->min_type =3D BTRFS_ROOT_ITEM_KEY;
> +	sk->max_type =3D BTRFS_ROOT_ITEM_KEY;
> +	sk->min_offset =3D 0;
> +	sk->max_offset =3D (u64)-1;
> +	sk->min_transid =3D 0;
> +	sk->max_transid =3D (u64)-1;
> +	sk->nr_items =3D 1;
> +
> +	ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> +	if (ret < 0)
> +		return -errno;
> +
> +	if (sk->nr_items =3D=3D 0)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * If we're looking for any dead subvolume, take a shortcut and look
> + * for any ORPHAN_ITEMs in the tree root
> + */
> +static int fs_has_dead_subvolumes(int fd)
> +{
> +	int ret;
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_key *sk =3D &args.key;
> +	struct btrfs_ioctl_search_header sh;
> +	u64 min_subvolid =3D 0;
> +
> +again:
> +	sk->tree_id =3D BTRFS_ROOT_TREE_OBJECTID;
> +	sk->min_objectid =3D BTRFS_ORPHAN_OBJECTID;
> +	sk->max_objectid =3D BTRFS_ORPHAN_OBJECTID;
> +	sk->min_type =3D BTRFS_ORPHAN_ITEM_KEY;
> +	sk->max_type =3D BTRFS_ORPHAN_ITEM_KEY;
> +	sk->min_offset =3D min_subvolid;
> +	sk->max_offset =3D (u64)-1;
> +	sk->min_transid =3D 0;
> +	sk->max_transid =3D (u64)-1;
> +	sk->nr_items =3D 1;
> +
> +	ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> +	if (ret < 0)
> +		return -errno;
> +
> +	if (!sk->nr_items)
> +		return 0;
> +
> +	memcpy(&sh, args.buf, sizeof(sh));
> +	min_subvolid =3D sh.offset;
> +
> +	/*
> +	 * Verify that the root item is really there and we haven't hit
> +	 * a stale orphan
> +	 */
> +	sk->tree_id =3D BTRFS_ROOT_TREE_OBJECTID;
> +	sk->min_objectid =3D min_subvolid;
> +	sk->max_objectid =3D min_subvolid;
> +	sk->min_type =3D BTRFS_ROOT_ITEM_KEY;
> +	sk->max_type =3D BTRFS_ROOT_ITEM_KEY;
> +	sk->min_offset =3D 0;
> +	sk->max_offset =3D (u64)-1;
> +	sk->min_transid =3D 0;
> +	sk->max_transid =3D (u64)-1;
> +	sk->nr_items =3D 1;
> +
> +	ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> +	if (ret < 0)
> +		return -errno;
> +
> +	/*
> +	 * Stale orphan, try the next one
> +	 */
> +	if (!sk->nr_items) {
> +		min_subvolid++;
> +		goto again;
> +	}
> +
> +	return 1;
> +}
> +
> +static int cmd_subvol_sync(int argc, char **argv)
> +{
> +	int fd =3D -1;
> +	int i;
> +	int ret =3D 1;
> +	DIR *dirstream =3D NULL;
> +	u64 *ids =3D NULL;
> +	int id_count;
> +	int remaining;
> +	int sleep_interval =3D 1;
> +
> +	optind =3D 1;
> +	while (1) {
> +		int c =3D getopt(argc, argv, "s:");
> +
> +		if (c < 0)
> +			break;
> +
> +		switch (c) {
> +		case 's':
> +			sleep_interval =3D atoi(argv[optind]);
> +			if (sleep_interval < 1) {
> +				fprintf(stderr,
> +					"ERROR: invalid sleep interval %s\n",
> +					argv[optind]);
> +				ret =3D 1;
> +				goto out;
> +			}
> +			break;
> +		default:
> +			usage(cmd_subvol_sync_usage);
> +		}
> +	}
> +
> +	if (check_argc_min(argc - optind, 1))
> +		usage(cmd_subvol_sync_usage);
> +
> +	fd =3D open_file_or_dir(argv[optind], &dirstream);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind]);
> +		ret =3D 1;
> +		goto out;
> +	}
> +	optind++;
> +
> +	id_count =3D argc - optind;
> +
> +	/*
> +	 * Wait for all
> +	 */
> +	if (!id_count) {
> +		while (1) {
> +			ret =3D fs_has_dead_subvolumes(fd);
> +			if (ret < 0) {
> +				fprintf(stderr, "ERROR: can't perform the search - %s\n",
> +						strerror(-ret));
> +				ret =3D 1;
> +				goto out;
> +			}
> +			if (!ret)
> +				goto out;
> +			sleep(sleep_interval);
> +		}
> +	}
> +
> +	/*
> +	 * Wait only for the requested ones
> +	 */
> +	ids =3D (u64*)malloc(sizeof(u64) * id_count);
> +
> +	if (!ids) {
> +		fprintf(stderr, "ERROR: not enough memory\n");
> +		ret =3D 1;
> +		goto out;
> +	}
> +
> +	for (i =3D 0; i < id_count; i++) {
> +		u64 id;
> +		const char *arg;
> +
> +		arg =3D argv[optind + i];
> +		errno =3D 0;
> +		id =3D strtoull(arg, NULL, 10);
> +		if (errno < 0) {
> +			fprintf(stderr, "ERROR: unrecognized subovlume id %s\n",

Typo.

> +				arg);
> +			ret =3D 1;
> +			goto out;
> +		}
> +		if (id < BTRFS_FIRST_FREE_OBJECTID || id > BTRFS_LAST_FREE_OBJECTID) {
> +			fprintf(stderr, "ERROR: subovlume id %s out of range\n",

And here.

> +				arg);
> +			ret =3D 1;
> +			goto out;
> +		}
> +		ids[i] =3D id;
> +	}
> +
> +	remaining =3D id_count;
> +	while (1) {
> +		for (i =3D 0; i < id_count; i++) {
> +			if (!ids[i])
> +				continue;
> +			ret =3D is_subvolume_cleaned(fd, ids[i]);
> +			if (ret < 0) {
> +				fprintf(stderr, "ERROR: can't perform the search - %s\n",
> +						strerror(-ret));
> +				goto out;
> +			}
> +			if (ret) {
> +				printf("Subvolume id %llu is gone\n", ids[i]);
> +				ids[i] =3D 0;
> +				remaining--;
> +			}
> +		}
> +		if (!remaining)
> +			break;
> +		sleep(sleep_interval);
> +	}
> +
> +out:
> +	free(ids);
> +	close_file_or_dir(fd, dirstream);
> +
> +	return !!ret;
> +}
> +
>  const struct cmd_group subvolume_cmd_group =3D {
>  	subvolume_cmd_group_usage, NULL, {
>  		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
> @@ -1047,6 +1277,7 @@ const struct cmd_group subvolume_cmd_group =3D {
>  			cmd_subvol_set_default_usage, NULL, 0 },
>  		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
>  		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
> +		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
>  		NULL_CMD_STRUCT
>  	}
>  };


--=20
With respect,
Roman

--Sig_/+ozg1dHybg8RLe6WAX/bOhP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPY3ScACgkQTLKSvz+PZwhvogCgjns1I7iMBpNhHYkGttCMtC92
3RUAn2DL/NJZ6fe+Xlu4yqaEcK+5BjST
=xNuB
-----END PGP SIGNATURE-----

--Sig_/+ozg1dHybg8RLe6WAX/bOhP--
