Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37184 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeIMQ7b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 12:59:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so5289189wrr.4
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 04:50:22 -0700 (PDT)
From: =?UTF-8?B?SsO8cmdlbiBIZXJybWFubg==?= <t-5@t-5.eu>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 13 Sep 2018 13:50:19 +0200
Message-ID: <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
In-Reply-To: <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
 <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu>
 <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was echoing "w" to /proc/sysrq_trigger every 0.5s which did work also 
after the hang because I started the loop before the hang. The dmesg output 
should show the hanging tasks from second 346 on or so. Still not useful?

Best regards,
Jürgen

Am 13. September 2018 13:04:39 schrieb Nikolay Borisov <nborisov@suse.com>:

> On 13.09.2018 13:56, Jürgen Herrmann wrote:
>> Both loops were started before the hang because after the hang I cannot
>> do that anymore. That's why there is progress in the logs at first. The
>> hang continues for at least 1.5 hours. No data is transferred anymore
>> during this time. I never waited longer than 1.5 hours.
>
> So these logs don't provide any useful information then. The other thing
> which I can advise is to setup kdump and when the kernel hangs cause a
> crashdump to be taken and try to upload it somewhere alongside your
> vmlinux file for further debugging.
>
>
>>
>> Best regards,
>> Jürgen
>>
>> Am 13. September 2018 12:50:59 schrieb Nikolay Borisov <nborisov@suse.com>:
>>
>>> On 13.09.2018 13:29, Jürgen Herrmann wrote:
>>>> Am 13.9.2018 10:40, schrieb Nikolay Borisov:
>>>>> On 13.09.2018 11:34, Jürgen Herrmann wrote:
>>>>>> Hello!
>>>>>>
>>>>>> I have a newly installed laptop running a freshly installed (abt. two
>>>>>> months ago) laptop running latest linux mint 19. Root filesystem is
>>>>>> on a
>>>>>> 1TB Samsung 860 M.2 SSD with btrfs on top of a LUKS encrypted 900G
>>>>>> partition. Timeshift-btrfs is enabled for root (@) and home (@home)
>>>>>> subvolumes. I want to transfer snapshots to a server with a separated
>>>>>> disk via "btrfs send" and ssh.
>>>>>>
>>>>>> Here's the list of snapshot directories, each containing tow snapshots
>>>>>> for root and home:
>>>>>>
>>>>>> drwxr-xr-x 1 root root 30 Sep 12 22:08 2018-08-16_20-00-01
>>>>>> drwxr-xr-x 1 root root 30 Aug 17 14:00 2018-08-17_14-00-02
>>>>>> drwxr-xr-x 1 root root 30 Aug 23 20:00 2018-08-23_20-00-01
>>>>>> drwxr-xr-x 1 root root 30 Aug 30 20:00 2018-08-30_20-00-01
>>>>>> drwxr-xr-x 1 root root 30 Sep  6 20:00 2018-09-06_20-00-01
>>>>>> drwxr-xr-x 1 root root 30 Sep  6 22:00 2018-09-06_22-00-01
>>>>>> drwxr-xr-x 1 root root 30 Sep  8 16:00 2018-09-08_16-00-01
>>>>>> drwxr-xr-x 1 root root 30 Sep 10 20:00 2018-09-10_20-00-02
>>>>>> drwxr-xr-x 1 root root 30 Sep 11 21:00 2018-09-11_21-00-02
>>>>>> drwxr-xr-x 1 root root 30 Sep 12 21:00 2018-09-12_21-00-01
>>>>>>
>>>>>> "btrfs send
>>>>>> /mnt/timeshift/backup/timeshift-btrfs/snapshots/2018-08-16_20-00-01/@
>>>>>>> /dev/null" results in the btrfs task taking 100% cpu time on one cpu
>>>>>> and then all IO is blocked -> only reboot can solve the hang.
>>>>>>
>>>>>> The crash does not happen immediately, as i was on the road using
>>>>>> cellular connection it seemed fine at first. That's how I found out
>>>>>> that
>>>>>> it transfers ~140MB of data before hanging. The snapshot is created on
>>>>>> the server and contains data (du shows abt 140MB).
>>>>>>
>>>>>> I am running vanilla kernel 4.18.6 (compiled by myself) and btrfs
>>>>>> progs
>>>>>> 4.17.1 compiled from source.
>>>>>>
>>>>>> Here's the btrfs filesystem info:
>>>>>> Label: none  uuid: a914c141-72bf-448b-847f-d64ee82d8b7b
>>>>>>         Total devices 1 FS bytes used 342.85GiB
>>>>>>         devid    1 size 875.44GiB used 357.05GiB path
>>>>>> /dev/mapper/sda3_crypt
>>>>>>
>>>>>> A scrub shows no errors:
>>>>>> scrub status for a914c141-72bf-448b-847f-d64ee82d8b7b
>>>>>>         scrub started at Thu Sep 13 10:20:18 2018 and finished after
>>>>>> 00:12:19
>>>>>>         total bytes scrubbed: 342.78GiB with 0 errors
>>>>>>
>>>>>> What can I do to help debugging this issue?
>>>>>
>>>>>
>>>>> You should provide output of echo w > /proc/sysrq-trigger. Also
>>>>> sample the stack of /proc/[pid of btrfs send]/stack to see if it is
>>>>> changing.
>>>>>
>>>>>
>>>>>>
>>>>>> Best regards,
>>>>>> Jürgen
>>>>
>>>> Hello!
>>>>
>>>> dmesg output can be found here:
>>>> https://pastebin.com/g86dPGSZ
>>>
>>> So from what I see current transaction commit is waiting for
>>> root->commit_root_sem and then other threads (in this case systemd) is
>>> waiting for transaction commit to finish.
>>>>
>>>> stacks can be found here:
>>>> https://pastebin.com/dCt1YgJp
>>>
>>> ANd your user process seems to be making some progress as evident from
>>> the fact that the call trace of the process is actually changing over
>>> the course of sampling. Is it possible that it just takes time to do the
>>> IO ?
>>>>
>>>> Best regards,
>>>> Jürgen
>>
>>
>> Mit AquaMail Android
>> https://www.mobisystems.com/aqua-mail
>>
>>
>>


Mit AquaMail Android
https://www.mobisystems.com/aqua-mail
