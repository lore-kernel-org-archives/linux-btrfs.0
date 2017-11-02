Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47877 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750786AbdKBFZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 01:25:47 -0400
Subject: Re: [PATCH 0/5] btrfs-progs: resolve property and enhance defragment
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
 <ea3e10a2-fdbe-db5f-378b-3767ba85bd5f@cn.fujitsu.com>
 <6F415D55-08C6-4517-9DF9-457B3679E7C4@gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <815506d3-54b3-72f3-caa5-bd271cba803e@cn.fujitsu.com>
Date: Thu, 2 Nov 2017 13:29:13 +0800
MIME-Version: 1.0
In-Reply-To: <6F415D55-08C6-4517-9DF9-457B3679E7C4@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/02/2017 12:13 PM, Wang Shilong wrote:
> 
> 在 2017年11月2日，上午11:44，Su Yue <suy.fnst@cn.fujitsu.com> 写道：
> 
> Sorry, the patchset does not work as expected.
> Please ignore it.
> 
> On 11/02/2017 11:23 AM, Su Yue wrote:
>> The patchset adds an option '--compress-force' to work with
>> 'btrfs fi defrag -c'. Then no-compression files will be set with
>> compression property specified by '-c' (zlib default).
>> patch[1-4] divide property handler to setter, getter, and printer.
>> Then patch[5] could enhance defragment easier.
>> Su Yue (5):
>>    btrfs-progs: property: divide prop_handler_t into
>>      setter,getter,printer
>>    btrfs-progs: property: set/get/print ro property
>>    btrfs-progs: property: set/get/print label property
>>    btrfs-progs: property: set/get/print compression property
>>    btrfs-progs: fi defrag: extend -c to drop nocompress flag on files
>>   cmds-filesystem.c |  94 +++++++++++++++++++++++--
>>   cmds-property.c   |   7 +-
>>   props.c           | 207 +++++++++++++++++++++++++++++++++++++++++++++---------
>>   props.h           |  19 +++--
>>   4 files changed, 283 insertions(+), 44 deletions(-)
> 
> FYI, i think it better to add some tests to btrfs-progs if new interface
> or function like this is added.
> 
Thank you. I will add  a test in next version.

Thanks,
Su
> Thanks,
> Shilong
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


