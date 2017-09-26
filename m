Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965948AbdIZNQl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 09:16:41 -0400
Subject: Re: [PATCH 4/4] btrfs-progs: subvol: fix subvol del --commit-after
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
 <25a01901-b2b0-35f1-6cc7-0c1d173a28e4@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dfdecd53-cdc4-a428-06d6-8eacab012da0@gmx.com>
Date: Tue, 26 Sep 2017 21:16:30 +0800
MIME-Version: 1.0
In-Reply-To: <25a01901-b2b0-35f1-6cc7-0c1d173a28e4@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 13:46, Misono, Tomohiro wrote:
> Fix subvol del --commit-after to work properly:
>   - SYNC ioctl will be issued even when last delete is failed
>   - SYNC ioctl will be issued on each file system only once in the end
> 
> To achieve this, get_fsid() and add_seen_fsid() is called after each delete
> to keep only one fd for each fs.
> 
> In the end, seen_fsid_hash will be traversed and SYNC is issued on each fs.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>   cmds-subvolume.c | 77 ++++++++++++++++++++++++++++++++++++++++----------------
>   1 file changed, 56 insertions(+), 21 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 666f6e0..bcbd737 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -263,6 +263,10 @@ static int cmd_subvol_delete(int argc, char **argv)
>   	DIR	*dirstream = NULL;
>   	int verbose = 0;
>   	int commit_mode = 0;
> +	u8 fsid[BTRFS_FSID_SIZE];
> +	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
> +	struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
> +	enum { COMMIT_AFTER = 1, COMMIT_EACH = 2 };
>   
>   	while (1) {
>   		int c;
> @@ -279,10 +283,10 @@ static int cmd_subvol_delete(int argc, char **argv)
>   
>   		switch(c) {
>   		case 'c':
> -			commit_mode = 1;
> +			commit_mode = COMMIT_AFTER;
>   			break;
>   		case 'C':
> -			commit_mode = 2;
> +			commit_mode = COMMIT_EACH;

The commit_mode cleanup can be a separate patch.
(More patches always look cooler)

Other part looks good enough.
Feel free to add my reviewed by tags after splitting the cleanup patch.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu
>   			break;
>   		case 'v':
>   			verbose++;
> @@ -298,7 +302,7 @@ static int cmd_subvol_delete(int argc, char **argv)
>   	if (verbose > 0) {
>   		printf("Transaction commit: %s\n",
>   			!commit_mode ? "none (default)" :
> -			commit_mode == 1 ? "at the end" : "after each");
> +			commit_mode == COMMIT_AFTER ? "at the end" : "after each");
>   	}
>   
>   	cnt = optind;
> @@ -338,50 +342,81 @@ again:
>   	}
>   
>   	printf("Delete subvolume (%s): '%s/%s'\n",
> -		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
> -		? "commit" : "no-commit", dname, vname);
> +		commit_mode == COMMIT_EACH ? "commit" : "no-commit", dname, vname);
>   	memset(&args, 0, sizeof(args));
>   	strncpy_null(args.name, vname);
>   	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
> -	if(res < 0 ){
> +	if (res < 0) {
>   		error("cannot delete '%s/%s': %s", dname, vname,
>   			strerror(errno));
>   		ret = 1;
>   		goto out;
>   	}
>   
> -	if (commit_mode == 1) {
> +	if (commit_mode == COMMIT_EACH) {
>   		res = wait_for_commit(fd);
>   		if (res < 0) {
> -			error("unable to wait for commit after '%s': %s",
> +			error("unable to wait for commit after deleting '%s': %s",
>   				path, strerror(errno));
>   			ret = 1;
>   		}
> +	} else if (commit_mode == COMMIT_AFTER) {
> +		res = get_fsid(dname, fsid, 0);
> +		if (res < 0) {
> +			error("unable to get fsid for '%s': %s", path, strerror(-res));
> +			error("delete suceeded but commit may not be done in the end");
> +			ret = 1;
> +			goto out;
> +		}
> +
> +		if (add_seen_fsid(fsid, seen_fsid_hash, fd, dirstream) == 0) {
> +			if (verbose > 0) {
> +				uuid_unparse(fsid, uuidbuf);
> +				printf("  new fs is found for '%s', fsid: %s\n", path, uuidbuf);
> +			}
> +			// this is the first time a subvolume on this filesystem is deleted
> +			// keep fd in order to issue SYNC ioctl in the end
> +			goto keep_fd;
> +		}
>   	}
>   
>   out:
> +	close_file_or_dir(fd, dirstream);
> +keep_fd:
> +	fd = -1;
> +	dirstream = NULL;
>   	free(dupdname);
>   	free(dupvname);
>   	dupdname = NULL;
>   	dupvname = NULL;
>   	cnt++;
> -	if (cnt < argc) {
> -		close_file_or_dir(fd, dirstream);
> -		/* avoid double free */
> -		fd = -1;
> -		dirstream = NULL;
> +	if (cnt < argc)
>   		goto again;
> -	}
>   
> -	if (commit_mode == 2 && fd != -1) {
> -		res = wait_for_commit(fd);
> -		if (res < 0) {
> -			error("unable to do final sync after deletion: %s",
> -				strerror(errno));
> -			ret = 1;
> +	if (commit_mode == COMMIT_AFTER) {
> +		// traverse seen_fsid_hash and issue SYNC ioctl on each filesystem
> +		int slot;
> +		struct seen_fsid *seen;
> +
> +		for (slot = 0; slot < SEEN_FSID_HASH_SIZE; slot++) {
> +			seen = seen_fsid_hash[slot];
> +			while (seen) {
> +				res = wait_for_commit(seen->fd);
> +				if (res < 0) {
> +					uuid_unparse(seen->fsid, uuidbuf);
> +					error("unable to do final sync after deletion: %s, fsid: %s",
> +						strerror(errno), uuidbuf);
> +					ret = 1;
> +				} else if (verbose > 0) {
> +					uuid_unparse(seen->fsid, uuidbuf);
> +					printf("final sync is done for fsid: %s\n", uuidbuf);
> +				}
> +				seen = seen->next;
> +			}
>   		}
> +		// fd will also be closed in free_seen_fsid
> +		free_seen_fsid(seen_fsid_hash);
>   	}
> -	close_file_or_dir(fd, dirstream);
>   
>   	return ret;
>   }
> 
