Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:65136 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3BZSph (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 13:45:37 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so2587133eei.7
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 10:45:36 -0800 (PST)
Message-ID: <512D031D.20408@gmail.com>
Date: Tue, 26 Feb 2013 19:46:53 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-17-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-17-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On 02/25/2013 11:54 PM, Eric Sandeen wrote:
> Rearrange cmd_subvol_set_default() slightly so we
> don't have to close the fd on an error return.
> 
> While we're at it, fix whitespace & remove magic
> return values.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  cmds-subvolume.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 0dfaefe..461eed9 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -712,24 +712,25 @@ static int cmd_subvol_set_default(int argc, char **argv)
>  	subvolid = argv[1];
>  	path = argv[2];
>  
> +	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);

Could you replace strtoll() with strtoull() ? Note that:

strtoull("0xffffffffffffffff",0,0)  == 0xffffffffffffffff
strtoull("-1",0,0)  == 0xffffffffffffffff
strtoll("-1",0,0)  == 0xffffffffffffffff
strtoll("0xffffffffffffffff",0,0)  -> ERANGE

> +	if (errno == ERANGE) {

Pay attention that if strtoull() doesn't encounter a problem errno *is
not* touched: this check could catch a previous error. I don't know if
it is an hole in the standard or a bug in the gnu-libc; however I think
that before strtoXll() we should put 'errno = 0;'.

> +		fprintf(stderr, "ERROR: invalid tree id (%s)\n", subvolid);
> +		return 1;
> +	}
> +
>  	fd = open_file_or_dir(path);
>  	if (fd < 0) {
>  		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -		return 12;
> +		return 1;
>  	}
>  
> -	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
> -	if (errno == ERANGE) {
> -		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
> -		return 30;
> -	}
>  	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
>  	e = errno;
>  	close(fd);
> -	if( ret < 0 ){
> +	if (ret < 0) {
>  		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
>  			strerror(e));
> -		return 30;
> +		return 1;
>  	}
>  	return 0;
>  }


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
