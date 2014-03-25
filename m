Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaCYN6y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 09:58:54 -0400
Message-ID: <53318B98.3000404@suse.com>
Date: Tue, 25 Mar 2014 09:58:48 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arvin Schnell <aschnell@suse.de>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: allow use of subvolume id to create snapshots
References: <5330C6AA.7010508@suse.com> <53318689.8030605@suse.com> <20140325134809.GA7442@carfax.org.uk>
In-Reply-To: <20140325134809.GA7442@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/25/14, 9:48 AM, Hugo Mills wrote:
> On Tue, Mar 25, 2014 at 09:37:13AM -0400, Jeff Mahoney wrote:
>> This patch uses the new BTRFS_SUBVOL_CREATE_SUBVOLID flag to
>> create snapshots by subvolume ID.
>> 
>> usage: btrfs subvolume snapshot [-r] [-q <qgroupid>] -s
>> <subvolid> <dest>/<name>
>> 
>> Since we don't have a name for the source snapshot, the complete
>> path to the destination must be specified.
>> 
>> A previous version of this patch missed an error printing case
>> and would print (null) instead of the subvolume id on error.
> 
> It's interesting you're doing it this way around. For the (fairly 
> common) "regular snapshots of a running system" use-case, it would 
> actually make more sense to snapshot a visible subvol to a
> non-mounted location, rather than the other way around.

For the normal use case, we snapshot into the same namespace. This is
for use when mounting a snapshot directly and wanting to be able to
snapshot other subvolumes into the visible namespace. To snapshot into
a non-visible location is a more involved change that would need a
base subvolume id + a path. Maybe someone wants to come up with that
patch, but it's beyond the scope of what I'm looking to do.

For purposes of discussion on this patch, there's probably an argument
to change the name of the flag to BTRFS_SUBVOL_CREATE_SUBVOLID_SOURCE
or something. That would allow us to later add another flag to use one
of the unused locations in struct btrfs_ioctl_vol_args_v2 to to
specify a destination subvolid.

> The other thing that would be useful, if you're going to allow FS 
> operations on non-mounted objects, is then to delete a subvolume
> by ID.

For that we'd need a BTRFS_IOC_SNAP_DESTROY2 ioctl since the
BTRFS_IOC_SNAP_DESTROY ioctl doesn't allow flags. We couldn't overload
the fd member the way I propose here.

Again, not a terribly difficult change to implement but beyond the
scope of the problem I'm trying to solve.

- -Jeff

