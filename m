Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45906 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdKCLNA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 07:13:00 -0400
Subject: Re: [PATCH 06/11] btrfs: document device locking
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
Date: Fri, 3 Nov 2017 19:13:01 +0800
MIME-Version: 1.0
In-Reply-To: <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for writing this.

> + * - fs_devices::device_list_mutex (per-fs, with RCU)
> + *
> + *   protects updates to fs_devices::devices, ie. adding and deleting
> + *
> + *   simple list traversal with read-only actions can be done with RCU
> + *   protection
> + *
> + *   may be used to exclude some operations from running concurrently without
> + *   any modifications to the list (see write_all_supers)

> + * - volume_mutex
> + *
> + *   coarse lock owned by a mounted filesystem; used to exclude some operations
> + *   that cannot run in parallel and affect the higher-level properties of the
> + *   filesystem like: device add/deleting/resize/replace, or balance

> + * - chunk_mutex
> + *
> + *   protects chunks, adding or removing during allocation, trim or when
> + *   a new device is added/removed

::

> + * Lock nesting
> + * ------------
> + *
> + * uuid_mutex
> + *   volume_mutex
> + *     device_list_mutex
> + *       chunk_mutex
> + *     balance_mutex


If we have a list of operations that would consume these locks then we 
can map it accordingly for better clarity.

To me it looks like we have too many locks.
  - we don't have to differentiate the mounted and unmounted context
    for device locks.
  - Two lock would be sufficient, one for the device list
    (add/rm,replace,..) and another for device property changes
    (resize, trim,..).

Thanks, Anand

