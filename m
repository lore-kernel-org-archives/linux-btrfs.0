Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46060 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2FELBN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 07:01:13 -0400
Date: Tue, 5 Jun 2012 12:01:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs-progs] [bug][patch] Leaking file handle in scrub_fs_info()
Message-ID: <20120605110107.GF15986@carfax.org.uk>
References: <4F96F44B.8000400@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
In-Reply-To: <4F96F44B.8000400@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Goffredo,

   I'm trying to do a new integration branch, and the patch inline in
the text is corrupt (plus it has a massively verbose commit message):

Applying: Leaking file handle in scrub_fs_info()
fatal: corrupt patch at line 74
Patch failed at 0001 Leaking file handle in scrub_fs_info()

   Normally, I'd use your git repo to get round the fact that every
single patch you send by mail is whitespace-damaged, but:

error: Unable to find 337bfb3250203a66b953ffcf7804418cb7c72052 under http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
Cannot obtain needed commit 337bfb3250203a66b953ffcf7804418cb7c72052
while processing commit ee3832b47a4b1d1dce8d1cacc802db32901b8c45.
error: Fetch failed.

   Plus Jan had some suggested tweaks regarding whitespace -- could
you re-roll the patch and maybe see what you can do to fix your git
repo? (Or at least use git-send-email to send the patch so it doesn't
get mangled).

   Thanks,
   Hugo.

On Tue, Apr 24, 2012 at 08:43:23PM +0200, Goffredo Baroncelli wrote:
> I was giving a look to the function scrub_fs_info( ), and to me it seems
> that could be a potential file handle leaking problem.
> 
> 
> In fact:
> 
> static int scrub_fs_info(int fd, char *path,
>                     struct btrfs_ioctl_fs_info_args *fi_args,
>                     struct btrfs_ioctl_dev_info_args **di_ret)
> {
> 
> [...]
> 
>         ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
>         if (ret && errno == EINVAL) {
>                 /* path is no mounted btrfs. try if it's a device */
> [...]
>                 close(fd);			<--- Here the
> 						     file handle is
> 						     closed
> 
>                 fd = open_file_or_dir(mp);	<--- then it is
> 						     re-opened
>                 if (fd < 0)
>                         return -errno;
>         } else if (ret) {
>                 return -errno;
>         }
> [...]
> 
> But in the rest of the function:
> a) the file handle is not closed
> b) the (new) file handle isn't returned
> 
> The function "scrub_fs_info()" is called from the functions
> 1) cmd_scrub_status(), which doesn't use the file handle after the call
> to the cmd_scrub_status() [except for a close()]. So no problem at all.
> 2) scrub_start(), which uses the file handle after the call to the
> cmd_scrub_status() functions.
> 
> My suggestions is to change scrub_fs_info() to accept only the path.
> Then it open (and closes) its own (and private) the file descriptor.
> 
> Instead scrub_start(), opens a file descriptor after the call to the
> scrub_fs_info() function.
> 
> What do you think ?
> 
> BR
> G.Baroncelli
> 
> You can pull the patch below from
> 
> 	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
> 
> branch
> 
> 	fd-leaking
> 
> -----
> 
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index c4503f4..486768c 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -979,19 +979,26 @@ static int scrub_device_info(int fd, u64 devid,
>  	return ret ? -errno : 0;
>  }
> 
> -static int scrub_fs_info(int fd, char *path,
> +static int scrub_fs_info( char *path,
>  				struct btrfs_ioctl_fs_info_args *fi_args,
>  				struct btrfs_ioctl_dev_info_args **di_ret)
>  {
>  	int ret = 0;
>  	int ndevs = 0;
>  	int i = 1;
> +	int fd;
>  	struct btrfs_fs_devices *fs_devices_mnt = NULL;
>  	struct btrfs_ioctl_dev_info_args *di_args;
>  	char mp[BTRFS_PATH_NAME_MAX + 1];
> 
>  	memset(fi_args, 0, sizeof(*fi_args));
> 
> +	fd  = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return -1;
> +	}
> +
>  	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
>  	if (ret && errno == EINVAL) {
>  		/* path is no mounted btrfs. try if it's a device */
> @@ -1010,28 +1017,36 @@ static int scrub_fs_info(int fd, char *path,
>  		if (fd < 0)
>  			return -errno;
>  	} else if (ret) {
> +		close(fd);
>  		return -errno;
>  	}
> 
> -	if (!fi_args->num_devices)
> +	if (!fi_args->num_devices){
> +		close(fd);
>  		return 0;
> +	}
> 
>  	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
> -	if (!di_args)
> +	if (!di_args){
> +		close(fd);
>  		return -errno;
> +	}
> 
>  	for (; i <= fi_args->max_id; ++i) {
>  		BUG_ON(ndevs >= fi_args->num_devices);
>  		ret = scrub_device_info(fd, i, &di_args[ndevs]);
>  		if (ret == -ENODEV)
>  			continue;
> -		if (ret)
> +		if (ret){
> +			close(fd);
>  			return ret;
> +		}
>  		++ndevs;
>  	}
> 
>  	BUG_ON(ndevs == 0);
> 
> +	close(fd);
>  	return 0;
>  }
> 
> @@ -1155,7 +1170,7 @@ static int scrub_start(int argc, char **argv, int
> resume)
>  		return 12;
>  	}
> 
> -	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
> +	ret = scrub_fs_info(path, &fi_args, &di_args);
>  	if (ret) {
>  		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
>  		    "%s\n", strerror(-ret));
> @@ -1586,7 +1601,6 @@ static int cmd_scrub_status(int argc, char **argv)
>  		.sun_family = AF_UNIX,
>  	};
>  	int ret;
> -	int fdmnt;
>  	int i;
>  	int print_raw = 0;
>  	int do_stats_per_dev = 0;
> @@ -1615,13 +1629,7 @@ static int cmd_scrub_status(int argc, char **argv)
> 
>  	path = argv[optind];
> 
> -	fdmnt = open_file_or_dir(path);
> -	if (fdmnt < 0) {
> -		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -		return 12;
> -	}
> -
> -	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
> +	ret = scrub_fs_info(path, &fi_args, &di_args);
>  	if (ret) {
>  		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
>  				"%s\n", strerror(-ret));
> @@ -1698,7 +1706,6 @@ static int cmd_scrub_status(int argc, char **argv)
>  out:
>  	free_history(past_scrubs);
>  	free(di_args);
> -	close(fdmnt);
>  	if (fdres > -1)
>  		close(fdres);
> 
> 
> 
> 
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzebzIKyzvlFcI40RAsmLAKDJGtxZT/Q7InNzanStHaNA4HHrIwCgiV7y
WgMnijCwFlovlo/O8pMFS5w=
=5R0Q
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
