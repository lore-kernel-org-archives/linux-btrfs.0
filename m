Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:40011 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144Ab3DTAqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 20:46:05 -0400
Received: by mail-da0-f51.google.com with SMTP id g27so10053dan.10
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 17:46:04 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] btrfs: make static code static & remove dead code
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <51719932.6010406@redhat.com>
Date: Sat, 20 Apr 2013 08:45:58 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <sensille@gmx.net>
Message-Id: <E10A9F29-D33F-4BFE-AA00-62C8CAA5C10B@gmail.com>
References: <51719932.6010406@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Eric,
> Big patch, but all it does is add statics to functions which
> are in fact static, then remove the associated dead-code fallout.
> 
> removed functions:
> 
> btrfs_iref_to_path()
> __btrfs_lookup_delayed_deletion_item()
> __btrfs_search_delayed_insertion_item()
> __btrfs_search_delayed_deletion_item()
> find_eb_for_page()
> btrfs_find_block_group()
> range_straddles_pages()
> extent_range_uptodate()
> btrfs_file_extent_length()
> btrfs_reada_detach()
> btrfs_scrub_cancel_devid()
> btrfs_start_transaction_lflush()
> 
> btrfs_print_tree() is left because it is used for debugging.
> ulist.c functions are left because that one is odd; they're exported?

ulist_fin() and ulist_init() are only used static in fact, i don't think they they should be
exported as symbol.

So you can just  remove exporting and make them static.

Thanks,
Wang
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> [snip]
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

