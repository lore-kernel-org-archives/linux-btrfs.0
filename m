Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44218 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaA0TGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 14:06:23 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/6] btrfs: search_ioctl rejects unused setted values
Date: Mon, 27 Jan 2014 20:06:20 +0100
Message-ID: <4207589.mCGRS1gQ4T@merkaba>
In-Reply-To: <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name> <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 27. Januar 2014, 14:28:28 schrieb Gerhard Heift:
> To prevent unexpectet values in the unused fields of the search key fail

unexpected

> early. Otherwise future extensions would break the behavior of the search
> if current implementations in userspace set them to values other than zero.
> 
> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index be4c780..919d928 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1947,6 +1947,9 @@ static noinline int search_ioctl(struct inode *inode,
>  	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
>  		return -EOVERFLOW;
> 
> +	if (sk->unused || sk->unused1 | sk->unused2 | sk->unused3 | sk->unused4)
> +		return -EINVAL;
> +
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
