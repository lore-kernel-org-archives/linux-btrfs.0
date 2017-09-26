Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30566 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964802AbdIZHxb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:53:31 -0400
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
From: Anand Jain <anand.jain@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
 <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
 <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
 <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
Message-ID: <1e6f6d99-8b51-5dfe-0d5b-89a160529077@oracle.com>
Date: Tue, 26 Sep 2017 16:00:18 +0800
MIME-Version: 1.0
In-Reply-To: <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/26/2017 03:57 PM, Anand Jain wrote:
> 
>> The
>> sysfs rm stands though
> 
>   This is a preparatory patch for 3/3, at BUG_ON it needs an exit 
> without  the btrfs_sysfs_add_device_link() part.

typo
s/btrfs_sysfs_add_device_link/btrfs_sysfs_rm_device_link/


> -Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
