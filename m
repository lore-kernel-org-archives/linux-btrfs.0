Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45836 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaCYNsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 09:48:14 -0400
Date: Tue, 25 Mar 2014 13:48:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arvin Schnell <aschnell@suse.de>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: allow use of subvolume id to create
 snapshots
Message-ID: <20140325134809.GA7442@carfax.org.uk>
References: <5330C6AA.7010508@suse.com>
 <53318689.8030605@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
In-Reply-To: <53318689.8030605@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 25, 2014 at 09:37:13AM -0400, Jeff Mahoney wrote:
> This patch uses the new BTRFS_SUBVOL_CREATE_SUBVOLID flag to create snapshots
> by subvolume ID.
> 
> usage: btrfs subvolume snapshot [-r] [-q <qgroupid>] -s <subvolid> <dest>/<name>
> 
> Since we don't have a name for the source snapshot, the complete path to
> the destination must be specified.
> 
> A previous version of this patch missed an error printing case and would print
> (null) instead of the subvolume id on error.

   It's interesting you're doing it this way around. For the (fairly
common) "regular snapshots of a running system" use-case, it would
actually make more sense to snapshot a visible subvol to a non-mounted
location, rather than the other way around.

   The other thing that would be useful, if you're going to allow FS
operations on non-mounted objects, is then to delete a subvolume by
ID.

   Hugo.

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  cmds-subvolume.c |  105 +++++++++++++++++++++++++++++++++++++++++--------------
>  ioctl.h          |    6 ++-
>  man/btrfs.8.in   |   31 ++++++++++++++--
>  3 files changed, 112 insertions(+), 30 deletions(-)
> 
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -14,6 +14,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -576,6 +577,7 @@ out:
>  static const char * const cmd_snapshot_usage[] = {
>  	"btrfs subvolume snapshot [-r] <source> <dest>|[<dest>/]<name>",
>  	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
> +	"btrfs subvolume snapshot [-r] [-i <qgroupid>] -s <subvolid> <dest>/<name>",
>  	"Create a snapshot of the subvolume",
>  	"Create a writable/readonly snapshot of the subvolume <source> with",
>  	"the name <name> in the <dest> directory.  If only <dest> is given,",
> @@ -584,12 +586,27 @@ static const char * const cmd_snapshot_u
>  	"-r             create a readonly snapshot",
>  	"-i <qgroupid>  add the newly created snapshot to a qgroup. This",
>  	"               option can be given multiple times.",
> +	"-s <subvolid>  create a snapshot using the subvolume id. This",
> +	"               is useful for snapshotting subvolumes outside",
> +	"               of the mounted namespace.",
>  	NULL
>  };
>  
> +static int get_subvolid(const char *str, u64 *subvolid)
> +{
> +	char *p;
> +	errno = 0;
> +	*subvolid = strtoull(optarg, &p, 10);
> +	if (errno || *p != '\0') {
> +		fprintf(stderr, "ERROR: invalid subvolume id '%s'\n", optarg);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int cmd_snapshot(int argc, char **argv)
>  {
> -	char	*subvol, *dst;
> +	char	*subvol = NULL, *dst;
>  	int	res, retval;
>  	int	fd = -1, fddst = -1;
>  	int	len, readonly = 0;
> @@ -597,6 +614,9 @@ static int cmd_snapshot(int argc, char *
>  	char	*dupdir = NULL;
>  	char	*newname;
>  	char	*dstdir;
> +	u64	subvolid = 0;
> +	char	*subvol_descr = NULL;
> +	int	nargs = 2;
>  	struct btrfs_ioctl_vol_args_v2	args;
>  	struct btrfs_qgroup_inherit *inherit = NULL;
>  	DIR *dirstream1 = NULL, *dirstream2 = NULL;
> @@ -604,7 +624,7 @@ static int cmd_snapshot(int argc, char *
>  	optind = 1;
>  	memset(&args, 0, sizeof(args));
>  	while (1) {
> -		int c = getopt(argc, argv, "c:i:r");
> +		int c = getopt(argc, argv, "c:i:rs:");
>  		if (c < 0)
>  			break;
>  
> @@ -633,27 +653,39 @@ static int cmd_snapshot(int argc, char *
>  				goto out;
>  			}
>  			break;
> +		case 's':
> +			res = get_subvolid(optarg, &subvolid);
> +			if (res) {
> +				retval = res;
> +				goto out;
> +			}
> +			nargs = 1;
> +			break;
>  		default:
>  			usage(cmd_snapshot_usage);
>  		}
>  	}
>  
> -	if (check_argc_exact(argc - optind, 2))
> +	if (check_argc_exact(argc - optind, nargs))
>  		usage(cmd_snapshot_usage);
>  
> -	subvol = argv[optind];
> -	dst = argv[optind + 1];
> +	if (nargs == 2) {
> +		subvol = argv[optind];
> +		dst = argv[optind + 1];
>  
> -	retval = 1;	/* failure */
> -	res = test_issubvolume(subvol);
> -	if (res < 0) {
> -		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
> -		goto out;
> -	}
> -	if (!res) {
> -		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
> -		goto out;
> -	}
> +		retval = 1;	/* failure */
> +		res = test_issubvolume(subvol);
> +		if (res < 0) {
> +			fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
> +			goto out;
> +		}
> +		if (!res) {
> +			fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
> +				subvol);
> +			goto out;
> +		}
> +	} else
> +		dst = argv[optind];
>  
>  	res = test_isdir(dst);
>  	if (res == 0) {
> @@ -662,6 +694,13 @@ static int cmd_snapshot(int argc, char *
>  	}
>  
>  	if (res > 0) {
> +		if (!subvol) {
> +			retval = 1;
> +			fprintf(stderr,
> +				"ERROR: '%s' exists and must not when snapshotting by specifying subvolid.\n",
> +				dst);
> +			goto out;
> +		}
>  		dupname = strdup(subvol);
>  		newname = basename(dupname);
>  		dstdir = dst;
> @@ -692,22 +731,34 @@ static int cmd_snapshot(int argc, char *
>  		goto out;
>  	}
>  
> -	fd = open_file_or_dir(subvol, &dirstream2);
> -	if (fd < 0) {
> -		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
> +	if (subvol) {
> +		fd = open_file_or_dir(subvol, &dirstream2);
> +		if (fd < 0) {
> +			fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
> +			goto out;
> +		}
> +		args.fd = fd;
> +		res = asprintf(&subvol_descr, "'%s'", subvol);
> +	} else {
> +		args.subvolid = subvolid;
> +		args.flags |= BTRFS_SUBVOL_CREATE_SUBVOLID;
> +		res = asprintf(&subvol_descr, "subvolume id %llu", subvolid);
> +	}
> +	if (res < 0) {
> +		fprintf(stderr, "ERROR: can't allocate memory\n");
> +		retval = 1;
>  		goto out;
>  	}
>  
>  	if (readonly) {
>  		args.flags |= BTRFS_SUBVOL_RDONLY;
> -		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
> -		       subvol, dstdir, newname);
> +		printf("Create a readonly snapshot of %s in '%s/%s'\n",
> +		       subvol_descr, dstdir, newname);
>  	} else {
> -		printf("Create a snapshot of '%s' in '%s/%s'\n",
> -		       subvol, dstdir, newname);
> +		printf("Create a snapshot of %s in '%s/%s'\n",
> +		       subvol_descr, dstdir, newname);
>  	}
>  
> -	args.fd = fd;
>  	if (inherit) {
>  		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
>  		args.size = qgroup_inherit_size(inherit);
> @@ -718,8 +769,8 @@ static int cmd_snapshot(int argc, char *
>  	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
>  
>  	if (res < 0) {
> -		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
> -			subvol, strerror(errno));
> +		fprintf( stderr, "ERROR: cannot snapshot %s - %s\n",
> +			subvol_descr, strerror(errno));
>  		goto out;
>  	}
>  
> @@ -727,7 +778,9 @@ static int cmd_snapshot(int argc, char *
>  
>  out:
>  	close_file_or_dir(fddst, dirstream1);
> -	close_file_or_dir(fd, dirstream2);
> +	if (subvol)
> +		close_file_or_dir(fd, dirstream2);
> +	free(subvol_descr);
>  	free(inherit);
>  	free(dupname);
>  	free(dupdir);
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -41,6 +41,7 @@ struct btrfs_ioctl_vol_args {
>  #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
>  #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
>  #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
> +#define BTRFS_SUBVOL_CREATE_SUBVOLID	(1ULL << 3)
>  
>  #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
>  
> @@ -69,7 +70,10 @@ struct btrfs_ioctl_qgroup_limit_args {
>  #define BTRFS_SUBVOL_NAME_MAX 4039
>  
>  struct btrfs_ioctl_vol_args_v2 {
> -	__s64 fd;
> +	union {
> +		__s64 fd;
> +		__u64 subvolid;
> +	};
>  	__u64 transid;
>  	__u64 flags;
>  	union {
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -12,7 +12,9 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
>  .PP
> -\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
> +\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
> +.PP
> +\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP \fI<dest>/<name>\fP
>  .PP
>  \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
>  .PP
> @@ -242,12 +244,35 @@ for \fB--sort\fP you can combine some it
>  .RE
>  .TP
>  
> -\fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
> +\fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
>  Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
>  name \fI<name>\fR in the \fI<dest>\fR directory.
>  If only \fI<dest>\fR is given, the subvolume will be named the basename of \fI<source>\fR.
>  If \fI<source>\fR is not a subvolume, \fBbtrfs\fR returns an error.
> -If \fI-r\fR is given, the snapshot will be readonly.
> +.RS
> +
> +\fIOptions\fP
> +.IP \fB-r\fP 5
> +The newly created snapshot will be readonly.
> +.IP "\fB-i\fP \fI<qgroupid>\fR" 5
> +Add the newly created subvolume to a qgroup. This option can be given multiple
> +times.
> +.RE
> +.TP
> +
> +\fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP \fI<dest>\fP/\fI<name>\fP
> +Create a writable/readonly snapshot of the subvolume \fI<subvolid>\fR with the
> +name \fI<name>\fR in the \fI<dest>\fR directory.
> +If \fI<subvolid>\fR does not refer to a subvolume, \fBbtrfs\fR returns an error.
> +.RS
> +
> +\fIOptions\fP
> +.IP \fB-r\fP 5
> +The newly created snapshot will be readonly.
> +.IP "\fB-i\fP \fI<qgroupid>\fR" 5
> +Add the newly created subvolume to a qgroup. This option can be given multiple
> +times.
> +.RE
>  .TP
>  
>  \fBsubvolume get-default\fR\fI <path>\fR

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- vi: The core of evil. ---                      

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUzGJGVheFHXiqx3kAQJHFQ//VK59eMvAalOid9cLom+Z4W6ZCQtiexD9
+on5jiCW8/2XwvLXZWRj/5kRWEaxoVe9N7SzDsVr8z5eJ+aq7GRt/SU2i+YSzEyj
07BGHSKSC1MZYAFl/xgtJTjPtDXZDD/jabSs8NK+AeYGF1D75FViEK1RWEIJ6SSw
40a8eFkP76q9rH4m94pkl4eacXru0HFL2ul1HHLGC7NsOR9GrHC5otHpJOBjl0l9
LeM6bWKpteQuzxuNmn9BuTrjQ7Hroay2MPwCC0uh9tgS9s5iqbapeRUzglyApeTM
b1GX/+poNnbJ1IT+/2gAnlBR9kdzbRKu6LaOisdyUMXGTk5Sd1dd69nMbrwd0PN2
SHQ885jvH9l5qkVK9Gu9gu6a8KLEcq25JSTgQmd5rR9pM7D9d/AzsEensU77u1QY
hV8do2xUhRLsGeldJG5rYLz13NBkVWT67PdY0A4gilCaZOQNzfBx5rXqEphtFONY
j1zT/7z6w0+K1vx40bIbt5ESE2LGw4ODwZgO1tOzbbnuRuPNA+1CgnkLDKUASzjH
pQ+G00yZqxUqLJMb10yXOF+syChsL8FbpY9P+pmQsEWxJaMPnOQRUQVfrhqxFVzX
3+iLDFzgdLt0Jxvp2XuNirKw04GgCST+KJU8lkVHV2z5YcqfvDS5vltB53yYuEGI
hLdBl9leLxA=
=EIb8
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
