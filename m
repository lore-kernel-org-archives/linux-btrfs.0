From: Chris Mason <chris.mason@oracle.com>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Wed, 9 Nov 2011 09:27:39 -0500
Message-ID: <20111109142739.GP4149@shiny>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
 <orzkgfwlom.fsf@livre.localdomain>
 <CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
 <CANkykrCfvFH_fg+5vJVkoWgcPuFp6euzVxZPTRDf=U+qrYUipA@mail.gmail.com>
 <20111108172043.GH4954@shiny>
 <CANkykrDtHRDe0ve53dkxeNcCeTuWY0i1-8m1SR6BN8Md7F4qGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs@vger.kernel.org
To: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANkykrDtHRDe0ve53dkxeNcCeTuWY0i1-8m1SR6BN8Md7F4qGQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 12:19:58PM -0200, Gustavo Sverzut Barbieri wrot=
e:
> On Tue, Nov 8, 2011 at 3:20 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > On Tue, Nov 08, 2011 at 03:08:41PM -0200, Gustavo Sverzut Barbieri =
wrote:
> >> On Tue, Nov 1, 2011 at 9:20 PM, Gustavo Sverzut Barbieri
> >> <barbieri@gmail.com> wrote:
> >> > On Tue, Nov 1, 2011 at 7:57 PM, Alexandre Oliva <oliva@lsd.ic.un=
icamp.br> wrote:
> >> >> Hi, Gustavo,
> >> >>
> >> >> On Nov =A01, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.com=
> wrote:
> >> >>
> >> >>> =A0 btrfs csum failed ino 2957021 extent 85041815552 csum 6673=
10679
> >> >>> wanted 0 mirror 0
> >> >>
> >> >>> Is there any way to recover it? =A0:-S
> >> >>
> >> >> Did you try mounting without data checksums?
> >> >
> >> > Just tried to mount with -o nodatasum, no luck. Is that enough?
> >>
> >> Ideas? Should I give up and consider data lost? :-(
> >
> > We actually check the crcs even when mounted with nodatasum. =A0Can=
 you
> > give the restore tool a shot from my current btrfs-progs git repo? =
=A0If
> > it can read it we can find a way to get the files off.
>=20
> Hi Chris,
>=20
> Fortunately it worked and I've restored, it misses symbolic links and
> executable permissions (or I did a mistake somewhere, like mounting)
> but overall it's all fine.

Great to hear you've pulled the files.  Do you need the kernel patch fo=
r
symlinks etc?

>=20
> The attached patch was helpful to let me ignore stuff like developmen=
t
> files and caches. Speeds up the recovery :-)

Very nice, thanks.

-chris

>=20
> Thanks!
>=20
> --=20
> Gustavo Sverzut Barbieri
> --------------------------------------
> Mobile: +55 (19) 9225-2202
> Contact: http://www.gustavobarbieri.com.br/contact

