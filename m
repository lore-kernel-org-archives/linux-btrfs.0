Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42655 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaC23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 22:28:29 -0400
Message-ID: <5452F3C3.3020906@oracle.com>
Date: Fri, 31 Oct 2014 10:28:19 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com> <20141030143310.GA21354@twin.jikos.cz>
In-Reply-To: <20141030143310.GA21354@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30/10/2014 22:33, David Sterba wrote:
> On Wed, Oct 15, 2014 at 08:51:09AM +0800, Anand Jain wrote:
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -30,6 +30,7 @@
>>   #include "print-tree.h"
>>   #include "volumes.h"
>>   #include "math.h"
>> +#include "utils.h"
>>
>>   struct stripe {
>>   	struct btrfs_device *dev;
>> @@ -1533,6 +1534,30 @@ btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
>>   	return NULL;
>>   }
>>
>> +/*
>> + * Register all devices in the fs_uuid list created in the user
>> + * space. Ensure btrfs_scan_lblkid() is called before this func.
>> + */
>> +int btrfs_register_all_devices(void)
>
> I think this belongs to utils.c, btrfs_register_one_device is also there
> and it is an API funcion for the commands. You can use
> btrfs_scanned_uuids() to get to the fs_uuids variable that's locally
> defined in volumes.c .

wonderful comment. Thanks. V4 is sent out.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
