Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46989 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933486AbcCKD2F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 22:28:05 -0500
Message-ID: <56E236B5.9000807@cn.fujitsu.com>
Date: Fri, 11 Mar 2016 11:08:37 +0800
From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: btrfs-debug-tree: show the compression method
 string
References: <1457599239-5512-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <20160310132303.GF18908@twin.jikos.cz>
In-Reply-To: <20160310132303.GF18908@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 03/10/2016 09:23 PM, David Sterba wrote:
> On Thu, Mar 10, 2016 at 04:40:39PM +0800, Xiaoguang Wang wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  print-tree.c | 22 ++++++++++++++++++----
>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 53a6813..5727cb9 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -286,6 +286,20 @@ static void print_uuids(struct extent_buffer *eb)
>>  	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
>>  }
>>  
>> +static char *compress_flags_to_str(u8 flag)
>> +{
>> +	switch (flag) {
>> +	case BTRFS_COMPRESS_NONE:
>> +		return "none";
>> +	case BTRFS_COMPRESS_ZLIB:
>> +		return "zlib";
>> +	case BTRFS_COMPRESS_LZO:
>> +		return "lzo";
>> +	default:
>> +		return "UNKNOWN";
> 
> would be good to print the actual value
OK, new version will be sent soon.

Regards,
Xiaoguang Wang

> 
> 
> 



