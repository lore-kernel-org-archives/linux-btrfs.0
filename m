Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59875 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3BAKaf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 05:30:35 -0500
Date: Fri, 1 Feb 2013 10:30:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
Message-ID: <20130201103031.GQ16285@carfax.org.uk>
References: <20130201095947.GA32445@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JaBjgNvtdKe5H086"
In-Reply-To: <20130201095947.GA32445@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JaBjgNvtdKe5H086
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 01, 2013 at 09:59:49AM +0000, Audrius Butkevicius wrote:
> Add '-b' and '--bytes' options to btrfs filesystem df and show, for easier
> integration with scripts. This causes all sizes to be displayed in decimal
> bytes instead of pretty-printed with human-readable suffices KB, MB, etc.

   Please, not this way.

   The right way to do this would be to modify the pretty-print
function so that it can output bytes or SI suffixes (kB, MB) or binary
suffixes (KiB, MiB).

   I'm fairly sure I posted a patch for this a couple of years ago.
There was some discussion then about the appropriate command-line
options to use. The options should also be applicable to fi show, and
to anything else which outputs byte counts.

   Note also that this may well clash with Goffredo's new free-space
display (which hasn't yet made it to David's integration tree, but
shouldn't be far away).

   Hugo.

> Signed-off-by: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
> ---
>  cmds-filesystem.c |   93 +++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 68 insertions(+), 25 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 507239a..9392209 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -40,7 +40,7 @@ static const char * const filesystem_cmd_group_usage[] = {
>  };
>  
>  static const char * const cmd_df_usage[] = {
> -	"btrfs filesystem df <path>",
> +	"btrfs filesystem df [-b|--bytes] <path>",
>  	"Show space usage information for a mount point",
>  	NULL
>  };
> @@ -53,11 +53,23 @@ static int cmd_df(int argc, char **argv)
>  	int fd;
>  	int e;
>  	char *path;
> +	int start = 1;
> +	int rawbytes = 0;
> +
> +	while (argc > start) {
> +		if (!strcmp(argv[start], "--bytes") ||
> +		    !strcmp(argv[start], "-b")) {
> +			rawbytes = 1;
> +			start += 1;
> +		} else {
> +			break;
> +		}
> +	}
>  
> -	if (check_argc_exact(argc, 2))
> +	if (check_argc_exact(argc, start + 1))
>  		usage(cmd_df_usage);
>  
> -	path = argv[1];
> +	path = argv[start];
>  
>  	fd = open_file_or_dir(path);
>  	if (fd < 0) {
> @@ -150,10 +162,18 @@ static int cmd_df(int argc, char **argv)
>  			written += 8;
>  		}
>  
> -		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
> -		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
> -		printf("%s: total=%s, used=%s\n", description, total_bytes,
> -		       used_bytes);
> +		if (rawbytes) {
> +			printf("%s: total=%llu, used=%llu\n", description,
> +			       (unsigned long long)sargs->spaces[i].total_bytes,
> +			       (unsigned long long)sargs->spaces[i].used_bytes);
> +		} else {
> +			total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
> +			used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
> +			printf("%s: total=%s, used=%s\n", description, total_bytes,
> +			       used_bytes);
> +			free(total_bytes);
> +			free(bytes_used);
> +		}
>  	}
>  	close(fd);
>  	free(sargs);
> @@ -182,7 +202,7 @@ static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
>  	return 0;
>  }
>  
> -static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
> +static void print_one_uuid(struct btrfs_fs_devices *fs_devices, int rawbytes)
>  {
>  	char uuidbuf[37];
>  	struct list_head *cur;
> @@ -199,25 +219,39 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>  	else
>  		printf("Label: none ");
>  
> -	super_bytes_used = pretty_sizes(device->super_bytes_used);
> -
>  	total = device->total_devs;
> -	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
> -	       (unsigned long long)total, super_bytes_used);
>  
> -	free(super_bytes_used);
> +	if (rawbytes) {
> +		printf(" uuid: %s\n\tTotal devices %llu FS bytes used %llu\n",
> +		       uuidbuf, (unsigned long long)total,
> +		       (unsigned long long)device->super_bytes_used);
> +	} else {
> +		super_bytes_used = pretty_sizes(device->super_bytes_used);
> +		printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n",
> +		       uuidbuf, (unsigned long long)total, super_bytes_used);
> +		free(super_bytes_used);
> +	}
>  
>  	list_for_each(cur, &fs_devices->devices) {
>  		char *total_bytes;
>  		char *bytes_used;
>  		device = list_entry(cur, struct btrfs_device, dev_list);
> -		total_bytes = pretty_sizes(device->total_bytes);
> -		bytes_used = pretty_sizes(device->bytes_used);
> -		printf("\tdevid %4llu size %s used %s path %s\n",
> -		       (unsigned long long)device->devid,
> -		       total_bytes, bytes_used, device->name);
> -		free(total_bytes);
> -		free(bytes_used);
> +		if (rawbytes) {
> +			printf("\tdevid %4llu size %llu used %llu path %s\n",
> +			       (unsigned long long)device->devid,
> +			       (unsigned long long)device->total_bytes,
> +			       (unsigned long long)device->bytes_used,
> +			       device->name);
> +		}
> +		else {
> +			total_bytes = pretty_sizes(device->total_bytes);
> +			bytes_used = pretty_sizes(device->bytes_used);
> +			printf("\tdevid %4llu size %s used %s path %s\n",
> +			       (unsigned long long)device->devid,
> +			       total_bytes, bytes_used, device->name);
> +			free(total_bytes);
> +			free(bytes_used);
> +		}
>  		devs_found++;
>  	}
>  	if (devs_found < total) {
> @@ -227,7 +261,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>  }
>  
>  static const char * const cmd_show_usage[] = {
> -	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
> +	"btrfs filesystem show [--all-devices] [-b|--bytes] [<uuid>|<label>]",
>  	"Show the structure of a filesystem",
>  	"If no argument is given, structure of all present filesystems is shown.",
>  	NULL
> @@ -240,12 +274,21 @@ static int cmd_show(int argc, char **argv)
>  	struct list_head *cur_uuid;
>  	char *search = 0;
>  	int ret;
> +	int rawbytes = 0;
>  	int checklist = 1;
>  	int searchstart = 1;
>  
> -	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
> -		checklist = 0;
> -		searchstart += 1;
> +	while (argc > searchstart) {
> +		if (!strcmp(argv[searchstart], "--all-devices")) {
> +			checklist = 0;
> +			searchstart += 1;
> +		} else if (!strcmp(argv[searchstart], "--bytes") ||
> +			    !strcmp(argv[searchstart], "-b")) {
> +			rawbytes = 1;
> +			searchstart += 1;
> +		} else {
> +			break;
> +		}
>  	}
>  
>  	if (check_argc_max(argc, searchstart + 1))
> @@ -270,7 +313,7 @@ static int cmd_show(int argc, char **argv)
>  					list);
>  		if (search && uuid_search(fs_devices, search) == 0)
>  			continue;
> -		print_one_uuid(fs_devices);
> +		print_one_uuid(fs_devices, rawbytes);
>  	}
>  	printf("%s\n", BTRFS_BUILD_VERSION);
>  	return 0;

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'm on a 30-day diet. So far I've lost 18 days. ---         

