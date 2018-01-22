Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751896AbeAVJT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 04:19:59 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Sebastian Ochmann <ochmann@cs.uni-bonn.de>,
        linux-btrfs@vger.kernel.org
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
 <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7d06dca7-78f1-8df9-7b2d-d8eff7ffdca5@suse.com>
Date: Mon, 22 Jan 2018 11:19:56 +0200
MIME-Version: 1.0
In-Reply-To: <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.01.2018 02:39, Qu Wenruo wrote:
> 
> 
> On 2018年01月21日 23:27, Sebastian Ochmann wrote:
>> On 21.01.2018 11:04, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年01月20日 18:47, Sebastian Ochmann wrote:
>>>> Hello,
>>>>
>>>> I would like to describe a real-world use case where btrfs does not
>>>> perform well for me. I'm recording 60 fps, larger-than-1080p video using
>>>> OBS Studio [1] where it is important that the video stream is encoded
>>>> and written out to disk in real-time for a prolonged period of time (2-5
>>>> hours). The result is a H264 video encoded on the GPU with a data rate
>>>> ranging from approximately 10-50 MB/s.
>>>
>>>>
>>>> The hardware used is powerful enough to handle this task. When I use a
>>>> XFS volume for recording, no matter whether it's a SSD or HDD, the
>>>> recording is smooth and no frame drops are reported (OBS has a nice
>>>> Stats window where it shows the number of frames dropped due to encoding
>>>> lag which seemingly also includes writing the data out to disk).
>>>>
>>>> However, when using a btrfs volume I quickly observe severe, periodic
>>>> frame drops. It's not single frames but larger chunks of frames that a
>>>> dropped at a time. I tried mounting the volume with nobarrier but to no
>>>> avail.
>>>
>>> What's the drop internal? Something near 30s?
>>> If so, try mount option commit00 to see if it helps.
>>
>> Thank you for your reply. I observed the interval more closely and it
>> shows that the first, quite small drop occurs about 10 seconds after
>> starting the recording (some initial metadata being written?). After
>> that, the interval is indeed about 30 seconds with large drops each time.
> 
> This almost proves my assumption to transaction commitment performance.
> 
> But...
> 
>>
>> Thus I tried setting the commit option to different values. I confirmed
>> that the setting was activated by looking at the options "mount" shows
>> (see below). However, no matter whether I set the commit interval to
>> 300, 60 or 10 seconds, the results were always similar. About every 30
>> seconds the drive shows activity for a few seconds and the drop occurs
>> shortly thereafter.
> 
> Either such mount option has a bug, or some unrelated problem.

Looking at transaction_kthread the schedule there is done in
TASK+INTERRUPTIBLE so it's entirely possible that the kthread may be
woken up earlier. The code has been there since 2008. I'm going to run
some write-heavy tests to see how often the transaction kthread is woken
up before it's timeout has elapsed.

> 
> As you mentioned the output is about 10~50MiB/s, 30s means 300~1500MiBs.
> Maybe it's related to the dirty data amount?
> 
> Would you please verify if a lower or higher profile (resulting much
> larger or smaller data stream) would affect?
> 
> 
> Despite that, I'll dig to see if commit= option has any bug.
> 
> And you could also try the nospace_cache mount option provided by Chris
> Murphy, which may also help.
> 
> Thanks,
> Qu
> 
>> It almost seems like the commit setting doesn't have
>> any effect. By the way, the machine I'm currently testing on has 64 GB
>> of RAM so it should have plenty of room for caching.
>>
>>>>
>>>> Of course, the simple fix is to use a FS that works for me(TM). However
>>>> I thought since this is a common real-world use case I'd describe the
>>>> symptoms here in case anyone is interested in analyzing this behavior.
>>>> It's not immediately obvious that the FS makes such a difference. Also,
>>>> if anyone has an idea what I could try to mitigate this issue (mount or
>>>> mkfs options?) I can try that.
>>>
>>> Mkfs.options can help, but only marginally AFAIK.
>>>
>>> You could try mkfs with -n 4K (minimal supported nodesize), to reduce
>>> the tree lock critical region by a little, at the cost of more metadata
>>> fragmentation.
>>>
>>> And is there any special features enabled like quota?
>>> Or scheduled balance running at background?
>>> Which is known to dramatically impact performance of transaction
>>> commitment, so it's recommended to disable quota/scheduled balance first.
>>>
>>>
>>> Another recommendation is to use nodatacow mount option to reduce the
>>> CoW metadata overhead, but I doubt about the effectiveness.
>>
>> I tried the -n 4K and nodatacow options, but it doesn't seem to make a
>> big difference, if at all. No quota or auto-balance is active. It's
>> basically using Arch Linux default options.
>>
>> The output of "mount" after setting 10 seconds commit interval:
>>
>> /dev/sdc1 on /mnt/rec type btrfs
>> (rw,relatime,space_cache,commit,subvolid=5,subvol=/)
>>
>> Also tried noatime, but didn't make a difference either.
>>
>> Best regards
>> Sebastian
>>
>>> Thanks,
>>> Qu >>
>>>> I saw this behavior on two different machines with kernels 4.14.13 and
>>>> 4.14.5, both Arch Linux. btrfs-progs 4.14, OBS 20.1.3-241-gf5c3af1b
>>>> built from git.
>>>>
>>>> Best regards
>>>> Sebastian
>>>>
>>>> [1] https://github.com/jp9000/obs-studio
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
