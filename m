Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935155AbeF2PMe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 11:12:34 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA953B001
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 15:12:32 +0000 (UTC)
Subject: Re: [PATCH 05/14] btrfs: pass only eb to num_extent_pages
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1530262400.git.dsterba@suse.com>
 <6dcc9a3bbb003dff2feff4328d27e5bf88b21e9d.1530262400.git.dsterba@suse.com>
 <52aa9c57-4e7c-1421-2c13-e1d114eeb112@suse.com>
 <20180629142947.GU2287@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <81cd16b8-caf6-938f-3fa5-90ca8b147363@suse.com>
Date: Fri, 29 Jun 2018 18:12:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180629142947.GU2287@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.06.2018 17:29, David Sterba wrote:
> On Fri, Jun 29, 2018 at 12:08:10PM +0300, Nikolay Borisov wrote:
>>>  	for (i = 0; i < num_pages; i++)
>>>  		copy_page(page_address(dst->pages[i]),
>>>  				page_address(src->pages[i]));
>>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>>> index 0bfd4aeb822d..d8382a4a7f46 100644
>>> --- a/fs/btrfs/extent_io.h
>>> +++ b/fs/btrfs/extent_io.h
>>> @@ -440,10 +440,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>>>  			     int mirror_num);
>>>  void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
>>>  
>>> -static inline unsigned long num_extent_pages(u64 start, u64 len)
>>> +static inline unsigned long num_extent_pages(const struct extent_buffer *eb)
>>>  {
>>> -	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
>>> -		(start >> PAGE_SHIFT);
>>> +	return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
>>> +		(eb->start >> PAGE_SHIFT);
>>
>> This is a good opportunity to eliminate the open-coded round_up:
>>
>> round_up(eb->start + eb->len, PAGE_SIZE)
> 
> Ok, I'll add this patch:
> 
> @@ -442,8 +442,8 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
>  
>  static inline int num_extent_pages(const struct extent_buffer *eb)
>  {
> -       return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
> -               (eb->start >> PAGE_SHIFT);
> +       return (round_up(eb->start + eb->len, PAGE_SIZE) >> PAGE_SHIFT) -
> +              (eb->start >> PAGE_SHIFT);
>  }

LGTM
>  
>  static inline void extent_buffer_get(struct extent_buffer *eb)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
