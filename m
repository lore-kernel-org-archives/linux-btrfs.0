Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27563 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaHLH47 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:56:59 -0400
Message-ID: <53E9C8C2.5020409@oracle.com>
Date: Tue, 12 Aug 2014 15:56:50 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: update sprout seed pointer when seed fs is
 relinquished
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com> <1407750176-15853-4-git-send-email-anand.jain@oracle.com> <53E9C134.5020706@cn.fujitsu.com>
In-Reply-To: <53E9C134.5020706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2014 15:24, Miao Xie wrote:
> On Mon, 11 Aug 2014 17:42:56 +0800, Anand Jain wrote:
>> We are not updating sprout fs seed pointer when all seed device
>> is replaced. This patch will check if all seed device has been
>> replaced and then update the sprout pointer accordingly.
>>
>> Same reproducer as in the previous patch would apply here.
>> And notice that btrfs_close_device will check if seed fs is
>> present and spits out the error with out this patch.
>>
>> int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>> {
>> ::
>>                  seed_devices = fs_devices->seed;
>> ::
>>          while (seed_devices) {
>>                  fs_devices = seed_devices;
>>                  seed_devices = fs_devices->seed;
>>                  __btrfs_close_devices(fs_devices);
>>                  free_fs_devices(fs_devices);
>>          }
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index f098ae7..bfdc11f 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1992,6 +1992,25 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>>   			btrfs_scratch_superblock(srcdev);
>>   	}
>>
>> +	/* unless fs_devices is seed fs, num_devices shouldn't go
>> +	 * zero
>> +	 */
>
> According to coding style, the preferred style for multi-line comments is(except files in net
> subsystem):
>
> /*
>   * <comment>
>   */
>
>> +	BUG_ON(!fs_devices->num_devices && !fs_devices->seeding);
>
> Use ASSERT?
>
>> +	/* if this is no devs we rather delete the fs_devices */
>> +	if (!fs_devices->num_devices) {
>> +		struct btrfs_fs_devices *tmp_fs_devices;
>> +
>> +		tmp_fs_devices = fs_info->fs_devices;
>> +		while (tmp_fs_devices) {
>> +			if (tmp_fs_devices->seed == fs_devices) {
>> +				tmp_fs_devices->seed = fs_devices->seed;
>> +				break;
>> +			}
>> +			tmp_fs_devices = tmp_fs_devices->seed;
>> +		}
>> +		fs_devices->seed = NULL;
>
> Why not free fs_devices like btrfs_rm_device?

  Thanks for the review. ! Yes memory leak is another bug
  I have the patch for it will send it soon. the bug trying
  to address here is fs_devices stale seed pointer.

Anand

> The other is OK.
>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>
>> +	}
>>   	call_rcu(&srcdev->rcu, free_device);
>>   }
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
