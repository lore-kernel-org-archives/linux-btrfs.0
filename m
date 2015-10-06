Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22307 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbJFJqL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 05:46:11 -0400
Message-ID: <5613981E.7090404@oracle.com>
Date: Tue, 06 Oct 2015 17:45:02 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: device delete to accept devid
In-Reply-To: <20150930151411.GI11442@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1443564222-1641-1-git-send-email-anand.jain@oracle.com>
 <20150930151411.GI11442@suse.cz>


Thanks for the review..

On 09/30/2015 11:14 PM, David Sterba wrote:
> On Wed, Sep 30, 2015 at 06:03:42AM +0800, Anand Jain wrote:
>> +struct btrfs_ioctl_vol_args_v3 {
>
> Can we use struct btrfs_ioctl_vol_args_v2 for that purpose? It contains
> the 'flags' so we can abuse the name field to store the device id and
> set the flags accordingly.
>
>> +	__s64 fd;
>> +	char name[BTRFS_PATH_NAME_MAX + 1];
>> +	__u64 devid;
>> +};
>> +
>>   #define BTRFS_DEVICE_PATH_NAME_MAX 1024
>>
>>   #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
>> @@ -683,6 +689,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>>                                     struct btrfs_ioctl_feature_flags[2])
>>   #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
>>                                     struct btrfs_ioctl_feature_flags[3])
>> +#define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
>> +				   struct btrfs_ioctl_vol_args_v3)
>
> And we can reuse the ioctl nmuber 11
>
> #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 11, \
> 				   struct btrfs_ioctl_vol_args_v2)
>
> The vol_v2 structure is extensible so we can add more functionality
> there and then I think it justifies the V2 interface bump.

    I have implemented it in V3 and sent out.

Thanks, Anand