> From dc57b73b08fefb21099cc6b171683daaffa04501 Mon Sep 17 00:00:00 200=
1
> From: Gustavo Sverzut Barbieri <barbieri@profusion.mobi>
> Date: Mon, 8 Jan 2001 00:37:39 -0200
> Subject: [PATCH] restore: allow ignoring file name patterns and paths=
=2E
>=20
> Introduce two new command line switches that can be specified multipl=
e
> times:
>=20
>    -e path-pattern
>    -E file-name-pattern
>=20
> They are processed with fnmatch(), the first (-e) using FNM_PATHNAME
> flag on the whole path string, the second uses no flag and is applied
> only over the file or directory name.
>=20
> Example:
>=20
>    restore -v \
>       -e '*/.cache' -e '*/.thumbnails' \
>       -e '*/Desktop/Pictures' \
>       -E '*~' \
>       /dev/sdb1 /tmp/home-restore
>=20
> will restore everything but files under ~/.cache, ~/.thumbnails and
> ~/Desktop/Pictures for every user (assume it's the mountpoint of
> /home), also ignoring every backup file (*~).
> ---
>  restore.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++--
>  1 files changed, 53 insertions(+), 2 deletions(-)
>=20
> diff --git a/restore.c b/restore.c
> index 250c9d3..bdb0c7f 100644
> --- a/restore.c
> +++ b/restore.c
> @@ -25,6 +25,7 @@
>  #include <fcntl.h>
>  #include <sys/stat.h>
>  #include <zlib.h>
> +#include <fnmatch.h>
>  #include "kerncompat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -40,6 +41,9 @@ static int get_snaps =3D 0;
>  static int verbose =3D 0;
>  static int ignore_errors =3D 0;
>  static int overwrite =3D 0;
> +static char **exclude_paths =3D NULL;
> +static char **exclude_patterns =3D NULL;
> +static int dir_name_len =3D 0;
> =20
>  static int decompress(char *inbuf, char *outbuf, u64 compress_len,
>  		      u64 decompress_len)
> @@ -436,6 +440,27 @@ set_size:
>  	return 0;
>  }
> =20
> +static int is_excluded(const char *path, const char *name)
> +{
> +        char **itr;
> +        if (exclude_paths) {
> +                path +=3D dir_name_len;
> +                for (itr =3D exclude_paths; *itr !=3D NULL; itr++) {
> +                        if (fnmatch(*itr, path, FNM_PATHNAME) =3D=3D=
 0) {
> +                                return 1;
> +                        }
> +                }
> +        }
> +        if (exclude_patterns) {
> +                for (itr =3D exclude_patterns; *itr !=3D NULL; itr++=
) {
> +                        if (fnmatch(*itr, path, 0) =3D=3D 0) {
> +                                return 1;
> +                        }
> +                }
> +        }
> +        return 0;
> +}
> +
>  static int search_dir(struct btrfs_root *root, struct btrfs_key *key=
,
>  		      const char *dir)
>  {
> @@ -568,6 +593,11 @@ static int search_dir(struct btrfs_root *root, s=
truct btrfs_key *key,
>  				}
>  				ret =3D 0;
>  			}
> +                        if (is_excluded(path_name, filename)) {
> +                                if (verbose)
> +                                        printf("Ignored %s\n", path_=
name);
> +                                goto next;
> +                        }
>  			if (verbose)
>  				printf("Restoring %s\n", path_name);
>  			fd =3D open(path_name, O_CREAT|O_WRONLY, 0644);
> @@ -636,6 +666,11 @@ static int search_dir(struct btrfs_root *root, s=
truct btrfs_key *key,
>  				location.objectid =3D BTRFS_FIRST_FREE_OBJECTID;
>  			}
> =20
> +                        if (is_excluded(path_name, filename)) {
> +                                if (verbose)
> +                                        printf("Ignored %s\n", path_=
name);
> +                                goto next;
> +                        }
>  			if (verbose)
>  				printf("Restoring %s\n", path_name);
> =20
> @@ -672,7 +707,7 @@ next:
> =20
>  static void usage()
>  {
> -	fprintf(stderr, "Usage: restore [-svio] [-t disk offset] <device> "
> +	fprintf(stderr, "Usage: restore [-svio] [-e exclude-paths] [-E excl=
ude-name-patterns] [-t disk offset] <device> "
>  		"<directory>\n");
>  }
> =20
> @@ -765,8 +800,15 @@ int main(int argc, char **argv)
>  	int opt;
>  	int super_mirror =3D 0;
>  	int find_dir =3D 0;
> +        int exclude_paths_idx =3D 0;
> +        int exclude_patterns_idx =3D 0;
> =20
> -	while ((opt =3D getopt(argc, argv, "sviot:u:df:")) !=3D -1) {
> +        if (argc > 1) {
> +                exclude_paths =3D calloc(argc - 1, sizeof(char *));
> +                exclude_patterns =3D calloc(argc - 1, sizeof(char *)=
);
> +        }
> +
> +	while ((opt =3D getopt(argc, argv, "sviot:u:df:e:E:")) !=3D -1) {
>  		switch (opt) {
>  			case 's':
>  				get_snaps =3D 1;
> @@ -806,6 +848,14 @@ int main(int argc, char **argv)
>  					exit(1);
>  				}
>  				break;
> +			case 'e':
> +				exclude_paths[exclude_paths_idx] =3D strdup(optarg);
> +                                exclude_paths_idx++;
> +				break;
> +			case 'E':
> +				exclude_patterns[exclude_patterns_idx] =3D strdup(optarg);
> +                                exclude_patterns_idx++;
> +				break;
>  			case 'd':
>  				find_dir =3D 1;
>  				break;
> @@ -855,6 +905,7 @@ int main(int argc, char **argv)
>  			break;
>  		dir_name[len - 1] =3D '\0';
>  	}
> +        dir_name_len =3D strlen(dir_name);
> =20
>  	if (find_dir) {
>  		ret =3D find_first_dir(root, &key.objectid);
> --=20
> 1.7.7.1
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
