Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:33483 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbeEQIER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 04:04:17 -0400
Subject: Re: [PATCH 2/4] btrfs: lzo: Add comment about the how btrfs records
 its lzo compressed data
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
References: <20180517062753.25973-1-wqu@suse.com>
 <20180517062753.25973-3-wqu@suse.com>
 <a8146d5e-0558-e9f0-bf98-c51c9736691a@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3fb51446-e04e-91a1-7699-243759edfd58@gmx.com>
Date: Thu, 17 May 2018 16:04:02 +0800
MIME-Version: 1.0
In-Reply-To: <a8146d5e-0558-e9f0-bf98-c51c9736691a@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月17日 15:48, Nikolay Borisov wrote:
> 
> 
> On 17.05.2018 09:27, Qu Wenruo wrote:
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Overall it looks good and useful just a couple of nits below.
>> ---
>>  fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index 0667ea07f766..3d2ae4c08876 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -17,6 +17,29 @@
>>  
>>  #define LZO_LEN	4
>>  
>> +/*
>> + * Btrfs LZO compression format
>> + *
>> + * Regular LZO compressed data extent is consist of:
> nit: s/is consist/consists
>> + * 1.  Header
>> + *     Fixed size. LZO_LEN (4) bytes long, LE16.
>> + *     Records the total size (*includes* the header) of real compressed data.
>> + *
>> + * 2.  Segment(s)
>> + *     Variable size. Includes one segment header, and then data payload.
>> + *     One btrfs compressed data can have one or more segments.
> 
> So "one btrfs compressed data" should really mean "one btrfs compressed
> extent" I guess?

Oh, yes, one btrfs compressed extent.

Thanks,
Qu

> 
>> + *
>> + * 2.1 Segment header
>> + *     Fixed size. LZO_LEN (4) bytes long, LE16.
>> + *     Records the total size of the segment (*excludes* the header).
>> + *
>> + * 2.2 Data Payload
>> + *     Variable size. Size up limit should be lzo1x_worst_compress(PAGE_SIZE).
>> + *
>> + * While for inlined LZO compressed data extent, it doesn't have Header, just
>> + * one Segment.
> 
> 
> 
>> + */
>> +
>>  struct workspace {
>>  	void *mem;
>>  	void *buf;	/* where decompressed data goes */
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
