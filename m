Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33607 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbdLHMoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 07:44:09 -0500
Subject: Re: [Question] Two variants of SB reads can we move into bio read
 instead ?
To: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <d9c5e650-5aaa-96e7-f6ff-653794c89f87@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d1ba2223-bdb3-f0a1-8d40-23a232071cc8@suse.com>
Date: Fri, 8 Dec 2017 14:44:07 +0200
MIME-Version: 1.0
In-Reply-To: <d9c5e650-5aaa-96e7-f6ff-653794c89f87@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.12.2017 12:27, Anand Jain wrote:
> 
> David,
> 
>  There are two variants of SB read, one using the device cache [1]
>  and the other buffer head [2].
> 
>  [1] btrfs_read_disk_super()
>  [2] btrfs_read_dev_super()
> 
>  Patch, 6f60cbd3ae442cb35861bb522f388db123d42ec1
>   (btrfs: access superblock via pagecache in scan_one_device)
>  Embraced device caches to avoid blocksize set and thus avoid device
>  drop cache. But however its in the context of starting up with a new
>  mount and in practice, would it really matter if the device cache is
>  dropped in the context of mount, we any way drop it when the device
>  is successfully mounted though. I don't understand the actual problem
>  here.
> 
>  Further [2] is still using buffer head, which works very well for us
>  in this context, any idea if there is any suggestion to move it to
>  newer bio read instead ?

the bh interface eventually goes:

btrfs_read_dev_one_super
 __bread
  __bread_gfp
   __getblk_gfp
    __getblk_slow
     __find_get_block
      __find_get_block_slow
        find_get_page_flags

Which is again using the pagecache, albeit a bit more convoluted.


> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
