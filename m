Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51526 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2JIPV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 11:21:58 -0400
Date: Tue, 9 Oct 2012 17:21:53 +0200
From: David Sterba <dave@jikos.cz>
To: Dieter Ries <mail@dieterries.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: btrfsck: Print feedback about fscking
 to stdout.
Message-ID: <20121009152153.GU4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
 <1349723270-12773-4-git-send-email-mail@dieterries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349723270-12773-4-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 09:07:49PM +0200, Dieter Ries wrote:
> Status reports of the checking process should be printed to stdout
> instead of stderr, as that is normal program output and not related to
> problems in btrfsck.

I agree that the important messages from fsck process should be printed
to stdout, and the rest like 'cannot find a valid fs on /dev' belong to
stderr so the user can simply call

  btrfsck > logfile

and does not miss any messages in the log, while will be informed that
the process cannot proceed for some urgent reason.

So far we all do 'btrfsck >& logfile' to be sure we don't miss
anythingk.

> Signed-off-by: Dieter Ries <mail@dieterries.net>
> ---
>  btrfsck.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/btrfsck.c b/btrfsck.c
> index 516bcdf..83275cd 100644
> --- a/btrfsck.c
> +++ b/btrfsck.c
> @@ -3559,7 +3559,7 @@ int main(int ac, char **av)
>  
>  	root = info->fs_root;
>  
> -	fprintf(stderr, "checking extents\n");
> +	printf("checking extents... ");
>  	if (rw)
>  		trans = btrfs_start_transaction(root, 1);
>  
> @@ -3567,22 +3567,32 @@ int main(int ac, char **av)
>  		fprintf(stderr, "Reinit crc root\n");
>  		ret = btrfs_fsck_reinit_root(trans, info->csum_root);
>  		if (ret) {
> +			printf("\n");

This looks strange, it's missing the context where it actually adds the
newline.

>  			fprintf(stderr, "crc root initialization failed\n");
^^^
this is IMHO another printf candidate, though btrfs_fsck_reinit_root
will not fail.

>  			return -EIO;
>  		}
>  		goto out;
>  	}
>  	ret = check_extents(trans, root, repair);
> -	if (ret)
> +	if (ret) {
>  		fprintf(stderr, "Errors found in extent allocation tree\n");

same here

> +		printf("\n");
> +	}
> +	else
> +		printf("Done!\n");
>  
> -	fprintf(stderr, "checking fs roots\n");
> +	printf("checking fs roots... ");

If you remove the newline, the output may be buffered and not visible
until the newline arrives

>  	ret = check_fs_roots(root, &root_cache);
> -	if (ret)
> +	if (ret) {
> +		printf("\n");
>  		goto out;
> +	}
> +	else

	} else {

> +		printf("Done!\n");

	}
>  
> -	fprintf(stderr, "checking root refs\n");
> +	printf("checking root refs... ");
>  	ret = check_root_refs(root, &root_cache);

Done, but what if ret is not zero? This goes unreported.

> +	printf("Done!\n");
>  out:
>  	free_root_recs(&root_cache);
>  	if (rw) {

I think doing the stdout/stderr split properly would need more than
fixing btrfsck.c, it uses code from other .c files, looks like an
overhaul of the logging in the whole codebase.

david
