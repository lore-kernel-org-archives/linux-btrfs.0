Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:43749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3BEC0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 21:26:31 -0500
In-Reply-To: <20130205012316.GB28437@shiny>
References: <20130202160212.GB4694@shiny> <51102B40.6000207@zytor.com> <20130205012316.GB28437@shiny>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: experimental raid5/6 code in git
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 04 Feb 2013 18:26:10 -0800
To: Chris Mason <chris.mason@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <441f44ee-a354-4c03-86f3-ce37141cdc1c@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also, a 2-member raid5 or 3-member raid6 are a raid1 and can be treated as such.

Chris Mason <chris.mason@fusionio.com> wrote:

>On Mon, Feb 04, 2013 at 02:42:24PM -0700, H. Peter Anvin wrote:
>> @@ -1389,6 +1392,14 @@ int btrfs_rm_device(struct btrfs_root *root,
>char
>> *device_path)
>>  	}
>>  	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
>> 
>> +	if ((all_avail & (BTRFS_BLOCK_GROUP_RAID5 |
>> +			  BTRFS_BLOCK_GROUP_RAID6) && num_devices <= 3)) {
>> +		printk(KERN_ERR "btrfs: unable to go below three devices "
>> +		       "on raid5 or raid6\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
>>  		printk(KERN_ERR "btrfs: unable to go below four devices "
>>  		       "on raid10\n");
>> @@ -1403,6 +1414,21 @@ int btrfs_rm_device(struct btrfs_root *root,
>char
>> *device_path)
>>  		goto out;
>>  	}
>> 
>> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
>> +	    root->fs_info->fs_devices->rw_devices <= 2) {
>> +		printk(KERN_ERR "btrfs: unable to go below two "
>> +		       "devices on raid5\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
>> +	    root->fs_info->fs_devices->rw_devices <= 3) {
>> +		printk(KERN_ERR "btrfs: unable to go below three "
>> +		       "devices on raid6\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>>  	if (strcmp(device_path, "missing") == 0) {
>>  		struct list_head *devices;
>>  		struct btrfs_device *tmp;
>> 
>> 
>> This seems inconsistent?
>
>Whoops, missed that one.  Thanks!
>
>-chris

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
