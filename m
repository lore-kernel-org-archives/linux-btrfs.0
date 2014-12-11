Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13710 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932535AbaLKIo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:44:59 -0500
Message-ID: <54895988.3020504@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 16:44:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <mwilck@arcor.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 12/18] btrfs restore: check progress of file restoration
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de> <1418244708-7087-13-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-13-git-send-email-mwilck@arcor.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 12/18] btrfs restore: check progress of file restoration
From: <mwilck@arcor.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月11日 04:51
> From: Martin Wilck <mwilck@arcor.de>
>
> extents should be ordered by file offset. Expect no overlaps,
> and report holes.
>
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>   cmds-restore.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 004c82e..80081b8 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -739,6 +739,14 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
>   			ret = -1;
>   			goto set_size;
>   		}
> +		if (found_key.offset < next_pos) {
> +			fprintf(stderr, "extent overlap, %llu < %llu\n",
> +				found_key.offset, next_pos);
> +			ret = -1;
> +			goto set_size;
Would it be better to continue recovery?
Even overlap, later extents may still be OK. What about just skip to 
next extent?

Thanks,
Qu
> +		} else if (found_key.offset > next_pos)
> +			fprintf(stderr, "hole at %llu (%llu bytes)\n",
> +				next_pos, found_key.offset - next_pos);
>   
>   		bytes_written = 0ULL;
>   		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)

