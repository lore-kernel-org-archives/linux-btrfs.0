Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11390 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbbL3VH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 16:07:59 -0500
Date: Wed, 30 Dec 2015 16:07:36 -0500
From: Chris Mason <clm@fb.com>
To: Nicholas Krause <xerofoify@gmail.com>
CC: <jbacik@fb.com>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] btrfs:Fix incorrect return statement if failure
 occurs in the function  btrfs_mark_extent_written
Message-ID: <20151230210736.24bgnuxycchlsusd@ret.masoncoding.com>
References: <1451438447-23679-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1451438447-23679-1-git-send-email-xerofoify@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 08:20:47PM -0500, Nicholas Krause wrote:
> This fixes the incorrect return statement if failure occurs by
> returning 0 rather then the variable ret which may hold a error
> code to signal when a failure has occurred in the function
> btrfs_mark_extent_written to its callers rather then always
> making this function appear to run successfully to its callers
> by always returning zero.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/btrfs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index b823fac..7a9ab8e 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1276,7 +1276,7 @@ again:
>  	}
>  out:
>  	btrfs_free_path(path);
> -	return 0;
> +	return ret;
>  }

We're checking ret higher up and aborting the transaction properly.
There is at least one place ret will be non-zero above that isn't an
error, but you're passing it to the caller here making them think it has
gone wrong.

-chris

