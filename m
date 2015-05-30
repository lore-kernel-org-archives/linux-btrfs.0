Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbbE3Pet (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 May 2015 11:34:49 -0400
Message-ID: <5569D890.5060001@oracle.com>
Date: Sat, 30 May 2015 23:34:40 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.1 24/27] Btrfs: free the stale device
References: <1426845702-6298-25-git-send-email-anand.jain@oracle.com> <1432308828-31185-1-git-send-email-Anand.Jain@oracle.com> <20150527113437.GQ23255@twin.jikos.cz>
In-Reply-To: <20150527113437.GQ23255@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David, Thanks for comments, more below..

On 05/27/2015 07:34 PM, David Sterba wrote:
> On Fri, May 22, 2015 at 11:33:48PM +0800, Anand Jain wrote:
>> +void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>> +{
>> +	int del = 0;
>> +	struct btrfs_fs_devices *fs_devs;
>> +	struct btrfs_device *dev;
>> +
>> +	if (!rcu_str_deref(cur_dev->name))
>> +		return;
>
> This looks like rcu-unprotected access, though there's an outer mutext
> held in device_list_add that calls btrfs_free_stale_device. I'm not sure
> that the device name should be used to do any sorts of checks at all.

  you are right.  I got this corrected in v5.2 just sent out.


>> +	list_for_each_entry(fs_devs, &fs_uuids, list) {
>> +		if (fs_devs->opened)
>> +			continue;
>> +		if (fs_devs->seeding)
>> +			continue;
>> +		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
>> +			if (dev == cur_dev)
>> +				continue;
>> +
>> +			/*
>> +			 * Todo: This won't be enough. What if same device
>> +			 * comes back with new uuid and with its mapper path?
>> +			 * But for now, this does helps as mostly an admin will
>> +			 * use either mapper or non mapper path throughout.
>> +			 */
>> +			if (!rcu_str_deref(dev->name))
>> +				continue;
>> +			if (!strcmp(rcu_str_deref(dev->name),
>> +						rcu_str_deref(cur_dev->name))) {
>> +				del = 1;
>> +				break;
>> +			}
>> +		}
>> +		if (del) {
>> +			/* delete the stale */
>> +			if (fs_devs->num_devices == 1) {
>> +				btrfs_sysfs_remove_fsid(fs_devs);
>> +				list_del(&fs_devs->list);
>> +				free_fs_devices(fs_devs);
>> +			} else {
>> +				fs_devs->num_devices--;
>> +				list_del(&dev->dev_list);
>> +				rcu_string_free(dev->name);
>> +				kfree(dev);
>
> Devices are normally freed by the rcu through free_device, this looks
> suspicious to mix both approaches.

  yes its bit of mixed up, also in other parts as well, for eg:
  free_fs_devices(). Here I am following free_fs_devices,
  since free_stale will check on the devices that are unmounted.

>> +			}
>> +			break;
>> +		}
>> +	}
>> +	return;
>
> Unnecessary return

right.

>> +}
>> +
>>   /*
>>    * Add new device to list of registered devices
>>    *
>> @@ -560,6 +609,8 @@ static noinline int device_list_add(const char *path,
>>   	if (!fs_devices->opened)
>>   		device->generation = found_transid;
>>
>> +	btrfs_free_stale_device(device);
>
> It might be safe to do that in the end, but it should be explained
> somewhere.

Added, Thanks, Anand

>> +
>>   	*fs_devices_ret = fs_devices;
>>
>>   	return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
