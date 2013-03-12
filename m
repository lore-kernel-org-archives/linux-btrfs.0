Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab3CLQRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 12:17:25 -0400
Date: Tue, 12 Mar 2013 09:16:42 -0700
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: clean up transaction abort messages
Message-ID: <20130312161642.GT3565@lenny.home.zabbo.net>
References: <1363099568-29013-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363099568-29013-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> * clean up btrfs_decode_error and callers

> -static const char *btrfs_decode_error(int errno, char nbuf[16])
> +static const char *btrfs_decode_error(int errno)
>  {
> -	char *errstr = NULL;
> +	char *errstr = "unknown";
>  
>  	switch (errno) {
>  	case -EIO:
> @@ -80,12 +80,6 @@ static const char *btrfs_decode_error(int errno, char nbuf[16])
>  	case -EEXIST:
>  		errstr = "Object already exists";
>  		break;
> -	default:
> -		if (nbuf) {
> -			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
> -				errstr = nbuf;
> -		}
> -		break;
>  	}
>  
>  	return errstr;

Cool, thanks for cleaning that up.

- z
