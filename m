Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36008 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdJBXNH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 19:13:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dz9tQ-00011j-H0
        for linux-btrfs@vger.kernel.org; Tue, 03 Oct 2017 01:12:56 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Mount error on 32 bits, ok on 64 bits
Date: Mon, 2 Oct 2017 13:12:57 -1000
Message-ID: <c1a58e8c-0beb-eed0-b731-fc4535d55594@sysnux.pf>
References: <oqk7mb$gud$1@blaine.gmane.org> <oqklhq$mas$1@blaine.gmane.org>
 <oqpnff$ob1$1@blaine.gmane.org> <oqtuql$k3j$1@blaine.gmane.org>
 <15e1f555-9557-0854-e910-300d882f321d@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <15e1f555-9557-0854-e910-300d882f321d@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 02/10/2017 à 11:46, Goffredo Baroncelli a écrit :
> On 10/02/2017 07:59 PM, Jean-Denis Girard wrote:
>> Le 30/09/2017 à 17:29, Jean-Denis Girard a écrit :
>>> Le 28/09/2017 à 19:26, Jean-Denis Girard a écrit :
>>> The problem seems to come from commit c821e7f3 "pass bytes to
>>> btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/): the
>>> system is now running fine on 4.13.4 with only that patch reverted.
>>
>> Same situation with 4.14-rc3: my system cannot mount root file-system.
>> If I revert the patch, the system boots normally. This is 100%
>> reproducible. How can I help resolve that issue?
> 
> 
> Looking at the patch, it seems suspect this chunk:
> 
> @@ -2798,7 +2798,7 @@  static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
>  		}
>  	}
>  
> -	bio = btrfs_bio_alloc(bdev, sector);
> +	bio = btrfs_bio_alloc(bdev, sector << 9);
>  	bio_add_page(bio, page, page_size, offset);
>  	bio->bi_end_io = end_io_func;
>  	bio->bi_private = tree;
> 
> Now sector, is defined as
> 
> 	sector_t   [1]
> 
> which in turn it might be defined as 
> 
> 	unsigned long   [2]
> 
> which on 32bit is 32 bit if CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large (2TB+) block devices and files)
> 
> The point is that 
> 
> 	sector << 9 
> 
> may overflow if the disk is bigger than 4GB (and in your case it seems to be 8 GB).
> 
> If I am correct, could you please so kindly to 
> 
> - repllay the patch
> - AND try to replace
> 	bio = btrfs_bio_alloc(bdev, sector << 9);
> with
> 	bio = btrfs_bio_alloc(bdev, (u64)sector << 9);

Hi Goffredo,

Thanks for your reply, analysis and correction: it does work, tested on
4.13-rc3, my system boots fine.


Best regards,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

