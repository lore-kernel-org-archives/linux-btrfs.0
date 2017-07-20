Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39525 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934402AbdGTKmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 06:42:33 -0400
Subject: Re: [PATCH 2/4] btrfs: separate defrag and property compression
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1500317040.git.dsterba@suse.com>
 <9dc75da8c4a2cfc0cddec3c9ccf95f5d28a89084.1500317040.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c5ce5317-a1d2-f4b3-1615-76812c8874f8@oracle.com>
Date: Thu, 20 Jul 2017 18:49:19 +0800
MIME-Version: 1.0
In-Reply-To: <9dc75da8c4a2cfc0cddec3c9ccf95f5d28a89084.1500317040.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/18/2017 02:46 AM, David Sterba wrote:
> Add new value for compression to distinguish between defrag and
> property. Previously, a single variable was used and this caused clashes
> when the per-file 'compression' was set and a defrag -c was called.

  How about..
    deprecate property compression
    introduce property compress (inline with -o compress) [1]
    introduce property compress-force (inline with -o compress-force) [2]

inode_need_compress will look something like this..
-----
static inline int inode_need_compress(struct inode *inode)
{
         struct btrfs_root *root = BTRFS_I(inode)->root;

         /* force compress */
         if (btrfs_test_opt(root->fs_info, FORCE_COMPRESS) ||
		            BTRFS_I(inode)->force_compress) [2]
                 return 1;

         /* bad compression ratios */
         if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
                 return 0;

         if (btrfs_test_opt(root->fs_info, COMPRESS) ||
             BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
             BTRFS_I(inode)->compress) [1]
                 return 1;

         return 0;
}
-----

  defrag -c will in turn set the compress property.

  introduce defrag --compress-force|-C to in turn set the compress-force
  property.

  Now user has a way to check the compression property using
    btrfs prop get ...

  And we have a consistent nomenclature ;-)

Thanks, Anand


> The property-compression is loaded when the file is open, defrag will
> overwrite the same variable and reset to 0 (ie. NONE) at when the file
> defragmentaion is finished. That's considered a usability bug.
> 
> Now we won't touch the property value, use the defrag-compression. The
> precedence of defrag is higher than for property (and whole-filesystem).

> @@ -511,7 +514,9 @@ static noinline void compress_file_range(struct inode *inode,
>   			goto cont;
>   		}
>   
> -		if (BTRFS_I(inode)->prop_compress)
> +		if (BTRFS_I(inode)->defrag_compress)
> +			compress_type = BTRFS_I(inode)->defrag_compress;
> +		else if (BTRFS_I(inode)->prop_compress)
>   			compress_type = BTRFS_I(inode)->prop_compress;



