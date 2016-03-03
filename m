Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21754 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbcCCBQv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 20:16:51 -0500
Subject: Re: duplicate automounts with btrfs RAID1
To: Pavol Cupka <pavol.cupka@gmail.com>
References: <1456950881.15729.2.camel@gmail.com>
 <CAH4oapdmQQVwpPD0JNufak7A-=Y=RBNugsM_0Bz=edUG2KRFAw@mail.gmail.com>
 <CABmfUYCQVaCHPBzQ4_SUrD=36-7iMarrHpAUd_DGjJxx2zfYbQ@mail.gmail.com>
 <CAH4oapcoR2E+9GyiLBD+ykXC7WX58tjWSQUJEP+6k8wzbwRVxg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D7907E.9040502@oracle.com>
Date: Thu, 3 Mar 2016 09:16:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAH4oapcoR2E+9GyiLBD+ykXC7WX58tjWSQUJEP+6k8wzbwRVxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



First,
If /dev/sdc1 is getting disappeared and reappearing you may have this
problem, securing the connection for /dev/sdc1 will help.

But, Should automount be more intelligent to identify FSID thats
already mounted ? In btrfs RAIDs, Both /dev/sdc1 /dev/sdd1 contains
same FSID. With btrfs its not guaranteed that there is one unique FSID
per device.
So automount should, depend on the FSID to check if its already mounted
I am not sure if its doing it, but apparently it does not appears to
be doing it.

Further, I think there is small little bug in the btrfs that, when
one of the device disappears the /proc/self/mounts should should
probably show surviving device. To implement this we need device
state being managed dynamically. Which my hot-spare and auto-replace
patch introduced.

Thanks, Anand

On 03/03/2016 06:01 AM, Pavol Cupka wrote:
> and disk/ata/usb resets?
>
> On Wed, Mar 2, 2016 at 10:56 PM, Leigh Orf <leigh.orf@gmail.com> wrote:
>> On Wed, Mar 2, 2016 at 3:34 PM, Pavol Cupka <pavol.cupka@gmail.com> wrote:
>>> is anything in dmesg that would point to diskscontrollers being reset?
>>>
>>> or something like that?
>>>
>>> pavol
>>
>> Pavol,
>>
>> Hmm, yes, there are some weird things going on. I am attaching what I
>> see as the relevant bits from /var/log/messages (command: egrep
>> '(sd[cd]|mount)' /var/log/messages)
>>
>> Note, /dev/sdc is disk 1 and /dev/sdd is disk 2 (the two btrfs RAID1 members).
>>
>> Leigh
>>
>>>
>>> On Wed, Mar 2, 2016 at 9:34 PM, Leigh Orf <leigh.orf@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> Not entirely sure this is a btrfs issue, but here is my problem. I've
>>>> had this issue with recent Fedora and CentOS distros.
>>>>
>>>> I created a btrfs RAID 1 pair with two identical USB external drives,
>>>> following the instructions found online:
>>>>
>>>> mkfs.btrfs -m raid1 -d raid1 /dev/sdc1 /dev/sdd1
>>>>
>>>> Then I mount it as /ext1:
>>>>
>>>> % df |grep sdc
>>>> /dev/sdc1      9767539112 1280   9765383552   1% /ext1
>>>>
>>>> The problem? Over time, /dev/sdc1 keeps getting mounted under a
>>>> different mount point, these accrue a couple per day:
>>>>
>>>> % mount|grep sdc
>>>> /dev/sdc1 on /ext1 type btrfs (rw,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd1 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd11 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd12 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd13 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd14 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd15 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd16 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd17 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd18 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd19 type
>>>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>>>
>>>> It's as if the OS keeps "discovering a new disk" and mounting it
>>>> under /run/media (where things like external drives, thumb drives etc.
>>>> automount).
>>>>
>>>> Here is info about my setup (up to date CentOS 7.2):
>>>>
>>>> % cat /etc/system-release
>>>> CentOS Linux release 7.2.1511 (Core)
>>>> % uname -a
>>>> Linux xxx.xxx.xxx.edu 3.10.0-123.20.1.el7.x86_64 #1 SMP Thu Jan 29
>>>> 18:05:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>>> % btrfs --version
>>>> btrfs-progs v3.19.1
>>>> % btrfs fi show
>>>> Label: none  uuid: d9706351-609b-4c6e-9f37-7058bb038fd1
>>>>          Total devices 2 FS bytes used 640.00KiB
>>>>          devid    1 size 4.55TiB used 2.03GiB path /dev/sdc1
>>>>          devid    2 size 4.55TiB used 2.01GiB path /dev/sdd1
>>>>
>>>> btrfs-progs v3.19.1
>>>> % btrfs fi df /ext1
>>>> Data, RAID1: total=1.00GiB, used=512.00KiB
>>>> Data, single: total=8.00MiB, used=0.00B
>>>> System, RAID1: total=8.00MiB, used=16.00KiB
>>>> System, single: total=4.00MiB, used=0.00B
>>>> Metadata, RAID1: total=1.00GiB, used=112.00KiB
>>>> Metadata, single: total=8.00MiB, used=0.00B
>>>>
>>>> Periodically I manually unmount these duplicates, but they come back.
>>>> I'd like a solution that doesn't involve disabling automount all
>>>> together.
>>>>
>>>> Thanks for any pointers, and apologies if this issue is unrelated to the
>>>> btrfs project.
>>>>
>>>> Leigh
>>>>
>>>> --
>>>> Leigh Orf
>>>> Associate Scientist
>>>> Cooperative Institute for Meteorological Satellite Studies
>>>> University of Wisconsin - Madison
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
