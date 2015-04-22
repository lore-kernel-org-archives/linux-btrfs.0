Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965022AbbDVR1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 13:27:47 -0400
Date: Wed, 22 Apr 2015 19:27:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Lauri =?iso-8859-1?Q?V=F5sandi?= <lauri.vosandi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: optionally enforce chroot for btrfs receive
Message-ID: <20150422172745.GK4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
 <1429443988-16001-1-git-send-email-lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1429443988-16001-1-git-send-email-lauri.vosandi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 19, 2015 at 02:46:28PM +0300, Lauri Võsandi wrote:
> This patch forces btrfs receive to issue chroot before
> parsing the btrfs stream using command-line flag -C
> to confine the process and minimize damage that could
> be done via malicious btrfs stream.
> 
> Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>

Applied with some updates, thanks.

> -	/*
> -	 * find_mount_root returns a root_path that is a subpath of
> -	 * dest_dir_full_path. Now get the other part of root_path,
> -	 * which is the destination dir relative to root_path.
> -	 */
> -	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
> -	while (r->dest_dir_path[0] == '/')
> -		r->dest_dir_path++;

This goes to the 'else' branch of the 'if' below.

> +	if (r->dest_dir_chroot) {
> +		if (chroot(dest_dir_full_path)) {
> +			ret = -errno;
> +			fprintf(stderr,
> +				"ERROR: failed to chroot to %s, %s\n",
> +				dest_dir_full_path,
> +				strerror(-ret));
> +			goto out;
> +		}
> +		if(chdir("/")) {
> +			ret = -errno;
> +			fprintf(stderr,
> +				"ERROR: failed to chdir to /, %s\n",
> +				strerror(-ret));
> +			goto out;
> +		}
> +		if (g_verbose >= 1) {
> +			fprintf(stderr, "chrooted to %s\n",
> +				dest_dir_full_path);
> +		}
> +		r->root_path = r->dest_dir_path = strdup("/");
> +	}
> -		c = getopt_long(argc, argv, "evf:", long_opts, NULL);
> +		c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);

added the long option --chroot
