Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25404 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750820AbcKCAYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 20:24:55 -0400
Subject: Re: [PATCH v3 1/4] btrfs-progs: utils: Introduce function to escape
 characters
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
 <20161101100851.GV12522@suse.cz>
 <1382110a-9c56-e9e2-be33-77dbfffce4b6@cn.fujitsu.com>
 <20161102105550.GB12522@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2dbb27d3-f3ad-09c1-3515-ea516881d9fc@cn.fujitsu.com>
Date: Thu, 3 Nov 2016 08:24:50 +0800
MIME-Version: 1.0
In-Reply-To: <20161102105550.GB12522@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/02/2016 06:55 PM, David Sterba wrote:
> On Wed, Nov 02, 2016 at 09:19:10AM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/01/2016 06:08 PM, David Sterba wrote:
>>> On Tue, Nov 01, 2016 at 04:01:43PM +0800, Qu Wenruo wrote:
>>>> Introduce new function, escape_string_inplace(), to escape specified
>>>> characters in place.
>>>
>>> Sorry, the pointer to seq_path was misleading. The actual escape
>>> function is mangle_path and it copies one string to another. As we just
>>> print the path, we can simply switch and call putchar.
>>>
>>
>> Putchar() method is indeed much easier to implement.
>>
>> But it makes us hard to do further formatting, like aligning the path to
>> given width. (At least we are still using 32 chars alignment for path)
>>
>> So I still prefer the current full function string escaping and still
>> use %-32s for formatting.
>>
>>
>> And the idea of implementing escape_string_inplace() as a pure string
>> manipulation function can make it more agile for later use.
>> For example, we can reuse it for print-tree.
>
> Reusing is fine, but I really don't like that the function modifies the
> argument. What if the function is called twice on the same string? Also,
> in the print-tree, this would mean the extent buffer would be modified,
> potentially overwriting other items.
>
>
Then just encapsulate the in-place version into memory allocation version.

In-place version can be encapsulated very easily, while it's not 
possible vice verse.

So there will be two functions, escape_string_inplace() and 
escape_string() for caller to choose.

Would this be OK?

Thanks,
Qu


