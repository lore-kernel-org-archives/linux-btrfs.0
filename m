Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbcLLOML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 09:12:11 -0500
Date: Mon, 12 Dec 2016 15:12:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: consolidate auto defrag kick off policies
Message-ID: <20161212141204.GR12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161206044309.3450-1-anand.jain@oracle.com>
 <20161206044309.3450-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161206044309.3450-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2016 at 12:43:09PM +0800, Anand Jain wrote:
> As of now writes smaller than 64k for non compressed extents and 16k
> for compressed extents inside eof are considered as candidate
> for auto defrag, put them together at a place.

Missing sign-off.

> ---
>  fs/btrfs/inode.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 79f073e94f2d..b157575166c6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -388,6 +388,22 @@ static inline int inode_need_compress(struct inode *inode)
>  	return 0;
>  }
>  
> +static inline void inode_should_defrag(struct inode *inode,
> +		u64 start, u64 end, u64 num_bytes, int comp_type)
> +{
> +	u64 small_write = SZ_64K;
> +	if (comp_type)
> +		small_write = SZ_16K;

I think the small_write value should be passed directly, not the
compression type.

> +
> +	if (!num_bytes)
> +		num_bytes = end - start + 1;

And the callers should pass the range length. Calculating inside the
function makes it less clear. One of the callers passes an blocksize
aligned value and the other doest not, so both know what's the right
value.

Otherwise the cleanup is good. I'll merge the other two patches, please
update and resend this one. Thanks.