--JaBjgNvtdKe5H086
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQuZR79z9OVl50rAAQKaXQ//bZrOQrjWbvId3V0GBcCTCS3whznqIAQq
8g6agwqckA25dstI+zh97atWhMKPw+P3+nc5EkkZE0JCsPKoJtZJHb9VDbza3lrj
LAzlI80j2yTPVVVmP7R1sYr7P627EITogkrrB3JgvFpi17sq93TeJtYqD6iY0iMU
sExZSk6DTRq+1Rs8u+KLLtDc+vV45SUNqZB2w5ncP7jYr0EQrSvrJDfFLfvvh1Mf
ckYqW09CzXX7WAF4zryx6hiuwJqvo6eJcyZ5JtOms+oLYrHrrnTzI/rhE8NKLtZQ
aJiT0dDrjW7xEhmYbTs0mxhzVtZ2WC/DPhQNC8OWiWxcNnokEgpn/K3HPMD31aLG
HpwW/mnlBIlFK9AlVEBrAV91kikWufY1rwImNof8k03FVCFfDeL2ZSwS0O4UzdLl
Bxw9T0LJWMYUbiifddZ9Em/a3e453wHyVUYtz37+2B6lArPY8cXbQVUJwPP1U3JB
/pornZmc/CKQjQAlCZkJ9c55ipkRqh3wCDhMZWaxifttRrQ62kDw7oY2gFyJQgvz
BqpgV+BqIksgOzo78YHeKwsQIlQTl3bXHJC3LWzpoMj21XRt9HXBYjzDeubaWyBV
P00zC7qag872Uv7yRywCbP4VToSpdvxagFsEf/4Z+LboLbXjF37m00UMDiWHN8+e
P5Dkj6eK7iY=
=uqoz
-----END PGP SIGNATURE-----

--JaBjgNvtdKe5H086--
