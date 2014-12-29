Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:52124 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbaL2A1s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 19:27:48 -0500
Message-ID: <54A09FFD.4030107@pobox.com>
Date: Sun, 28 Dec 2014 16:27:41 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <11274819.qjhECasOKp@merkaba> <54A01939.3010204@pobox.com> <2330517.PVzv17pTee@merkaba>
In-Reply-To: <2330517.PVzv17pTee@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2014 07:42 AM, Martin Steigerwald wrote:
> Am Sonntag, 28. Dezember 2014, 06:52:41 schrieb Robert White:
>> On 12/28/2014 04:07 AM, Martin Steigerwald wrote:
>>> Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
>>>> Now:
>>>>
>>>> The complaining party has verified the minimum, repeatable case of
>>>> simple file allocation on a very fragmented system and the responding
>>>> party and several others have understood and supported the bug.
>>>
>>> I didn´t yet provide such a test case.
>>
>> My bad.
>>
>>>
>>> At the moment I can only reproduce this kworker thread using a CPU for
>>> minutes case with my /home filesystem.
>>>
>>> A mininmal test case for me would be to be able to reproduce it with a
>>> fresh BTRFS filesystem. But yet with my testcase with the fresh BTRFS I
>>> get 4800 instead of 270 IOPS.
>>>
>>
>> A version of the test case to demonstrate absolutely system-clogging
>> loads is pretty easy to construct.
>>
>> Make a raid1 filesystem.
>> Balance it once to make sure the seed filesystem is fully integrated.
>>
>> Create a bunch of small files that are at least 4K in size, but are
>> randomly sized. Fill the entire filesystem with them.
>>
>> BASH Script:
>> typeset -i counter=0
>> while
>>    dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + $RANDOM))
>> count=1 2>/dev/null
>> do
>> echo $counter >/dev/null #basically a noop
>> done
>>
>> The while will exit when the dd encounters a full filesystem.
>>
>> Then delete ~10% of the files with
>> rm *0
>>
>> Run the while loop again, then delete a different 10% with "rm *1".
>>
>> Then again with rm *2, etc...
>>
>> Do this a few times and with each iteration the CPU usage gets worse and
>> worse. You'll easily get system-wide stalls on all IO tasks lasting ten
>> or more seconds.
>
> Thanks Robert. Thats wonderful.
>
> I wondered about such a test case already and thought about reproducing
> it just with fallocate calls instead to reduce the amount of actual
> writes done. I.e. just do some silly fallocate, truncating, write just
> some parts with dd seek and remove things again kind of workload.
>
> Feel free to add your testcase to the bug report:
>
> [Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401
>
> Cause anything that helps a BTRFS developer to reproduce will make it easier
> to find and fix the root cause of it.
>
> I think I will try with this little critter:
>
> merkaba:/mnt/btrfsraid1> cat freespracefragment.sh
> #!/bin/bash
>
> TESTDIR="./test"
> mkdir -p "$TESTDIR"
>
> typeset -i counter=0
> while true; do
>          fallocate -l $((4096 + $RANDOM)) "$TESTDIR/$((++counter))"
>          echo $counter >/dev/null #basically a noop
> done

If you don't do the remove/delete passes you won't get as much 
fragmentation...

I also noticed that fallocate would not actually create the files in my 
toolset, so I had to touch them first. So the theoretical script became

e.g.

typeset -i counter=0
for AA in {0..9}
do
   while
     touch ${TESTDIR}/$((++counter)) &&
     fallocate -l $((4096 + $RANDOM)) $TESTDIR/$((counter))
   do
     if ((counter%100 == 0))
     then
       echo $counter
     fi
   done
   echo "removing ${AA}"
   rm ${TESTDIR}/*${AA}
done

Meanwhile, on my test rig using fallocate did _not_ result in final 
exhaustion of resources. That is btrfs fi df /mnt/Work didn't show 
significant changes on a near full expanse.

I also never got a failed response back from fallocate, that is the 
inner loop never terminated. This could be a problem with the system 
call itself or it could be a problem with the application wrapper.

Nor did I reach the CPU saturation I expected.

e.g.
Gust vm # btrfs fi df /mnt/Work/
Data, RAID1: total=1.72GiB, used=1.66GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=57.84MiB
GlobalReserve, single: total=32.00MiB, used=0.00B

time passes while script running...

Gust vm # btrfs fi df /mnt/Work/
Data, RAID1: total=1.72GiB, used=1.66GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=57.84MiB
GlobalReserve, single: total=32.00MiB, used=0.00B

So there may be some limiting factor or something.

Without the actual writes to the actual file expanse I don't get the stalls.

(I added a _touch_ of instrumentation, it makes the various catostrophy 
events a little more obvious in context. 8-)

mount /dev/whattever /mnt/Work
typeset -i counter=0
for AA in {0..9}
do
   while
     dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + 
$RANDOM)) count=1 2>/dev/null
   do
     if ((counter%100 == 0))
     then
       echo $counter
       if ((counter%1000 == 0))
       then
         btrfs fi df /mnt/Work
       fi
     fi
   done
   btrfs fi df /mnt/Work
   echo "removing ${AA}"
   rm /mnt/Work/*${AA}
   btrfs fi df /mnt/Work
done

So you definitely need the writes to really see the stalls.

> I may try with with my test BTRFS. I could even make it 2x20 GiB RAID 1
> as well.

I guess I never mentioned it... I am using 4x1GiB NOCOW files through 
losetup as the basis of a RAID1. No compression (by virtue of the NOCOW 
files in underlying fs, and not being set in the resulting mount). No 
encryption. No LVM.
