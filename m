Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36015 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbcKWE5t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 23:57:49 -0500
Received: by mail-pg0-f47.google.com with SMTP id f188so1429613pgc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 20:57:49 -0800 (PST)
Date: Tue, 22 Nov 2016 20:49:41 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: [PATCH v2] fideduperange.2: fix the discussion of maximum sizes
Message-ID: <20161123044941.GB27107@mew>
References: <20161123044816.GG16807@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123044816.GG16807@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 08:48:16PM -0800, Darrick J. Wong wrote:
> Fix the discussion of the limitations on the dest_count and src_length
> parameters to the fideduperange ioctl to reflect what's actually in the
> kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man2/ioctl_fideduperange.2 |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
> index 2112d10..057229d 100644
> --- a/man2/ioctl_fideduperange.2
> +++ b/man2/ioctl_fideduperange.2
> @@ -95,7 +95,7 @@ struct file_dedupe_range_info {
>  .in
>  
>  Each deduplication operation targets
> -.IR length
> +.IR src_length
>  bytes in file descriptor
>  .IR dest_fd
>  at offset
> @@ -108,8 +108,15 @@ During the call,
>  must be open for reading and
>  .IR dest_fd
>  must be open for writing.
> -For any call to this ioctl, there may not be more than 65,536
> -requests attached; each request may not exceed 16MiB.
> +The combined size of the struct
> +.IR file_dedupe_range
> +and the struct
> +.IR file_dedupe_range_info
> +array must not exceed the system page size.
> +The maximum size of
> +.IR src_length
> +is filesystem dependent and is typically 16MiB.
> +This limit will be enforced silently by the filesystem.
>  By convention, the storage used by
>  .IR src_fd
>  is mapped into
> @@ -144,6 +151,13 @@ is set to indicate the error.
>  .SH ERRORS
>  Error codes can be one of, but are not limited to, the following:
>  .TP
> +.B ENOMEM
> +The kernel was unable to allocate sufficient memory to perform the
> +operation or
> +.IR dest_count
> +is so large that the input argument description spans more than a single
> +page of memory.
> +.TP
>  .B EBADF
>  .IR src_fd
>  is not open for reading;

Reviewed-by: Omar Sandoval <osandov@fb.com>

-- 
Omar
