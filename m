Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbeDYJ1U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 05:27:20 -0400
Subject: Re: [PATCH] btrfs: kill btrfs_raid_type_names[]
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180425072608.25445-1-anand.jain@oracle.com>
 <f4af2694-aeb3-7262-e16f-fbc1fdcd4347@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8f1d97a6-2d0e-6369-5d9d-85cbe7357db1@oracle.com>
Date: Wed, 25 Apr 2018 17:29:27 +0800
MIME-Version: 1.0
In-Reply-To: <f4af2694-aeb3-7262-e16f-fbc1fdcd4347@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index ef220d541d4b..2acd32ce1573 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -342,6 +342,7 @@ struct btrfs_raid_attr {
>>   	int tolerated_failures; /* max tolerated fail devs */
>>   	int devs_increment;	/* ndevs has to be a multiple of this */
>>   	int ncopies;		/* how many copies to data has */
>> +	char *raid_name;	/* name of the raid */
> nit: const char * ?

Its declared as const when allocated.

  const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {

Thanks, Anand