>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- cmds-subvolume.c
>> |  105 +++++++++++++++++++++++++++++++++++++++++-------------- 
>> ioctl.h          |    6 ++- man/btrfs.8.in   |   31
>> ++++++++++++++-- 3 files changed, 112 insertions(+), 30
>> deletions(-)
>> 
>> --- a/cmds-subvolume.c +++ b/cmds-subvolume.c @@ -14,6 +14,7 @@ *
>> Boston, MA 021110-1307, USA. */
>> 
>> +#define _GNU_SOURCE #include <stdio.h> #include <stdlib.h> 
>> #include <string.h> @@ -576,6 +577,7 @@ out: static const char *
>> const cmd_snapshot_usage[] = { "btrfs subvolume snapshot [-r]
>> <source> <dest>|[<dest>/]<name>", "btrfs subvolume snapshot [-r]
>> [-i <qgroupid>] <source> <dest>|[<dest>/]<name>", +	"btrfs
>> subvolume snapshot [-r] [-i <qgroupid>] -s <subvolid>
>> <dest>/<name>", "Create a snapshot of the subvolume", "Create a
>> writable/readonly snapshot of the subvolume <source> with", "the
>> name <name> in the <dest> directory.  If only <dest> is given,", 
>> @@ -584,12 +586,27 @@ static const char * const cmd_snapshot_u 
>> "-r             create a readonly snapshot", "-i <qgroupid>  add
>> the newly created snapshot to a qgroup. This", "
>> option can be given multiple times.", +	"-s <subvolid>  create a
>> snapshot using the subvolume id. This", +	"               is
>> useful for snapshotting subvolumes outside", +	"               of
>> the mounted namespace.", NULL };
>> 
>> +static int get_subvolid(const char *str, u64 *subvolid) +{ +
>> char *p; +	errno = 0; +	*subvolid = strtoull(optarg, &p, 10); +
>> if (errno || *p != '\0') { +		fprintf(stderr, "ERROR: invalid
>> subvolume id '%s'\n", optarg); +		return -EINVAL; +	} +	return
>> 0; +} + static int cmd_snapshot(int argc, char **argv) { -	char
>> *subvol, *dst; +	char	*subvol = NULL, *dst; int	res, retval; int
>> fd = -1, fddst = -1; int	len, readonly = 0; @@ -597,6 +614,9 @@
>> static int cmd_snapshot(int argc, char * char	*dupdir = NULL; 
>> char	*newname; char	*dstdir; +	u64	subvolid = 0; +	char
>> *subvol_descr = NULL; +	int	nargs = 2; struct
>> btrfs_ioctl_vol_args_v2	args; struct btrfs_qgroup_inherit
>> *inherit = NULL; DIR *dirstream1 = NULL, *dirstream2 = NULL; @@
>> -604,7 +624,7 @@ static int cmd_snapshot(int argc, char * optind
>> = 1; memset(&args, 0, sizeof(args)); while (1) { -		int c =
>> getopt(argc, argv, "c:i:r"); +		int c = getopt(argc, argv,
>> "c:i:rs:"); if (c < 0) break;
>> 
>> @@ -633,27 +653,39 @@ static int cmd_snapshot(int argc, char * 
>> goto out; } break; +		case 's': +			res = get_subvolid(optarg,
>> &subvolid); +			if (res) { +				retval = res; +				goto out; +
>> } +			nargs = 1; +			break; default: usage(cmd_snapshot_usage); 
>> } }
>> 
>> -	if (check_argc_exact(argc - optind, 2)) +	if
>> (check_argc_exact(argc - optind, nargs)) 
>> usage(cmd_snapshot_usage);
>> 
>> -	subvol = argv[optind]; -	dst = argv[optind + 1]; +	if (nargs ==
>> 2) { +		subvol = argv[optind]; +		dst = argv[optind + 1];
>> 
>> -	retval = 1;	/* failure */ -	res = test_issubvolume(subvol); -
>> if (res < 0) { -		fprintf(stderr, "ERROR: error accessing
>> '%s'\n", subvol); -		goto out; -	} -	if (!res) { -
>> fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol); -
>> goto out; -	} +		retval = 1;	/* failure */ +		res =
>> test_issubvolume(subvol); +		if (res < 0) { +			fprintf(stderr,
>> "ERROR: error accessing '%s'\n", subvol); +			goto out; +		} +
>> if (!res) { +			fprintf(stderr, "ERROR: '%s' is not a
>> subvolume\n", +				subvol); +			goto out; +		} +	} else +		dst =
>> argv[optind];
>> 
>> res = test_isdir(dst); if (res == 0) { @@ -662,6 +694,13 @@
>> static int cmd_snapshot(int argc, char * }
>> 
>> if (res > 0) { +		if (!subvol) { +			retval = 1; +
>> fprintf(stderr, +				"ERROR: '%s' exists and must not when
>> snapshotting by specifying subvolid.\n", +				dst); +			goto
>> out; +		} dupname = strdup(subvol); newname = basename(dupname); 
>> dstdir = dst; @@ -692,22 +731,34 @@ static int cmd_snapshot(int
>> argc, char * goto out; }
>> 
>> -	fd = open_file_or_dir(subvol, &dirstream2); -	if (fd < 0) { -
>> fprintf(stderr, "ERROR: can't access '%s'\n", dstdir); +	if
>> (subvol) { +		fd = open_file_or_dir(subvol, &dirstream2); +		if
>> (fd < 0) { +			fprintf(stderr, "ERROR: can't access '%s'\n",
>> dstdir); +			goto out; +		} +		args.fd = fd; +		res =
>> asprintf(&subvol_descr, "'%s'", subvol); +	} else { +
>> args.subvolid = subvolid; +		args.flags |=
>> BTRFS_SUBVOL_CREATE_SUBVOLID; +		res = asprintf(&subvol_descr,
>> "subvolume id %llu", subvolid); +	} +	if (res < 0) { +
>> fprintf(stderr, "ERROR: can't allocate memory\n"); +		retval =
>> 1; goto out; }
>> 
>> if (readonly) { args.flags |= BTRFS_SUBVOL_RDONLY; -
>> printf("Create a readonly snapshot of '%s' in '%s/%s'\n", -
>> subvol, dstdir, newname); +		printf("Create a readonly snapshot
>> of %s in '%s/%s'\n", +		       subvol_descr, dstdir, newname); }
>> else { -		printf("Create a snapshot of '%s' in '%s/%s'\n", -
>> subvol, dstdir, newname); +		printf("Create a snapshot of %s in
>> '%s/%s'\n", +		       subvol_descr, dstdir, newname); }
>> 
>> -	args.fd = fd; if (inherit) { args.flags |=
>> BTRFS_SUBVOL_QGROUP_INHERIT; args.size =
>> qgroup_inherit_size(inherit); @@ -718,8 +769,8 @@ static int
>> cmd_snapshot(int argc, char * res = ioctl(fddst,
>> BTRFS_IOC_SNAP_CREATE_V2, &args);
>> 
>> if (res < 0) { -		fprintf( stderr, "ERROR: cannot snapshot '%s' -
>> %s\n", -			subvol, strerror(errno)); +		fprintf( stderr, "ERROR:
>> cannot snapshot %s - %s\n", +			subvol_descr, strerror(errno)); 
>> goto out; }
>> 
>> @@ -727,7 +778,9 @@ static int cmd_snapshot(int argc, char *
>> 
>> out: close_file_or_dir(fddst, dirstream1); -
>> close_file_or_dir(fd, dirstream2); +	if (subvol) +
>> close_file_or_dir(fd, dirstream2); +	free(subvol_descr); 
>> free(inherit); free(dupname); free(dupdir); --- a/ioctl.h +++
>> b/ioctl.h @@ -41,6 +41,7 @@ struct btrfs_ioctl_vol_args { #define
>> BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0) #define BTRFS_SUBVOL_RDONLY
>> (1ULL << 1) #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2) 
>> +#define BTRFS_SUBVOL_CREATE_SUBVOLID	(1ULL << 3)
>> 
>> #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
>> 
>> @@ -69,7 +70,10 @@ struct btrfs_ioctl_qgroup_limit_args { #define
>> BTRFS_SUBVOL_NAME_MAX 4039
>> 
>> struct btrfs_ioctl_vol_args_v2 { -	__s64 fd; +	union { +		__s64
>> fd; +		__u64 subvolid; +	}; __u64 transid; __u64 flags; union { 
>> --- a/man/btrfs.8.in +++ b/man/btrfs.8.in @@ -12,7 +12,9 @@ btrfs
>> \- control a btrfs filesystem .PP \fBbtrfs\fP \fBsubvolume
>> list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C
>> [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP .PP 
>> -\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] \fI<source>\fP
>> \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP +\fBbtrfs\fP
>> \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI<source>\fP
>> \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP +.PP +\fBbtrfs\fP
>> \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP
>> \fI<dest>/<name>\fP .PP \fBbtrfs\fP \fBsubvolume
>> get-default\fP\fI <path>\fP .PP @@ -242,12 +244,35 @@ for
>> \fB--sort\fP you can combine some it .RE .TP
>> 
>> -\fBsubvolume snapshot\fP [-r] \fI<source>\fP
>> \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP +\fBsubvolume
>> snapshot\fP [-r] [-i qgroupid] \fI<source>\fP
>> \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP Create a
>> writable/readonly snapshot of the subvolume \fI<source>\fR with
>> the name \fI<name>\fR in the \fI<dest>\fR directory. If only
>> \fI<dest>\fR is given, the subvolume will be named the basename
>> of \fI<source>\fR. If \fI<source>\fR is not a subvolume,
>> \fBbtrfs\fR returns an error. -If \fI-r\fR is given, the snapshot
>> will be readonly. +.RS + +\fIOptions\fP +.IP \fB-r\fP 5 +The
>> newly created snapshot will be readonly. +.IP "\fB-i\fP
>> \fI<qgroupid>\fR" 5 +Add the newly created subvolume to a qgroup.
>> This option can be given multiple +times. +.RE +.TP + 
>> +\fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP
>> \fI<dest>\fP/\fI<name>\fP +Create a writable/readonly snapshot of
>> the subvolume \fI<subvolid>\fR with the +name \fI<name>\fR in the
>> \fI<dest>\fR directory. +If \fI<subvolid>\fR does not refer to a
>> subvolume, \fBbtrfs\fR returns an error. +.RS + +\fIOptions\fP 
>> +.IP \fB-r\fP 5 +The newly created snapshot will be readonly. 
>> +.IP "\fB-i\fP \fI<qgroupid>\fR" 5 +Add the newly created
>> subvolume to a qgroup. This option can be given multiple +times. 
>> +.RE .TP
>> 
>> \fBsubvolume get-default\fR\fI <path>\fR
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJTMYuXAAoJEB57S2MheeWyLcYP/jS9aqUS6iTGwd61S9HQEg1t
ZGrHgU5nTupxIpZ81G0TgShzP1EDAIRARx5eKaPA3TmTnI6ng1EvpLyCZ47ZoGte
gOAtuoTUjCLq+8kERTCPaPtb0NAsYKvWq4QVKq3xdBZK+B0Wtx5yTInx8h6MTqRF
cHmUuYRUSzHqtqY74UxPEYTRcjHk6HRN8UkirmIot+u8u7COw4/vOhld8XUuMUiV
rztSKcFMy2+akbZtqXpGe1TsqhRr6qQq5HQ25/mM6zmViqzzwpcYSY6kFbfdWexq
IsmnhrgGq/XTT3kmM/EuaW2aO1YQ0FKb67gkvvWc0R7wpIsBsV5SKaO/i3C46Dfg
O2kXZ4+j/vdtv3Cuc+To8lKfV0j3y0wuEgGlTkOs8EmJqa/asplZQEz0V8JghVR2
KlcJC3GI84C3R4MDHsb1sYXPDm8UKfmUA5MKTRMAEpxZH4NI6AYpAQteJcXYWpgU
+95sLuROVJ+03FmJMoP02fGyoBh6GA+sUhmrEi81XwDixDvQAlfnadWzocddw5ZT
qZmB22+yo5aKFLxTbfxaqdKO4pVXZ6LOVjuQCrYScGOYTBJ8yBNNIHRX8c/1R0aZ
Q72dU8kxYaAjJ/x3yYWZlPY1QGm9fM+ZVmuWlzjwW7ZnuDqTVYy9LIrNoMFkB1YO
oAZkfaDznB/ZAzqoGKbX
=mWz8
-----END PGP SIGNATURE-----
