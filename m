Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbaDBRDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 13:03:22 -0400
Date: Wed, 2 Apr 2014 19:03:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        zab@redhat.com
Subject: Re: [PATCH] Btrfs: avoid warning bomb of
 btrfs_delayed_inode_reserve_metadata
Message-ID: <20140402170321.GJ29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396431670-9353-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396431670-9353-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 05:41:10PM +0800, Liu Bo wrote:
> When we nearly run out of global_block_rsv's reserved space, this WARNING will
> be hit for thousands of times, which is not good because the kernel log has
> nothing else.
> 
>  		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
> -		if (!WARN_ON(ret))
> +		if (!WARN_ON_ONCE(ret))
>  			goto out;

The warning has been mistakenly added in

fae7f21cece9a4c181
"btrfs: Use WARN_ON()'s return value in place of WARN_ON(1)"

@@ -649,14 +649,13 @@ static int btrfs_delayed_inode_reserve_metadata(
                        goto out;

                ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-               if (!ret)
+               if (!WARN_ON(ret))
                        goto out;

		[previous WARN_ON removed a few lines below]
---

WARN_ON will trigger because it sees 'ret' though in the previous code
did not reach the WARN_ON below. The correct pattern is

-	if (condition)
+	if (WARN_ON(condition))

I haven't spotted any other bugs from the same class in the patch. I'll
send a fix and cc stable.
