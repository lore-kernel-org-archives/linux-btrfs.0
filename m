Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41232 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdG2UUk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 16:20:40 -0400
Subject: Re: [PATCH] btrfs-progs: eliminate bogus IOC_DEV_INFO call
To: Henk Slager <eye1tm@gmail.com>
References: <20170727192446.27158-1-hans.van.kranenburg@mendix.com>
 <CAPmG0jbrCvVFjiDtZizSR9awLEFPHgQRkwcqX06Rdu6pJsFMDg@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <597CEE16.5090505@mendix.com>
Date: Sat, 29 Jul 2017 22:20:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbrCvVFjiDtZizSR9awLEFPHgQRkwcqX06Rdu6pJsFMDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/07/2017 11:49, Henk Slager wrote:
> On Thu, Jul 27, 2017 at 9:24 PM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> Device ID numbers always start at 1, not at 0. The first IOC_DEV_INFO
>> call does not make sense, since it will always return ENODEV.
>
> When there is a btrfs-replace ongoing, there is a Device ID 0

Aha... thanks for teaching me something new today. :) Actually, I 
remember having seen it a time earlier yes.

So, this one goes to /dev/null!

Hans

>
>> ioctl(3, BTRFS_IOC_DEV_INFO, {devid=0}) = -1 ENODEV (No such device)
>>
>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>> ---
>>   cmds-fi-usage.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
>> index 101a0c4..52c4c62 100644
>> --- a/cmds-fi-usage.c
>> +++ b/cmds-fi-usage.c
>> @@ -535,7 +535,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
>>                  return 1;
>>          }
>>
>> -       for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
>> +       for (i = 1, ndevs = 0 ; i <= fi_args.max_id ; i++) {
>>                  if (ndevs >= fi_args.num_devices) {
>>                          error("unexpected number of devices: %d >= %llu", ndevs,
>>                                  (unsigned long long)fi_args.num_devices);
>> --
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

