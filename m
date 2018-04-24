Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbeDXF7E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 01:59:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ACC8CABEA
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 05:59:02 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: simplify counting number of eb pages
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524523681.git.dsterba@suse.com>
 <faf2e8e2cb4f87f4b418b177256d8950cd8deba1.1524523682.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <27114496-d14c-7210-a130-3acb39f21677@suse.com>
Date: Tue, 24 Apr 2018 08:59:00 +0300
MIME-Version: 1.0
In-Reply-To: <faf2e8e2cb4f87f4b418b177256d8950cd8deba1.1524523682.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.04.2018 02:03, David Sterba wrote:
> The eb length is nodesize, as initialized in __alloc_extent_buffer.
> Regardless of start, we should always get the same number of pages, so
> use that fact.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index a53009694b16..ee92c1289edd 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -454,8 +454,7 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
>  
>  static inline unsigned long num_extent_pages(u64 start, u64 len)
>  {
> -	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
> -		(start >> PAGE_SHIFT);
> +	return len >> PAGE_SHIFT;

Shouldn't this really be len + PAGE_SIZE -1 or in fact DIV_ROUND_DOWN
(len, PAGE_SIZE). Because with a nodesize of 4k (and basically less than
a page size) we can get into a situation where we do:

4096 >> 13 = 0

On powerpc for example we have:

arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              18
arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              16
arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              14
arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              12


>  }
>  
>  static inline void extent_buffer_get(struct extent_buffer *eb)
> 
