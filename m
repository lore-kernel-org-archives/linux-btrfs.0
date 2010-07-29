From: Justin Ossevoort <justin@internetionals.nl>
Subject: Re: Intermittent no space errors
Date: Thu, 29 Jul 2010 10:10:43 +0200
Message-ID: <4C513783.2060308@internetionals.nl>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com>	<AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com> <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Pherhaps it would be a good idea to add a tracepoint before each return
ENOSPC? It shouldn't matter too much since a reasonable assumption would
be that filesystems aren't running out of space most of the time. And
you can use 'perf' for more insight in these cases without recompiling
the kernel.

Regards,

    justin....

On 27/07/10 22:30, Dave Cundiff wrote:
> Hello,
>
> I installed the git repo kernel and added some debug to the ENOSPC
> returns. Unfortunately its still failing. If it helps any its bombing
> out in btrfs_check_data_free_space() in extent-tree.c. Returning on
> the ENOSPC at line 2959.
>
> Unfortunately that is the extent of my ability to debug a filesystem. :P
>
> Thanks,
>
> On Tue, Jul 27, 2010 at 9:19 AM, Yan, Zheng <yanzheng@21cn.com> wrote:
>   
>> On Tue, Jul 27, 2010 at 5:09 AM, Dave Cundiff <syshackmin@gmail.com> wrote:
>>     
>>> Hello,
>>>
>>> On 2.6.35-rc5 I'm seeing some weird behavior under heavy IO loads. I
>>> have a backup process that fires up several rsync processes. These
>>> mirror several dozen servers to individual sub-volumes. Everyday I
>>> snapshot each sub-volume and rsync over it.
>>>
>>> The problem I'm seeing is my rsync processes are failing randomly with
>>> "No space left on device". This is a 6 Terabyte volume with plenty of
>>> free space.
>>>
>>> Mount options:
>>> /dev/sdb on /backups type btrfs (rw,max_inline=0,compress)
>>>
>>> [root@rsync1 ~]# btrfs filesystem df /backups/
>>> Data: total=1.88TB, used=1.88TB
>>> Metadata: total=43.38GB, used=32.06GB
>>> System: total=12.00MB, used=260.00KB
>>>
>>> [root@rsync1 ~]# df /dev/sdb
>>> Filesystem           1K-blocks      Used Available Use% Mounted on
>>> /dev/sdb             5781249024 2087273084 3693975940  37% /backups
>>>
>>> They don't all fail at once. Normally I have 4-5 running at a time and
>>> 1 or 2 will drop out with a no space error. The rest continue on. I've
>>> noticed it will generally occur on ones that are in the middle of
>>> transferring a very large file. If I lighten the load to one rsync at
>>> a time it appears to happen less frequently.
>>>
>>> Any known issues I should be aware of?
>>>
>>>       
>> Thank you for reporting this. I will dig in.
>>
>> Yan, Zheng
>>
>>     
>
>
>   

