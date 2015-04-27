Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:45708 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbbD0H2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 03:28:19 -0400
Message-ID: <553DE512.7080606@giantdisaster.de>
Date: Mon, 27 Apr 2015 09:28:18 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: =?UTF-8?B?TGF1cmkgVsO1c2FuZGk=?= <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
In-Reply-To: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 26 Apr 2015 12:12:45 +0200, Lauri Võsandi wrote:
> This patch adds command-line flag -p to btrfs receive
> which makes it possible to disable automatic parent
> search for incremental snapshots and use explicitly
> specified path instead.
> 
> Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
> ---
>  cmds-receive.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
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
>  
>  	struct subvol_info *cur_subvol;
> @@ -220,20 +221,32 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>  		fprintf(stderr, "receiving snapshot %s uuid=%s, "
>  				"ctransid=%llu ", path, uuid_str,
>  				r->cur_subvol->stransid);
> -		uuid_unparse(parent_uuid, uuid_str);
> -		fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
> -				uuid_str, parent_ctransid);
>  	}
>  
>  	memset(&args_v2, 0, sizeof(args_v2));
>  	strncpy_null(args_v2.name, path);
>  
> -	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
> -			parent_ctransid, NULL, subvol_search_by_received_uuid);
> -	if (!parent_subvol) {
> +	if (r->explicit_parent_path) {
> +		if (g_verbose) {
> +			fprintf(stderr, "using explicit parent %s\n",
> +					r->explicit_parent_path);
> +		}
> +		parent_subvol = subvol_uuid_search(&r->sus, 0, NULL,
> +			0, r->explicit_parent_path, subvol_search_by_path);

This won't work if you receive more than one snapshot, each one derived
from the previous one ("btrfs send -e snap1 snap2 snap3 snap4"). You
would always use the first one as the parent, not the predecessor.
That's implemented differently for the -p option in
git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git


> +	} else {
> +		if (g_verbose) {
> +			uuid_unparse(parent_uuid, uuid_str);
> +			fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
> +					uuid_str, parent_ctransid);
> +		}
>  		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
> -				parent_ctransid, NULL, subvol_search_by_uuid);
> +			parent_ctransid, NULL, subvol_search_by_received_uuid);
> +		if (!parent_subvol) {
> +			parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
> +					parent_ctransid, NULL, subvol_search_by_uuid);
> +		}

This used to be a search for the received_uuid only. Why is this code
changed like this in the branch that is executed when -p is not
specified, in a patch that has the goal to add -p with new functionality
if -p is specified?


>  	}
> +
>  	if (!parent_subvol) {
>  		ret = -ENOENT;
>  		fprintf(stderr, "ERROR: could not find parent subvolume\n");
> @@ -962,11 +975,14 @@ int cmd_receive(int argc, char **argv)
>  			{ NULL, 0, NULL, 0 }
>  		};
>  
> -		c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);
> +		c = getopt_long(argc, argv, "Cevf:p:", long_opts, NULL);
>  		if (c < 0)
>  			break;
>  
>  		switch (c) {
> +		case 'p':
> +			r.explicit_parent_path = optarg;
> +			break;
>  		case 'v':
>  			g_verbose++;
>  			break;
> @@ -1028,6 +1044,8 @@ const char * const cmd_receive_usage[] = {
>  	"                 in the data stream. Without this option,",
>  	"                 the receiver terminates only if an error",
>  	"                 is recognized or on EOF.",
> +	"-p <subvol>      Disables the automatic searching for parents",
> +	"                 if incremental streams are received.",
>  	"-C|--chroot      confine the process to <mount> using chroot",
>  	"--max-errors <N> Terminate as soon as N errors happened while",
>  	"                 processing commands from the send stream.",
> 

