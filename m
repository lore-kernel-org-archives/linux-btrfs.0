Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49239 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab2JEKDL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 06:03:11 -0400
Date: Fri, 5 Oct 2012 12:02:55 +0200
From: David Sterba <dave@jikos.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs: fix error processing in btrfs_set_acl()
Message-ID: <20121005100255.GC14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <201210050935.AA00014@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201210050935.AA00014@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Oct 05, 2012 at 06:35:07PM +0900, Tsutomu Itoh wrote:
> The error is only returned when kmalloc() fails.
> Therefore, to return the error to the caller directly here, I changed the code.

  "fix error processing in btrfs_set_acl()"

what bug does it 'fix' ? IMHO this is a minor cleanup that is not much
needed. The return path after 'posix_acl_to_xattr' uses the if/goto
pattern in the same if (acl) { ... } block, visually this does not help
the original code is correct and "looks ok".
  
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -136,10 +136,8 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
>  	if (acl) {
>  		size = posix_acl_xattr_size(acl->a_count);
>  		value = kmalloc(size, GFP_NOFS);
> -		if (!value) {
> -			ret = -ENOMEM;
> -			goto out;
> -		}
> +		if (!value)
> +			return -ENOMEM;
>  
>  		ret = posix_acl_to_xattr(acl, value, size);
>  		if (ret < 0)


david
