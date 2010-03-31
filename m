From: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: Re: [PATCH 09/18] btrfs: Fix return value of read_extent_buffer_pages()
 when lock page failed
Date: Wed, 31 Mar 2010 12:04:00 +0800
Message-ID: <4BB2C9B0.2020107@cn.fujitsu.com>
References: <4BAB5817.8020803@cn.fujitsu.com> <20100331000947.GS13190@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100331000947.GS13190@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Mar 25, 2010 at 08:33:27PM +0800, Miao Xie wrote:
>> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>>
>> read_extent_buffer_pages() should return error value instead of 0 when
>> lock page failed, we fix this problem.
> 
> [ Thanks for all of these patches! ]
> 
> This isn't strictly an IO error, the caller has said they are not
> willing to wait, so we don't wait.  That's different from finding a page
> where the IO had failed.
> 
> In general we ignore the errors until the caller is willing to wait for
> the result.
> 
> -chris

Hello, chris

Thanks for your response.
I'll drop this patch.

Thanks
Zhaolei

>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent_io.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index bdfbfa6..3194c79 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3419,8 +3419,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>>  	for (i = start_i; i < num_pages; i++) {
>>  		page = extent_buffer_page(eb, i);
>>  		if (!wait) {
>> -			if (!trylock_page(page))
>> +			if (!trylock_page(page)) {
>> +				ret = -EIO;
>>  				goto unlock_exit;
>> +			}
>>  		} else {
>>  			lock_page(page);
>>  		}
>> -- 
>> 1.6.5.2
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


