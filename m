From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: read-only subvolumes?
Date: Thu, 24 Mar 2011 14:30:45 +0800
Message-ID: <4D8AE515.2060702@cn.fujitsu.com>
References: <4D89ADA7.2000803@gmail.com> <4D89BC88.5030406@cn.fujitsu.com> <4D89C649.7080803@gmail.com> <4D89C81D.6050800@gmail.com> <4D89CBF4.6040600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89CBF4.6040600@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> When I am creating subvolumes I get this strange behavior. If
>>>>> I create a subvolume with a name longer than 4 characters it
>>>>> is read-only, if the name is shorter than 5 characters the
>>>>> subvolume is writeable as expected. I think it is since I
>>>>> upgraded to kernel version 2.6.38 (I do not create
>>>>> subvolumes on a regular basis.). I will compile one of the
>>>>> latest 2.6.37 kernels to see whether there the problem
>>>>> exists, too. Another interesting point is that previously
>>>>> created subvolumes are not affected.
>>>>>
>>>>> Thanks, Andreas Philipp
>>>>>
>>>>> thor btrfs # btrfs subvolume create 123456789 Create
>>>>> subvolume './123456789' thor btrfs # touch 123456789/lsdkfj
>>>>> touch: cannot touch `123456789/lsdkfj': Read-only file
>>>>> system
>>
>>>> This is really odd, but I can't reproduce it.
>>
>>>> I created a btrfs filesystem on 2.6.37 kernel, and rebooted to
>>>> latest 2.6.38+, and tried the procedures as you did, but
>>>> nothing bad happend.
>>> While playing around I found the following three new points: -
>>> Now the length of the subvolume name does not matter. So even the
>>> ones with short names are read-only. - It also happens to a fresh
>>> newly created btrfs filesystem. - If I take a snapshot of an
>>> "old" (= writeable) subvolume this is writeable.
>>
>>> I will now reboot into 2.6.37.4, check there, and then report
>>> back.
>>
>> Well, this was fast. Everything works as expected on 2.6.37.4. See
>> the output of uname -a for the exact kernel version below. I will
>> now reboot into a differently configured kernel version 2.6.38 and
>> look whether the problem is gone there.
>>
>> Thanks, Andreas Philipp
>>
>> thor ~ # uname -a Linux thor 2.6.37.4 #2 SMP Wed Mar 23 10:25:54
>> CET 2011 x86_64 Intel(R) Core(TM)2 CPU 6600 @ 2.40GHz GenuineIntel
>> GNU/Linux
> 
> IMHO, this is related to how the debug options of the kernel are
> configured. Attached you find two config files, both for kernel
> version 2.6.38, with the one named 2.6.38-debug everything works and
> with the other one newly created subvolumes are read only.
> 

I'll see if I can reproduce the problem using your config. Thanks!
