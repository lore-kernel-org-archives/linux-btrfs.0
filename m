Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31680 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbaE1B1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 21:27:43 -0400
Message-ID: <53853A9F.1020104@cn.fujitsu.com>
Date: Wed, 28 May 2014 09:23:43 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: clear compress-force when remounting with compress
 option
References: <1400816212-2501-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140527162249.GM5346@twin.jikos.cz>
In-Reply-To: <20140527162249.GM5346@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 05/28/2014 12:22 AM, David Sterba wrote:
> On Fri, May 23, 2014 at 11:36:52AM +0800, Wang Shilong wrote:
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -513,6 +513,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>   					btrfs_info(root->fs_info,
>>   						   "btrfs: use %s compression",
>>   						   compress_type);
>> +				/*
>> +				 * If we remount from compress-force=xxx to
>> +				 * compress=xxx, we need clear FORCE_COMPRESS
>> +				 * flag, otherwise, there is no way for users
>> +				 * to disable forcible compression separately.
>> +				 */
>> +				btrfs_clear_and_info(root, FORCE_COMPRESS,
>> +						     "compress is not forced anymore");
> This adds another message and does not make sense if it's not during
> remount.
The message is output in the following cases:

case1:
    # mount -o compress-force=lzo /dev/sdb /mnt
    # mount -o remount,compress=lzo  /dev/sdb /mnt

case2:
    # mount -o compress-force=lzo /dev/sdb /mnt
    # mount -o remount,compress-force=no /dev/sdb /mnt

Message won't be printed except remounting, any other case
that i was missing?

> The message "btrfs: use %s compression" could be printed
> unconditionally, we want to see that the compression is requested via
> mount option.
>
> Otherwise, the variable 'compress' does nothing useful and can be
> removed as well.
See many other mount options, if we change it, it will call
btrfs_clear_and_info(....)...

I don't have any taste that whether we need add or remove
this message, if you dosen't like this,  i could remove it.

Thanks,
Wang
>>   			}
>>   			break;
>>   		case Opt_ssd:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

