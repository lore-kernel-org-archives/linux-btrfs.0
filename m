Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaA0R2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 12:28:36 -0500
Date: Mon, 27 Jan 2014 18:28:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/6] btrfs: search_ioctl rejects unused setted
 values
Message-ID: <20140127172835.GB6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 02:28:28PM +0100, Gerhard Heift wrote:
> To prevent unexpectet values in the unused fields of the search key fail early.
> Otherwise future extensions would break the behavior of the search if current
> implementations in userspace set them to values other than zero.
> 
> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1947,6 +1947,9 @@ static noinline int search_ioctl(struct inode *inode,
>  	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
>  		return -EOVERFLOW;
>  
> +	if (sk->unused || sk->unused1 | sk->unused2 | sk->unused3 | sk->unused4)
> +		return -EINVAL;

The pattern that's been used for forward/backward compatibility is to
zero the unused or reserved fields on the userspace side and ignore them
completely in kernel.

If any future version of the ioctl uses the now unused fields, it also
has to increase the version.

> +
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
