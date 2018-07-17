Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43580 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbeGQFV0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 01:21:26 -0400
Subject: Re: [PATCH v5 2/2] btrfs: get device pointer from
 btrfs_scan_one_device
To: "dsterba@suse.cz" <dsterba@suse.cz>
Cc: "Gu, Jinxiang" <gujx@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>
 <1531732277-23517-2-git-send-email-gujx@cn.fujitsu.com>
 <20180716123417.GF3126@twin.jikos.cz>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <61d50b9c-9230-c841-7d07-8b47799c34c8@oracle.com>
Date: Tue, 17 Jul 2018 12:54:00 +0800
MIME-Version: 1.0
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


::

>>> @@ -1561,12 +1564,15 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>>>   		goto error_fs_info;
>>>   	}
>>>
>>> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
>>> -	if (error) {
>>> +	device = btrfs_scan_one_device(device_name, mode, fs_type);
>>> +	if (IS_ERR(device)) {
>>> +		error = PTR_ERR(device);
>>>   		mutex_unlock(&uuid_mutex);
>>>   		goto error_fs_info;
>>>   	}
>>>
>>> +	fs_devices = device->fs_devices;
>>> +

  The version at misc-next is missing this assignment and it panics.

::

Thanks, Anand
