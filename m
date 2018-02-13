Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53838 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933286AbeBMDtE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 22:49:04 -0500
Subject: Re: [PATCH 1/1] btrfs: log, when replace, is canceled by the user
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <55cc08af-67f5-64c3-d5df-0b41d4c2cf57@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b28d1c6e-001c-58a9-4687-48103cbaaabc@oracle.com>
Date: Tue, 13 Feb 2018 11:50:30 +0800
MIME-Version: 1.0
In-Reply-To: <55cc08af-67f5-64c3-d5df-0b41d4c2cf57@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> +
>> +	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled",
>> +		   btrfs_dev_name(src_device), src_device->devid,
>> +		   rcu_str_deref(tgt_device->name));
> 
> The behavior is quite good.
> 
> Although I'm wondering why for @src_device we use btrfs_dev_name() but
> rcu_str_deref() for @tgt_device?

   Thanks for the comments.
   My bad. In fact, I must use btrfs_dev_name() for tgt_device since
   the tgt_device can be missing (-o degraded) when the user decides
   to cancel.

Thanks, Anand
