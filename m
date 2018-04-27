Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754672AbeD0BMa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 21:12:30 -0400
Subject: Re: [PATCH 0/3] enhance btrfs_raid_array[]
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180425110144.12871-1-anand.jain@oracle.com>
 <20180426130129.GR21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <bc394a77-a6f0-5b0f-fd37-4e46b3264b1b@oracle.com>
Date: Fri, 27 Apr 2018 09:14:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180426130129.GR21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/26/2018 09:01 PM, David Sterba wrote:
> On Wed, Apr 25, 2018 at 07:01:41PM +0800, Anand Jain wrote:
>> Cleanup patches as in the individual change log.
>>
>> These patches were sent independently as they aren't related as such,
>> but as I am updating the 1/3 the 2/3 would endup with conflict. So
>> here I am putting all of them together with the conflict fixed at
>> my end. And as such there is no change in 2/3 and 3/3 from its v1.
>>
>> Anand Jain (3):
>>    btrfs: kill btrfs_raid_type_names[]
>>    btrfs: kill btrfs_raid_group[]
>>    btrfs: kill btrfs_raid_mindev_error[]
> 
> Added to misc-next, thanks.

> I've reordered the mindev_error before the
> raid_name for better struct packing.

  Right. Thanks.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
