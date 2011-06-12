From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 4/5][REPOST][BTRFS-PROGS] Avoid to scan cdrom and floppy
Date: Sun, 12 Jun 2011 22:52:45 +0100
Message-ID: <20110612215245.GD832@carfax.org.uk>
References: <201012051847.15633.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012051847.15633.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

   Goffredo -=20

   As with the other patch, this is missing S-o-B, and has some damage
=66rom line wrapping. If you fix and re-send, I'll pull into my
integration branch.

   Hugo.

On Sun, Dec 05, 2010 at 06:47:15PM +0100, Goffredo Baroncelli wrote:
> Hi all,
>=20
> the commands "btrfs filesystem show" and "btrfs device scan" look at the =
/dev
> directory (and it subdirectories) for every block devices.
> This is a slow process because floppy and cdrom are also checked. Moreove=
r,
> as highlighted by Helmut, if udev is not used, the /dev directory is popu=
lated
> by high number of non-existant devices, which slow the process.
>=20
> My patch changes the behaviour of these commands. The list of the devices=
 are
> extracted from /proc/partitions, and on the basis of the file=20
> /etc/btrfs.devices some devices may be skipped.
>=20
> The file /etc/btrfs.devices contains a list of devices which have to be s=
kipped=20
> (if the line starts with '!') or to be evaluated. Shell wildcard may be u=
sed.
>=20
> If the file doesn't exists the default is to skip cdroms (/dev/cdrom*) an=
d=20
> floppies (/dev/fd*).
>=20
> To revert to the old behaviour use the switch '--all-devices'.
>=20
> Below the patch, but it is possible to pull the changes from:
>=20
>  	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
>=20
> branch
>=20
> 	device-checklist
>=20
> Comment are welcome.
>=20
> Regards
> G.Baroncelli
>=20
>=20
>  btrfs.c        |   10 +-
>  btrfs.devices  |   24 ++++++
>  btrfs_cmds.c   |   39 +++++++++--
>  man/btrfs.8.in |   22 ++++--
>  utils.c        |  196 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+-
>  utils.h        |    5 +
>  6 files changed, 279 insertions(+), 17 deletions(-)
>=20
>=20
>=20
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..d850e60 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -83,9 +83,10 @@ static struct Command commands[] =3D {
>  		"will occupe all available space on the device."
>  	},
>  	{ do_show_filesystem, 999,
> -	  "filesystem show", "[<uuid>|<label>]\n"
> +	  "filesystem show", "[--all-devices][<uuid>|<label>]\n"
>  		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
> -		"is passed, info of all the btrfs filesystem are shown."
> +		"is passed, info of all the btrfs filesystem are shown.\n"
> +		"If --all-devices is passed, all devices are scanned."
>  	},
>  	{ do_df_filesystem, 1,
>  	  "filesystem df", "<path>\n"
> @@ -96,9 +97,10 @@ static struct Command commands[] =3D {
>  		"Balance the chunks across the device."
>  	},
>  	{ do_scan,
> -	  999, "device scan", "[<device> [<device>..]\n"
> +	  999, "device scan", "[--all-devices|<device> [<device>..]\n"
>  		"Scan all device for or the passed device for a btrfs\n"
> -		"filesystem."
> +		"filesystem.\n"
> +		"If --all-devices is passed, all devices are scanned."
>  	},
>  	{ do_add_volume, -2,
>  	  "device add", "<dev> [<dev>..] <path>\n"
> diff --git a/btrfs.devices b/btrfs.devices
> new file mode 100644
> index 0000000..ffeb8b6
> --- /dev/null
> +++ b/btrfs.devices
> @@ -0,0 +1,24 @@
> +#
> +#	This file lists the devices which have to be skipped or not
> +#	during the command 'btrfs filesystem show' and 'btrfs device scan'
> +#
> +#	These lines may contain a shell wildcard pattern (*,?,[]).
> +#
> +#	If a line starts with "!" and matches a device, the device is skipped
> +#	If a line matches a device, the device is evaluated
> +#	If a device is not matched by any line, the device is evaluated.
> +#
> +#	The lines starting with "#" are comments. The lines empty are
> +#	ignored=20
> +#
> +
> +
> +
> +# There are two default rules which are added automatically
> +#
> +# skip floppy
> +# !/dev/fd*
> +#
> +# skip cdrom
> +# !/dev/sr*
> +#
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..a573008 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -529,11 +529,25 @@ int do_fssync(int argc, char **argv)
>  int do_scan(int argc, char **argv)
>  {
>  	int	i, fd;
> -	if(argc<=3D1){
> +	int	checklist =3D 1;
> +	int	devstart =3D 1;
> +
> +	if( argc >=3D 2 && !strcmp(argv[1],"--all-devices")){
> +
> +		if( argc >2 ){
> +			fprintf(stderr, "ERROR: too may arguments\n");
> +                        return 22;
> +                }
> +
> +		checklist =3D 0;
> +		devstart +=3D 1;
> +	}
> +
> +	if(argc<=3Ddevstart){
>  		int ret;
> =20
>  		printf("Scanning for Btrfs filesystems\n");
> -		ret =3D btrfs_scan_one_dir("/dev", 1);
> +		ret =3D btrfs_scan_block_devices(1, checklist);
>  		if (ret){
>  			fprintf(stderr, "ERROR: error %d while scanning\n",=20
> ret);
>  			return 18;
> @@ -547,7 +561,7 @@ int do_scan(int argc, char **argv)
>  		return 10;
>  	}
> =20
> -	for( i =3D 1 ; i < argc ; i++ ){
> +	for( i =3D devstart ; i < argc ; i++ ){
>  		struct btrfs_ioctl_vol_args args;
>  		int ret;
> =20
> @@ -666,15 +680,30 @@ int do_show_filesystem(int argc, char **argv)
>  	struct list_head *all_uuids;
>  	struct btrfs_fs_devices *fs_devices;
>  	struct list_head *cur_uuid;
> -	char *search =3D argv[1];
> +	char *search=3D0;
>  	int ret;
> +	int checklist =3D 1;
> +	int searchstart =3D 1;
> =20
> -	ret =3D btrfs_scan_one_dir("/dev", 0);
> +	if( argc >=3D 2 && !strcmp(argv[1],"--all-devices")){
> +		checklist =3D 0;
> +		searchstart +=3D 1;
> +	}
> +
> +	if( argc > searchstart+1 ){
> +		fprintf(stderr, "ERROR: too many arguments\n");
> +		return 22;
> +	}=09
> +
> +	ret =3D btrfs_scan_block_devices(0, checklist);
>  	if (ret){
>  		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
>  		return 18;
>  	}
> =20
> +	if(searchstart < argc)
> +		search =3D argv[searchstart];
> +
>  	all_uuids =3D btrfs_scanned_uuids();
>  	list_for_each(cur_uuid, all_uuids) {
>  		fs_devices =3D list_entry(cur_uuid, struct btrfs_fs_devices,
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..77b13f6 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -21,9 +21,9 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem=
>\fP
>  .PP
> -\fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
> +\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices] <uuid>|<label> [<uu=
id>|
> <label>...]\fP
>  .PP
> -\fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
> +\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices][<device> [<device>..]]\=
fP
>  .PP
>  \fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
>  .PP
> @@ -106,9 +106,10 @@ is returned by the \fBsubvolume list\fR command.
>  Defragment files and/or directories.
>  .TP
> =20
> -\fBdevice scan\fR \fI[<device> [<device>..]]\fR
> +\fBdevice scan\fR \fI[--all-devices][<device> [<device>..]]\fR
>  Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\=
fR=20
> scans
> -all the block devices.
> +all the block devices. If --all-devices is passed, the file /etc/btrfs.d=
evices
> +are ignored and all devices are scanned.
>  .TP
> =20
>  \fBfilesystem sync\fR\fI <path> \fR
> @@ -138,9 +139,10 @@ can expand the partition before enlarging the filesy=
stem=20
> and shrink the
>  partition after reducing the size of the filesystem.
>  .TP
> =20
> -\fBfilesystem show\fR [<uuid>|<label>]\fR
> +\fBfilesystem show\fR [--all-devices][<uuid>|<label>]\fR
>  Show the btrfs filesystem with some additional info. If no UUID or label=
 is
> -passed, \fBbtrfs\fR show info of all the btrfs filesystem.
> +passed, \fBbtrfs\fR show info of all the btrfs filesystem. If --all-devi=
ces
> +is passed, the file /etc/btrfs.devices are ignored and all devices are s=
canned.
>  .TP
> =20
>  \fBdevice balance\fR \fI<path>\fR
> @@ -160,6 +162,14 @@ Remove device(s) from a filesystem identified by=20
> \fI<path>\fR.
>  \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is retu=
rned in
>  case of failure.
> =20
> +.SH FILES
> +The file \fB/etc/btrfs.devices\fR contains a list of devices which have =
to be
> +skipped (or not) when the commands \fBbtrfs filesystem show\fR and
> +\fBbtrfs device scan\fR are executed. If a line starts with '!', and mat=
ches
> +a device, this device is skipped. If a line matches a device, this devic=
e is
> +evaluated. If this file doesn't exists, the default rules are to skip fl=
oppy
> +and cdrom.The shell wildcard may be used.
> +
>  .SH AVAILABILITY
>  .B btrfs
>  is part of btrfs-progs. Btrfs filesystem is currently under heavy develo=
pment,
> diff --git a/utils.c b/utils.c
> index fd894f3..6112137 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -35,6 +35,8 @@
>  #include <linux/major.h>
>  #include <linux/kdev_t.h>
>  #include <limits.h>
> +#include <ctype.h>
> +#include <fnmatch.h>
>  #include "kerncompat.h"
>  #include "radix-tree.h"
>  #include "ctree.h"
> @@ -833,7 +835,185 @@ void btrfs_register_one_device(char *fname)
>  	close(fd);
>  }
> =20
> -int btrfs_scan_one_dir(char *dirname, int run_ioctl)
> +
> +static char **device_checklist =3D 0;
> +static int  device_checklist_count =3D 0;
> +/*
> + *	Default device black list:
> + *	If the line starts with a "!" the device has to be skipped
> + *	otherwise the device is OK
> + */
> +static char *default_checklist[] =3D {
> +	"!/dev/fd*",
> +	"!/dev/sr*",
> +	0
> +};
> +/* add an entry in the checklist */
> +static int device_checklist_add(char *entry)
> +{
> +	char	*cpy;
> +	char	**res;
> +
> +	device_checklist_count +=3D 1;
> +	res =3D realloc(device_checklist,=20
> +				sizeof(char*)*device_checklist_count);
> +	if( !res ){
> +		free(device_checklist);
> +		device_checklist_count =3D 0;
> +		return -1;
> +	}
> +	device_checklist =3D res;
> +
> +	cpy =3D strdup(entry);
> +	if( !cpy ){
> +                free(device_checklist);
> +                device_checklist_count =3D 0;
> +                return -1;
> +        }
> +
> +	device_checklist[device_checklist_count-1] =3D cpy;
> +	return 0;
> +}
> +
> +/*=20
> + * init the check list on teh basis of the default check list
> + * and the check list stored in the file "fn"
> + */
> +static int init_device_checklist(char *fn)
> +{
> +
> +	char	buf[1024];
> +	int	i;
> +	FILE	*fp;
> +
> +	if(device_checklist_count)
> +		return 0;
> +
> +	if( fn =3D=3D 0 )
> +		return 0;	/* no extra rules provided */
> +
> +	fp =3D fopen(fn, "r");
> +	if(!fp)
> +		return 0;	/* the file doesn't exist */
> +
> +	while(fgets(buf,1023, fp)){
> +		char	*p =3D buf;
> +		char	*l;
> +		while (isblank(*p)) p++;
> +		l =3D p;
> +		while( *l !=3D '\n' && *l !=3D '\r' && *l ) l++;
> +		*l =3D 0;
> +
> +		if( *p =3D=3D '#' || *p =3D=3D 0 )
> +			continue;
> +
> +		if(device_checklist_add(p)){
> +			fclose(fp);
> +			return -2;
> +		}
> +	}
> +	fclose(fp);
> +
> +	for(i=3D0; default_checklist[i] ; i++ )
> +		if(device_checklist_add(default_checklist[i]))
> +			return -3;
> +
> +=09
> +	return 0;
> +}
> +
> +/*=20
> + * This function test if "dev" has to be skipped on the basis of the
> + * checklist; return values:
> + *	0 -> skip the deive
> + *	1 -> teh device is ok
> + */
> +static int test_device(char *dev )
> +{
> +	int	i;
> +	for( i =3D 0 ; i < device_checklist_count ; i++ ){
> +		int	res;
> +		char	*rule;
> +
> +		rule =3D device_checklist[i];
> +
> +		if( rule[0] =3D=3D '!' ){
> +			res =3D 0;	/* if match, skip the device */
> +			rule++;
> +		}else{
> +			res =3D 1;	/* if match, the device is ok */
> +		}
> +
> +		if( !fnmatch(rule, dev, 0 ) )
> +			return res;
> +
> +	}
> +	return 1;
> +}
> +
> +int btrfs_scan_block_devices(int run_ioctl, int checklist)
> +{
> +
> +	struct stat st;
> +	int ret;
> +	int fd;
> +	struct btrfs_fs_devices *tmp_devices;
> +	u64 num_devices;
> +	FILE *proc_partitions;
> +	int i;
> +	char buf[1024];
> +	char name[100], fullpath[110];
> +
> +	if(checklist)
> +		init_device_checklist(BTRFSDEVICELIST);
> +
> +	proc_partitions =3D fopen("/proc/partitions","r");
> +	if (!proc_partitions) {
> +		fprintf(stderr, "Unable to open '/proc/partitions' for=20
> scanning\n");
> +		return -ENOENT;
> +	}
> +	/* skip the header */
> +	for(i=3D0; i < 2 ; i++)
> +		if(!fgets(buf, 1023, proc_partitions)){
> +		fprintf(stderr, "Unable to read '/proc/partitions' for=20
> scanning\n");
> +		fclose(proc_partitions);
> +		return -ENOENT;
> +	}
> +
> +	strcpy(fullpath,"/dev/");
> +	while(fgets(buf, 1023, proc_partitions)) {
> +
> +		i =3D sscanf(buf," %*d %*d %*d %99s", fullpath+5);
> +		ret =3D lstat(fullpath, &st);
> +		if (ret < 0) {
> +			fprintf(stderr, "failed to stat %s\n", fullpath);
> +			continue;
> +		}
> +		if (!S_ISBLK(st.st_mode)) {
> +			continue;
> +		}
> +		if (checklist && !test_device(fullpath)){
> +			continue;
> +		}
> +		fd =3D open(fullpath, O_RDONLY);
> +		if (fd < 0) {
> +			fprintf(stderr, "failed to read %s\n", fullpath);
> +			continue;
> +		}
> +		ret =3D btrfs_scan_one_device(fd, fullpath, &tmp_devices,
> +					    &num_devices,
> +					    BTRFS_SUPER_INFO_OFFSET);
> +		if (ret =3D=3D 0 && run_ioctl > 0) {
> +			btrfs_register_one_device(fullpath);
> +		}
> +		close(fd);
> +	}
> +
> +	fclose(proc_partitions);
> +	return 0;
> +}
> +
> +int btrfs_scan_one_dir_checklist(char *dirname, int run_ioctl, int check=
list)
>  {
>  	DIR *dirp =3D NULL;
>  	struct dirent *dirent;
> @@ -848,6 +1028,9 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
>  	struct btrfs_fs_devices *tmp_devices;
>  	u64 num_devices;
> =20
> +	if(checklist)
> +		init_device_checklist(BTRFSDEVICELIST);
> +
>  	INIT_LIST_HEAD(&pending_list);
> =20
>  	pending =3D malloc(sizeof(*pending));
> @@ -867,7 +1050,8 @@ again:
>  	}
>  	dirp =3D opendir(dirname);
>  	if (!dirp) {
> -		fprintf(stderr, "Unable to open /sys/block for scanning\n");
> +		fprintf(stderr, "Unable to open '%s' for scanning\n",=20
> +			dirname);
>  		return -ENOENT;
>  	}
>  	while(1) {
> @@ -900,6 +1084,9 @@ again:
>  		if (!S_ISBLK(st.st_mode)) {
>  			continue;
>  		}
> +		if (checklist && !test_device(fullpath)){
> +			continue;
> +		}
>  		fd =3D open(fullpath, O_RDONLY);
>  		if (fd < 0) {
>  			fprintf(stderr, "failed to read %s\n", fullpath);
> @@ -929,6 +1116,11 @@ fail:
>  	return ret;
>  }
> =20
> +int btrfs_scan_one_dir(char *dirname, int run_ioctl)
> +{
> +	return btrfs_scan_one_dir_checklist(dirname, run_ioctl, 0);
> +}
> +
>  int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_d=
evs,
>  			int run_ioctls)
>  {
> diff --git a/utils.h b/utils.h
> index 9dce5b0..b815f9b 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -36,8 +36,13 @@ int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_de=
vices,=20
> u64=20
> total_devs,
>  			int run_ioctls);
>  void btrfs_register_one_device(char *fname);
>  int btrfs_scan_one_dir(char *dirname, int run_ioctl);
> +int btrfs_scan_one_dir_checklist(char *dirname, int run_ioctl, int check=
list);
>  int check_mounted(const char *devicename);
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>  				 int super_offset);
>  char *pretty_sizes(u64 size);
> +int btrfs_scan_block_devices(int run_ioctl, int checklist);
> +
> +#define BTRFSDEVICELIST "/etc/btrfs.devices"
> +
>  #endif
>=20
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, --- =20
                and a natural deficiency in moral fibre.                =20

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN9TUtIKyzvlFcI40RApWBAJ0aPB5B/MnGRdnfMNcxQyQm/t3jdwCcDcsQ
h4cJ7GY8IwDgxDeCegV+FtM=
=Yb6g
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
