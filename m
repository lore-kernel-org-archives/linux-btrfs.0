Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53131 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2IYAYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 20:24:46 -0400
Message-ID: <5060F9C6.1070100@gmail.com>
Date: Tue, 25 Sep 2012 08:24:38 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, jbacik@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Btrfs: check range early in map_private_extent_buffer
References: <505FE3AF.2090302@gmail.com> <20120924161742.GL14582@twin.jikos.cz>
In-Reply-To: <20120924161742.GL14582@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年09月25日 00:17, David Sterba wrote:
> On Mon, Sep 24, 2012 at 12:38:07PM +0800, Wang Sheng-Hui wrote:
>> Check range early to avoid further check/compute in case
>> of range error.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/btrfs/extent_io.c |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 4c87847..9250cf5 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4643,6 +4643,14 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>>  	unsigned long end_i = (start_offset + start + min_len - 1) >>
>>  		PAGE_CACHE_SHIFT;
>>  
>> +	if (start + min_len > eb->len) {
>> +		printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
>> +		       "wanted %lu %lu\n", (unsigned long long)eb->start,
>> +		       eb->len, start, min_len);
>> +		WARN_ON(1);
>> +		return -EINVAL;
>> +	}
>> +
>>  	if (i != end_i)
>>  		return -EINVAL;
> 
> 4665         unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
> 4666         unsigned long end_i = (start_offset + start + min_len - 1) >>
> 4667                 PAGE_CACHE_SHIFT;
> 
> so the check above effectively verifies that
> 
>   min_len - 1 < PAGE_CACHE_SIZE
> AND
>   is within the same page
> 
> The other check
> 
> 	if (start + min_len > eb->len) {
> 
> looks if the requested data do not lie out of the bounds of the extent
> buffer, where min_len is filled with sizeof(something).
> 
> So, both the checks look for corrupted metadata, I don't see the need to
> swap them.

Reread the code and it really does the check.
Got it. Thanks for your explanation.

> 
> david

