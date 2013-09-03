Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53809 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3ICNN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 09:13:27 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so6416777pab.41
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 06:13:26 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] btrfs-progs: tidy up cmd_subvol_create() whitespace & returns
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1378213291-1034-1-git-send-email-wangshilong1991@gmail.com>
Date: Tue, 3 Sep 2013 21:13:20 +0800
Cc: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <0A5B4F8C-8B08-4976-A660-6396407E932D@gmail.com>
References: <1378213291-1034-1-git-send-email-wangshilong1991@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Eric,

Recently, i notice btrfs-progs's magic return value. For example, EACCESS return 12.
Magic return value is confusing for code reviewers. However,at least we should guarantee
all these conditions return the same value(for example 12 for this case)

Or we can change all the magic number to 1. Miao reminded me that
there may be some applications that have catched and checked these
magic return values¡­

Any ideas about this?

Thanks,
Wang
> From:
> Just whitespace fixes, and magical return value removal.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> cmds-subvolume.c | 18 +++++++++---------
> 1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 01b982c..a9999ac 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -104,9 +104,9 @@ static int cmd_subvol_create(int argc, char **argv)
> 	dst = argv[optind];
> 
> 	res = test_isdir(dst);
> -	if(res >= 0 ){
> +	if (res >= 0) {
> 		fprintf(stderr, "ERROR: '%s' exists\n", dst);
> -		return 12;
> +		return 1;
> 	}
> 
> 	newname = strdup(dst);
> @@ -114,24 +114,24 @@ static int cmd_subvol_create(int argc, char **argv)
> 	dstdir = strdup(dst);
> 	dstdir = dirname(dstdir);
> 
> -	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
> +	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
> 	     strchr(newname, '/') ){
> 		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
> 			newname);
> -		return 14;
> +		return 1;
> 	}
> 
> 	len = strlen(newname);
> 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
> 		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
> 			newname);
> -		return 14;
> +		return 1;
> 	}
> 
> 	fddst = open_file_or_dir(dstdir);
> 	if (fddst < 0) {
> 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
> -		return 12;
> +		return 1;
> 	}
> 
> 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
> @@ -159,10 +159,10 @@ static int cmd_subvol_create(int argc, char **argv)
> 	close(fddst);
> 	free(inherit);
> 
> -	if(res < 0 ){
> -		fprintf( stderr, "ERROR: cannot create subvolume - %s\n",
> +	if (res < 0) {
> +		fprintf(stderr, "ERROR: cannot create subvolume - %s\n",
> 			strerror(e));
> -		return 11;
> +		return 1;
> 	}
> 
> 	return 0;
> -- 
> 1.7.11.7
> 

