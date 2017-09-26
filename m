Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21068 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964889AbdIZIhu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:37:50 -0400
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
 <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
 <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
 <26696307-d343-e75a-5dd8-b401a8fe02d0@oracle.com>
 <03b419bf-95de-00cf-6e43-9c462c8f1872@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2a7e6110-3517-98ad-8f30-3ff9ec8a5817@oracle.com>
Date: Tue, 26 Sep 2017 16:45:06 +0800
MIME-Version: 1.0
In-Reply-To: <03b419bf-95de-00cf-6e43-9c462c8f1872@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> The
>>> sysfs rm stands though
>>
>>   This is a preparatory patch for 3/3, at BUG_ON it needs an exit
>> without  the btrfs_sysfs_add_device_link() part.
> 
> In this case I'd rather you have this change in 3/3, because on its own
> it doesn't really make sense and cannot easily be figured out if doing
> git blame.

  Fixed in v3. Thanks for suggesting.

-Anand

