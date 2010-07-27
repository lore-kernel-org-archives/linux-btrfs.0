From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Intermittent no space errors
Date: Tue, 27 Jul 2010 16:30:03 -0400
Message-ID: <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com>
	<AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I installed the git repo kernel and added some debug to the ENOSPC
returns. Unfortunately its still failing. If it helps any its bombing
out in btrfs_check_data_free_space() in extent-tree.c. Returning on
the ENOSPC at line 2959.

Unfortunately that is the extent of my ability to debug a filesystem. :=
P

Thanks,

On Tue, Jul 27, 2010 at 9:19 AM, Yan, Zheng <yanzheng@21cn.com> wrote:
> On Tue, Jul 27, 2010 at 5:09 AM, Dave Cundiff <syshackmin@gmail.com> =
wrote:
>> Hello,
>>
>> On 2.6.35-rc5 I'm seeing some weird behavior under heavy IO loads. I
>> have a backup process that fires up several rsync processes. These
>> mirror several dozen servers to individual sub-volumes. Everyday I
>> snapshot each sub-volume and rsync over it.
>>
>> The problem I'm seeing is my rsync processes are failing randomly wi=
th
>> "No space left on device". This is a 6 Terabyte volume with plenty o=
f
>> free space.
>>
>> Mount options:
>> /dev/sdb on /backups type btrfs (rw,max_inline=3D0,compress)
>>
>> [root@rsync1 ~]# btrfs filesystem df /backups/
>> Data: total=3D1.88TB, used=3D1.88TB
>> Metadata: total=3D43.38GB, used=3D32.06GB
>> System: total=3D12.00MB, used=3D260.00KB
>>
>> [root@rsync1 ~]# df /dev/sdb
>> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available U=
se% Mounted on
>> /dev/sdb =A0 =A0 =A0 =A0 =A0 =A0 5781249024 2087273084 3693975940 =A0=
37% /backups
>>
>> They don't all fail at once. Normally I have 4-5 running at a time a=
nd
>> 1 or 2 will drop out with a no space error. The rest continue on. I'=
ve
>> noticed it will generally occur on ones that are in the middle of
>> transferring a very large file. If I lighten the load to one rsync a=
t
>> a time it appears to happen less frequently.
>>
>> Any known issues I should be aware of?
>>
>
> Thank you for reporting this. I will dig in.
>
> Yan, Zheng
>



--=20
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
