Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55518 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2KGHGv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 02:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <20121106225136.GU3102@twin.jikos.cz>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-6-git-send-email-zwu.kernel@gmail.com>
	<20121106225136.GU3102@twin.jikos.cz>
Date: Wed, 7 Nov 2012 15:06:49 +0800
Message-ID: <CAEH94LhWFxYuptv9GbnAt-PxJU6a_1A86wHopzT-7hsknE0p0w@mail.gmail.com>
Subject: Re: [RFC v4+ hot_track 05/19] vfs: add hooks to enable hot tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
        cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 7, 2012 at 6:51 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:47PM +0800, zwu.kernel@gmail.com wrote:
>> --- a/mm/readahead.c
>> +++ b/mm/readahead.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/syscalls.h>
>>  #include <linux/file.h>
>> +#include <linux/hot_tracking.h>
>>
>>  /*
>>   * Initialise a struct file's readahead state.  Assumes that the caller has
>> @@ -138,6 +139,11 @@ static int read_pages(struct address_space *mapping, struct file *filp,
>>  out:
>>       blk_finish_plug(&plug);
>>
>> +     /* Hot data tracking */
>> +     hot_update_freqs(mapping->host, (u64)(list_entry(pages->prev,\
>> +                             struct page, lru)->index) << PAGE_CACHE_SHIFT,
>> +                     (u64)nr_pages * PAGE_CACHE_SIZE, 0);
>
> There's a stale \ at the end of the line, and I find this formatting
> hard to read. Does the following look acceptable?
yes, great, thanks.
>
>         hot_update_freqs(mapping->host,
>                 (u64)(list_entry(pages->prev, struct page, lru)->index)
>                         << PAGE_CACHE_SHIFT,
>                 (u64)nr_pages * PAGE_CACHE_SIZE, 0);
>
>> +
>>       return ret;
>>  }
>>



-- 
Regards,

Zhi Yong Wu
