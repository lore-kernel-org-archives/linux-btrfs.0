Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbeEUGcx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 02:32:53 -0400
Subject: Re: [PATCH v2 2/3] btrfs: balance: add args info during start and
 resume
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-3-anand.jain@oracle.com>
 <20180517115944.GH6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f51e0e35-bb4e-9c91-d604-179665bbbe14@oracle.com>
Date: Mon, 21 May 2018 14:35:20 +0800
MIME-Version: 1.0
In-Reply-To: <20180517115944.GH6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/17/2018 07:59 PM, David Sterba wrote:
> On Wed, May 16, 2018 at 10:51:27AM +0800, Anand Jain wrote:
>> Balance args info is an important information to be reviewed for the
>> system audit. So this patch adds it to the kernel log.
>>
>> Example:
>>
>> -> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs
>>
>>   kernel: BTRFS info (device sdb): balance: start data profiles=raid1|single convert=raid5 metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
>>
>> -> btrfs bal start -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs
>>
>>   kernel: BTRFS info (device sdb): balance: start data profiles=raid5 convert=single metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> The log message can be useful, however please avoid using unchecked
> strcat and rewrite it without it if possible. You can find some
> inspiration how to join several strings in describe_relocation().

  Indeed describe_relocation() is nicer. I have updated it and made it
  a helper function in V3-set, so that balance can use it.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
