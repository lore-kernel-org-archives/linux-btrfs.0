Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751604AbdFLKgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 06:36:22 -0400
Subject: Re: [PATCH v2] btrfs: add compression trace points
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1497256346-666-1-git-send-email-anand.jain@oracle.com>
 <7d5a4c34-b5a5-3725-d8eb-758a6605e3c9@suse.com>
 <79e71651-3b37-40d8-c28c-4446fe7fc5f8@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9250c0bc-07e9-19e6-f927-107cbd22250a@suse.com>
Date: Mon, 12 Jun 2017 13:36:19 +0300
MIME-Version: 1.0
In-Reply-To: <79e71651-3b37-40d8-c28c-4446fe7fc5f8@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.06.2017 12:44, Anand Jain wrote:
> 
> Thanks for the review.
> 
>> I haven't read previous submissions and any discussions that might have
>> occurred there but why not just stick to
>> btrfs_data_compression/btrfs_data_compressor. I know there is certain
>> semantic overload since we call it a compressor yet it also does
>> decompression but let's focus on making the code/intention clear for the
>> code reader and not bogging down too much on actual word semantics. To
>> me "compressor" is a synonym to something which compresses AND
>> decompresses. It's very well possible that this is just me in which case
>> my argument is flawed and you can ignore it :)
> 
>  The same tracer will also trace encryption at some point in future.

Right, in that case why don't you introduce the concept of
stages/pipeline. We can have a compression stage with either
compress/decompress ops. We can have an encryption stage with
encrypt/decrypt? How does that abstraction sound?


> 
>>> +#define show_transformer_type(type)            \
>>
>> Why not show_compression_type ?
> 
>  as above.
> 
>>> +    TP_printk_btrfs("%s %s ino=%lu type=%s len_before=%lu
>>> len_after=%lu "
>>> +        "start=%lu ret=%d",
>>> +        __entry->uncompress ? "untransform":"transform",
>>
>> decompress/compress. Transform/untransform are as cryptic as they can
>> be. It's a lot easier to put those terms in context when reading the
>> len_before/len_after values.
> 
>> Otherwise one might ask themselves "What
>> kind of transformation are we talking about?"
>>
>> Even if you don't do a v3 you can add:
> 
>  ha. Thanks.
> 
> current trace an example:
>  untransform bio ino=258 type=lzo len_before=4096 len_after=16384
> start=393216 ret=0

Now that I"m seeing this, why not prepent something in front of bio/page
.e.g granularity/unit:

unit=bio
granularity=page

I'm more inclined towards the latter.

> 
> before after size may be same in encryption, so we need extra specifier
> about the operation.
> 
> How about: (for example)
>  de-lzo bio ino=258 len_before=4096 len_after=16384 start=393216 ret=0
>  lzo ino=258 ..

de-lzo still seems a bit botched. what about

stage: compress op=lzo-decompress/zlib-compress granularity=bio/page
stage: encryption op=XTS-decrypt/encrypt ... ?


> 
> Thanks, Anand
> 
> 
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
