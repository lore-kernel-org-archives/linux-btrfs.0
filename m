From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Having parent transid verify failed
Date: Fri, 06 May 2011 08:58:49 +0300
Message-ID: <4DC38E19.7020701@gmail.com>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think> <4DC28DC4.7050308@gmail.com> <1304605365-sup-4172@think> <4DC2B3D2.6080307@gmail.com> <1304607926-sup-3304@think> <4DC3084A.7030100@gmail.com> <1304627478-sup-2626@think> <4DC310C0.5080808@gmail.com> <1304639262-sup-37@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304639262-sup-37@think>
List-ID: <linux-btrfs.vger.kernel.org>



On 6/5/2011 2:50 =CF=80=CE=BC, Chris Mason wrote:
> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 17:04:00=
 -0400:
>> On 5/5/2011 11:32 =CE=BC=CE=BC, Chris Mason wrote:
>>> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 16:27:=
54 -0400:
>>>> I think i made some progress. When i tried to remove the directory=
 that
>>>> i suspect contains the problematic file, i got this on the console
>>>>
>>>> rm -rf serverloft/
>>>
>>> Ok, our one bad block is in the extent allocation tree.  This is go=
ing
>>> to be the very hardest thing to fix.
>>>
>>> Until I finish off the code to rebuild parts of the extent allocati=
on
>>> tree, I think your best bet is to copy the files off.
>>>
>>> The big question is, what happened to make this error?  Can you des=
cribe
>>> your setup in more detail?
>>
>> I created this btrfs filesystem on an arch linux system (amd64, quad
>> core) with kernel 2.3.38.1. it is on top of a md raid 5.
>>
>> [root@linuxserver ~]# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sde1[3] sdc1[1] sda1[0] sdf1[4]
>>         5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [4/4] [UUUU]
>>
>> the raid was grown from 3 devices to 4, and then btrfs was grown to =
max
>> size. mount options were clear_cache,compress-force.
>>
>> I was investigating a performance issue that i had, because over the
>> network i could only write to the filesystem at about 32mb/sec.
>>
>> when writing btrfs-delalloc- cpu usage was at 100%.
>>
>> While investigating i disabled compression, enabled space_cache and
>> tried zlib compression, and various combinations, while copying larg=
e
>> files back and forth using samba.
>>
>> BTW I tried to change some mount options using mount -o remount but
>> although the new options were printed on dmesg i think that they wer=
e
>> not enabled.
>>
>> I got the first error when i was copying some files and at the same =
time
>> created a directory over samba. After a while i upgraded to 2.6.38.5=
 but
>> nothing seems to have changed.
>>
>> I really dont think there is a hardware error here, but to be safe I=
 am
>> now running a check on the raid
>
> This error basically means we didn't write the block.  It could be
> because the write went to the wrong spot, or the hardware stack messe=
d
> it up, or because of a btrfs bug.  But, 2.6.38 is relatively recent. =
 It
> doesn't look like memory corruption because the transids are fairly
> close.
>
> When you grew the raid device, did you grow a partition as well?  We'=
ve
> had trouble in the past with block dev flushing code kicking in as
> devices are resized.

no, I did not grow any partitions, I just added one disk to the Raid 5=20
md0 device, and then grew the btrfs filesystem to max size(no partition=
s=20
on md0).

I can remember that as a test (to see if shrink works) i shrank the fs=20
by 1 gb and then grew it again to max size.

>
> Samba isn't doing anything exotic, and 2.6.38 has my recent fixes for
> rare metadata corruption bugs in btrfs.
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
