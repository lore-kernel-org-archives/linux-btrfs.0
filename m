Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48453 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759744AbaEMJPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 05:15:16 -0400
Message-ID: <5371E1E5.1030909@cn.fujitsu.com>
Date: Tue, 13 May 2014 17:12:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: bug adding device to seed device, btrfs fi show fails
References: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com> <53702B42.8040806@oracle.com>
In-Reply-To: <53702B42.8040806@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 05/12/2014 10:00 AM, Anand Jain wrote:
>
> This patch posted a long time back should fix it.
>   http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33276
I sent a patch to address another problem, plus your patch should can
fix the problem.

https://patchwork.kernel.org/patch/4163791/

Thanks,
Wang
>
> Could you test it ?
>
> Thanks, Anand
>
>
> On 05/11/2014 09:51 AM, Chris Murphy wrote:
>> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
>> btrfs-progs 3.14
>>
>> /dev/sdb2 = existing btrfs fs
>> /dev/sdc3 = unformatted partition
>>
>>
>> # btrfstune -S1 /dev/sdb2
>> # mount /dev/sdb2 /mnt
>> mount: /dev/sdb2 is write-protected, mounting read-only
>> # btrfs device add /dev/sdc3 /mnt
>> Performing full device TRIM (75.90GiB) ...
>> # btrfs fi show
>> Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
>>     Total devices 1 FS bytes used 7.55GiB
>>     devid    1 size 79.31GiB used 11.04GiB path /dev/sda3
>>
>> btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= 
>> fi_args->num_devices)' failed.
>>
>> Nothing listed in dmesg.--
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

