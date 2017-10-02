Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:57390 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750806AbdJBVqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 17:46:37 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Mount error on 32 bits, ok on 64 bits
To: Jean-Denis Girard <jd.girard@sysnux.pf>, linux-btrfs@vger.kernel.org
References: <oqk7mb$gud$1@blaine.gmane.org> <oqklhq$mas$1@blaine.gmane.org>
 <oqpnff$ob1$1@blaine.gmane.org> <oqtuql$k3j$1@blaine.gmane.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <15e1f555-9557-0854-e910-300d882f321d@libero.it>
Date: Mon, 2 Oct 2017 23:46:34 +0200
MIME-Version: 1.0
In-Reply-To: <oqtuql$k3j$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2017 07:59 PM, Jean-Denis Girard wrote:
> Le 30/09/2017 à 17:29, Jean-Denis Girard a écrit :
>> Le 28/09/2017 à 19:26, Jean-Denis Girard a écrit :
>> The problem seems to come from commit c821e7f3 "pass bytes to
>> btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/): the
>> system is now running fine on 4.13.4 with only that patch reverted.
> 
> Same situation with 4.14-rc3: my system cannot mount root file-system.
> If I revert the patch, the system boots normally. This is 100%
> reproducible. How can I help resolve that issue?


Looking at the patch, it seems suspect this chunk:

@@ -2798,7 +2798,7 @@  static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, sector);
+	bio = btrfs_bio_alloc(bdev, sector << 9);
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;

Now sector, is defined as

	sector_t   [1]

which in turn it might be defined as 

	unsigned long   [2]

which on 32bit is 32 bit if CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large (2TB+) block devices and files)

The point is that 

	sector << 9 

may overflow if the disk is bigger than 4GB (and in your case it seems to be 8 GB).

If I am correct, could you please so kindly to 

- repllay the patch
- AND try to replace
	bio = btrfs_bio_alloc(bdev, sector << 9);
with
	bio = btrfs_bio_alloc(bdev, (u64)sector << 9);


[1] http://elixir.free-electrons.com/linux/latest/source/fs/btrfs/extent_io.c#L2762
[2] http://elixir.free-electrons.com/linux/latest/source/include/linux/types.h#L133
> 
> 
> Thanks,
> 
BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
