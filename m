Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeEBCOu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 May 2018 22:14:50 -0400
Subject: Re: [PATCH] btrfs: rename btrfs_balance_control::flags to b_flags
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180430094913.26309-1-anand.jain@oracle.com>
 <20180430170824.GO21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a16aedb8-478e-ddf0-c392-16d4ed2e6da6@oracle.com>
Date: Wed, 2 May 2018 10:17:04 +0800
MIME-Version: 1.0
In-Reply-To: <20180430170824.GO21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/01/2018 01:08 AM, David Sterba wrote:
> On Mon, Apr 30, 2018 at 05:49:13PM +0800, Anand Jain wrote:
>> As flags is a generic name, its often difficult to search, rename
>> btrfs_balance_control::flags to btrfs_balance_control::b_flags.
> 
> I don't think this one is necessary as it's always tied to bctl.

  I notice that too, but its not guaranteed that we always name
  point as bctl. Anyway I am ok as it is.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
