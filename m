From: "Liu Hui" <onlyflyer@gmail.com>
Subject: Re: [PATCH]Fix for map_private_extent_buffer to handle extent which is not page alignment
Date: Thu, 4 Dec 2008 22:28:48 +0800
Message-ID: <2c3b11250812040628n544b6df9j6e5df96cd9cbc53@mail.gmail.com>
References: <2c3b11250812040608r6eb4eb59xcdb6f53a72b5feb6@mail.gmail.com>
	 <2c3b11250812040621r326c5eebnd63dcd7910604619@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c3b11250812040621r326c5eebnd63dcd7910604619@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I don't know why GMAIL mix my ASCII figure, the figure for extent1 is
still not correct. Here is the newest one, hope GMAIL works.

    |-extent1-|
+-----++-----+
|page1||page2|
+-----++-----+

Thanks

2008/12/4 Liu Hui <onlyflyer@gmail.com>:
> There is a little problem with the first ASCII figure, here is the new one.
>   |-extent1-|
> +-----++-----+
> |page1||page2|
> +-----++-----+
>
> Thanks,
> Liu Hui
>
> 2008/12/4 Liu Hui <onlyflyer@gmail.com>:
>> Hi,
>> Now, BTRFS only supports page alignment extent. But in
>> map_private_extent(), there are already some codes to handle the
>> extent which is not page alignment. For example,
>> map_private_extent_buffer also wants to handle a extent which is 7K
>> length properly. The problem is the codes are not enough, e.g. in the
>> following figure, map_private_extent_buffer can handle extent1, but it
>> can't take the right behavior to handle extent2. This patch fixs it.
>>
>> PS:Please use the mono font to view the ASCII figures, thanks.
>>
>>   |-extent1-|
>> +-----++-----+
>> |page1||page2|
>> +-----++-----+
>>
>> |-extent2-|
>> +-----++-----+
>> |page1||page2|
>> +-----++-----+
>>
>> --
>> Thanks & Best Regards
>> Liu Hui
>> --
>>
>> diff --git a/extent_io.c b/extent_io.c
>> index c3dfe2a..cac47d1 100644
>> --- a/extent_io.c
>> +++ b/extent_io.c
>> @@ -3426,9 +3426,11 @@ int map_private_extent_buffer(struct
>> extent_buffer *eb, unsigned long start,
>>        char *kaddr;
>>        struct page *p;
>>        size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
>> +       size_t last_offset;
>>        unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
>>        unsigned long end_i = (start_offset + start + min_len - 1) >>
>>                PAGE_CACHE_SHIFT;
>> +       unsigned long last_i = (start_offset + eb->len - 1) >> PAGE_CACHE_SHIFT;
>>
>>        if (i != end_i)
>>                return -EINVAL;
>> @@ -3440,8 +3442,16 @@ int map_private_extent_buffer(struct
>> extent_buffer *eb, unsigned long start,
>>                offset = 0;
>>                *map_start = ((u64)i << PAGE_CACHE_SHIFT) - start_offset;
>>        }
>> +
>> +       if (i == last_i)
>> +               last_offset = ((u64)(i + 1) << PAGE_CACHE_SHIFT) - start_offset
>> +                             - eb->len;
>> +       else
>> +               last_offset = 0;
>> +
>>        if (start + min_len > eb->len) {
>> -printk("bad mapping eb start %Lu len %lu, wanted %lu %lu\n",
>> eb->start, eb->len, start, min_len);
>> +               printk("bad mapping eb start %Lu len %lu, wanted %lu %lu\n",
>> +                      eb->start, eb->len, start, min_len);
>>                WARN_ON(1);
>>        }
>>
>> @@ -3449,7 +3459,7 @@ printk("bad mapping eb start %Lu len %lu, wanted
>> %lu %lu\n", eb->start, eb->len,
>>        kaddr = kmap_atomic(p, km);
>>        *token = kaddr;
>>        *map = kaddr + offset;
>> -       *map_len = PAGE_CACHE_SIZE - offset;
>> +       *map_len = PAGE_CACHE_SIZE - offset - last_offset;
>>        return 0;
>>  }
>>  EXPORT_SYMBOL(map_private_extent_buffer);
>>
>
> --
> Thanks & Best Regards
> Liu Hui
> --
>



-- 
Thanks & Best Regards
Liu Hui
--
