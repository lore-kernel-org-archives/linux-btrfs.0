Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaHSOqc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 10:46:32 -0400
Date: Tue, 19 Aug 2014 16:46:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com, jbacik@fb.com
Subject: Re: [PATCH v4] Btrfs: send, lower mem requirements for processing
 xattrs
Message-ID: <20140819144630.GV1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407716706-5115-1-git-send-email-fdmanana@suse.com>
 <1407722975-18112-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407722975-18112-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 03:09:35AM +0100, Filipe Manana wrote:
> +		if (name_len + data_len > buf_len) {
> +			buf_len = name_len + data_len;
> +			if (is_vmalloc_addr(buf)) {
> +				vfree(buf);
> +				buf = NULL;
> +			} else {
> +				char *tmp = krealloc(buf, buf_len, GFP_NOFS);

This could fail with a warning (high order allocation) so I suggest to
add __GFP_NOWARN, the vmalloc fallback will catch fragmented memory case
and fail if theres no memory.

> +
> +				if (!tmp)
> +					kfree(buf);
> +				buf = tmp;
> +			}
> +			if (!buf) {
> +				buf = vmalloc(buf_len);
> +				if (!buf) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +			}
> +		}
> +
>  		read_extent_buffer(eb, buf, (unsigned long)(di + 1),
>  				name_len + data_len);
>  
> @@ -1071,7 +1094,10 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>  	}
>  
>  out:
> -	kfree(buf);
> +	if (is_vmalloc_addr(buf))
> +		vfree(buf);
> +	else
> +		kfree(buf);

There's even kvfree to do this.

>  	return ret;
>  }
