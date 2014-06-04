Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33351 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbaFDBoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 21:44:07 -0400
Message-ID: <538E7905.5070509@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 09:40:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fsck: report each critical root corruption
 separately
References: <1401813467-31009-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1401813467-31009-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/2014 12:37 AM, David Sterba wrote:
> Explicitly say which critical root is corrupted. It is possible to
> repair or reset some of the roots with a special option.
David, thanks for doing this:-)
>
> CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
> Patch based on the fsck branch from integration with other fsck fixes,
> namely "Btrfs-progs: fsck: deal with corrupted csum root"
>
>   cmds-check.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index b62132f22e84..58e5322bfe96 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6933,10 +6933,18 @@ int cmd_check(int argc, char **argv)
>   	uuid_unparse(info->super_copy->fsid, uuidbuf);
>   	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
>   
> -	if (!extent_buffer_uptodate(info->tree_root->node) ||
> -	    !extent_buffer_uptodate(info->dev_root->node) ||
> -	    !extent_buffer_uptodate(info->chunk_root->node)) {
> -		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
> +	if (!extent_buffer_uptodate(info->tree_root->node)) {
> +		fprintf(stderr, "Critical root (tree_root) corrupted, unable to continue\n");
> +		ret = -EIO;
> +		goto close_out;
> +	}
> +	if (!extent_buffer_uptodate(info->dev_root->node)) {
> +		fprintf(stderr, "Critical root (dev_root) corrupted, unable to continue\n");
> +		ret = -EIO;
> +		goto close_out;
> +	}
> +	if(!extent_buffer_uptodate(info->chunk_root->node)) {
> +		fprintf(stderr, "Critical root (chunk_root) corrupted, unable to continue\n");
>   		ret = -EIO;
>   		goto close_out;
>   	}
> @@ -6959,10 +6967,10 @@ int cmd_check(int argc, char **argv)
>   		}
>   
>   		if (init_csum_tree) {
> -			fprintf(stderr, "Reinit crc root\n");
> +			fprintf(stderr, "Reinitialize csum_root\n");
>   			ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
>   			if (ret) {
> -				fprintf(stderr, "crc root initialization failed\n");
> +				fprintf(stderr, "ERROR: csum_root initialization failed\n");
>   				ret = -EIO;
>   				goto close_out;
>   			}
> @@ -6976,12 +6984,12 @@ int cmd_check(int argc, char **argv)
>   			goto close_out;
>   	}
>   	if (!extent_buffer_uptodate(info->extent_root->node)) {
> -		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
> +		fprintf(stderr, "Critical root (extent_root) corrupted, unable to continue\n");
>   		ret = -EIO;
>   		goto close_out;
>   	}
>   	if (!extent_buffer_uptodate(info->csum_root->node)) {
> -		fprintf(stderr, "Checksum root corrupted, rerun with --init-csum-tree option\n");
> +		fprintf(stderr, "Checksum root (csum_root) corrupted, unable to continue\n");
>   		ret = -EIO;
>   		goto close_out;
>   	}

