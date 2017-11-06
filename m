Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29394 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdKFCcm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 21:32:42 -0500
Subject: Re: [PATCH 06/11] btrfs: document device locking
From: Anand Jain <anand.jain@oracle.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
 <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
Message-ID: <22384755-34ff-d45e-8bd8-9d4914a8774a@oracle.com>
Date: Mon, 6 Nov 2017 10:32:48 +0800
MIME-Version: 1.0
In-Reply-To: <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/03/2017 07:13 PM, Anand Jain wrote:
> 
> 
> Thanks for writing this.
> 
>> + * - fs_devices::device_list_mutex (per-fs, with RCU)
>> + *
>> + *   protects updates to fs_devices::devices, ie. adding and deleting
>> + *
>> + *   simple list traversal with read-only actions can be done with RCU
>> + *   protection
>> + *
>> + *   may be used to exclude some operations from running concurrently 
>> without
>> + *   any modifications to the list (see write_all_supers)
> 
>> + * - volume_mutex
>> + *
>> + *   coarse lock owned by a mounted filesystem; used to exclude some 
>> operations
>> + *   that cannot run in parallel and affect the higher-level 
>> properties of the
>> + *   filesystem like: device add/deleting/resize/replace, or balance
> 
>> + * - chunk_mutex
>> + *
>> + *   protects chunks, adding or removing during allocation, trim or when
>> + *   a new device is added/removed
> 
> ::
> 
>> + * Lock nesting
>> + * ------------
>> + *
>> + * uuid_mutex
>> + *   volume_mutex

I think it should be nested like this, but as of now its not. Ref [1]
  [1]
  btrfs: move volume_mutex into the btrfs_rm_device()

Thanks, Anand

>> + *     device_list_mutex
>> + *       chunk_mutex
>> + *     balance_mutex
> 
> 
> If we have a list of operations that would consume these locks then we 
> can map it accordingly for better clarity.
> 
> To me it looks like we have too many locks.
>   - we don't have to differentiate the mounted and unmounted context
>     for device locks.
>   - Two lock would be sufficient, one for the device list
>     (add/rm,replace,..) and another for device property changes
>     (resize, trim,..).
> 
> Thanks, Anand
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
