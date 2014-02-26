Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaBZCh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 21:37:57 -0500
Message-ID: <530D5094.9020605@cn.fujitsu.com>
Date: Wed, 26 Feb 2014 10:25:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: use bitfield instead of integer for
 some variants in fs_info
References: <1393328937-26171-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1393328937-26171-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140225162816.GY16073@twin.jikos.cz>
In-Reply-To: <20140225162816.GY16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2014 12:28 AM, David Sterba wrote:
> On Tue, Feb 25, 2014 at 07:48:57PM +0800, Wang Shilong wrote:
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   ctree.h | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/ctree.h b/ctree.h
>> index 3cc3477..9b461af 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -984,9 +984,11 @@ struct btrfs_fs_info {
>>   	struct btrfs_fs_devices *fs_devices;
>>   	struct list_head space_info;
>>   	int system_allocs;
>> -	int readonly;
>> -	int on_restoring;
>> -	int is_chunk_recover;
>> +
>> +	unsigned int readonly:1;
>> +	unsigned int on_restoring:1;
>> +	unsigned int is_chunk_recover:1;
> Well, the integers are wasteful, but there's only one instance of
> fs_info per fsck run, so it saves like 8 bytes in total. I'm not sure
> this patch is needed.
Originally, i wrote this patch, it is because i was going to add a new flag.
However, that approach has been replaced by a better idea.

Anyway, this patch will be a good start, however, i don't insist on it.
We can also change it  when we have to add another flag later.

David, just do what you like here.

Thanks,
Wang
>

