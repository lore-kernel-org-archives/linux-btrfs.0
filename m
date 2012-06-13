Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:56881 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2FMNtE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 09:49:04 -0400
Message-ID: <4FD89A53.1060704@giantdisaster.de>
Date: Wed, 13 Jun 2012 15:49:07 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use rcu to protect device->name V2
References: <1339530642-13862-1-git-send-email-josef@redhat.com> <20120612223526.GJ32402@twin.jikos.cz> <20120613131426.GA2186@localhost.localdomain>
In-Reply-To: <20120613131426.GA2186@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 13 Jun 2012 09:14:27 -0400, Josef Bacik wrote:
> On Wed, Jun 13, 2012 at 12:35:26AM +0200, David Sterba wrote:
>> On Tue, Jun 12, 2012 at 03:50:41PM -0400, Josef Bacik wrote:
>>> @@ -4694,8 +4716,11 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
>>>  		key.offset = device->devid;
>>>  		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
>>>  		if (ret) {
>>> -			printk(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
>>> -			       device->name, (unsigned long long)device->devid);
>>> +			printk_in_rcu(KERN_WARNING "btrfs: no dev_stats entry "
>>> +				      "found for device %s (devid %llu) (OK on"
>>> +				      " first mount after mkfs)\n",
>>
>> breaking printk strings hurts when grepping for a message
>>
>>> +				      rcu_str_deref(device->name),
>>> +				      (unsigned long long)device->devid);
>>>  			__btrfs_reset_dev_stats(device);
>>>  			device->dev_stats_valid = 1;
>>>  			btrfs_release_path(path);
>>> @@ -4747,8 +4772,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
>>>  	BUG_ON(!path);
>>>  	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
>>>  	if (ret < 0) {
>>> -		printk(KERN_WARNING "btrfs: error %d while searching for dev_stats item for device %s!\n",
>>> -		       ret, device->name);
>>> +		printk_in_rcu(KERN_WARNING "btrfs: error %d while searching "
>>> +			      "for dev_stats item for device %s!\n", ret,
>>
>> and here as well
>>
>>> +			      rcu_str_deref(device->name));
>>>  		goto out;
>>>  	}
>>>  
>>> @@ -4757,8 +4783,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
>>>  		/* need to delete old one and insert a new one */
>>>  		ret = btrfs_del_item(trans, dev_root, path);
>>>  		if (ret != 0) {
>>> -			printk(KERN_WARNING "btrfs: delete too small dev_stats item for device %s failed %d!\n",
>>> -			       device->name, ret);
>>> +			printk_in_rcu(KERN_WARNING "btrfs: delete too small "
>>> +				      "dev_stats item for device %s failed %d!\n",
>>
>> here
>>
>>> +				      rcu_str_deref(device->name), ret);
>>>  			goto out;
>>>  		}
>>>  		ret = 1;
>>> @@ -4770,8 +4797,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
>>>  		ret = btrfs_insert_empty_item(trans, dev_root, path,
>>>  					      &key, sizeof(*ptr));
>>>  		if (ret < 0) {
>>> -			printk(KERN_WARNING "btrfs: insert dev_stats item for device %s failed %d!\n",
>>> -			       device->name, ret);
>>> +			printk_in_rcu(KERN_WARNING "btrfs: insert dev_stats "
>>> +				      "item for device %s failed %d!\n",
>>
>> here
>>
>>> +				      rcu_str_deref(device->name), ret);
>>>  			goto out;
>>>  		}
>>>  	}
>>
>> mostly minor things, but please fix them.
>>
> 
> I'm breaking them for the 80 char limit, it happens for all long messages, we're
> all used to it.  I'll fix up the other things.  Thanks,
> 
> Josef

The last sentence of chapter 2 of Documentation/CodingStyle is quite
unambiguous. Here is the full quote of that chapter:

                Chapter 2: Breaking long lines and strings

Coding style is all about readability and maintainability using commonly
available tools.

The limit on the length of lines is 80 columns and this is a strongly
preferred limit.

Statements longer than 80 columns will be broken into sensible chunks,
unless
exceeding 80 columns significantly increases readability and does not hide
information. Descendants are always substantially shorter than the
parent and
are placed substantially to the right. The same applies to function headers
with a long argument list. However, never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.
