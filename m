Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6450 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbaF2Qvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 12:51:51 -0400
Message-ID: <53B04420.5040807@fb.com>
Date: Sun, 29 Jun 2014 12:51:44 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5] Btrfs: make fsync work after cloning into a file
References: <1402027551-9737-1-git-send-email-fdmanana@gmail.com> <1402282085-32217-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402282085-32217-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/08/2014 10:48 PM, Filipe David Borba Manana wrote:
> When cloning into a file, we were correctly replacing the extent
> items in the target range and removing the extent maps. However
> we weren't replacing the extent maps with new ones that point to
> the new extents - as a consequence, an incremental fsync (when the
> inode doesn't have the full sync flag) was a NOOP, since it relies
> on the existence of extent maps in the modified list of the inode's
> extent map tree, which was empty. Therefore add new extent maps to
> reflect the target clone range.
> 
> A test case for xfstests follows.

[ ... ]

> @@ -3406,6 +3471,10 @@ process_slot:
>  		}
>  		ret = clone_finish_inode_update(trans, inode, destoff + len,
>  						destoff, olen);
> +		if (ret)
> +			goto out;
> +		clone_update_extent_map(inode, trans, path, NULL, last_dest_end,
> +					destoff + len - last_dest_end);
>  	}
>  
>  out:
> 

path has already been released by this point, I'm getting use-fater-free
crashes during xfstests.

-chris
