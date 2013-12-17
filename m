Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45048 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3LQI3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 03:29:21 -0500
Message-ID: <52B00D4F.5080403@oracle.com>
Date: Tue, 17 Dec 2013 16:37:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs-progs: handle error in the btrfs_prepare_device
In-Reply-To: <52B004E1.706@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1387247616-1574-1-git-send-email-anand.jain@oracle.com>
 <1387247616-1574-3-git-send-email-anand.jain@oracle.com>
 <52B004E1.706@giantdisaster.de>




>> +	ret = btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
>> +				 &mixed, 0);
>>   	close(fddstdev);
>> +	if (ret)
>> +		goto leave_with_error;


>>   	fddstdev = -1;

  yeah moved this 3 lines up. thanks.

> You change the code to call close(fddstdev) twice.
>
> [...]
>> +zero_dev_error:
>> +	if (ret) {
>> +		ret < 0 ?
>> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %s\n",
>> +			file, strerror(-ret)) :
>> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %d\n",
>> +			file, ret);
>
> This is not funny.

  hmm. I am not sure what you mean ?

Thanks, Anand
