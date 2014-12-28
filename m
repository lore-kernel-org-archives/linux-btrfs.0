Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:54239 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbaL1Owq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 09:52:46 -0500
Message-ID: <54A01939.3010204@pobox.com>
Date: Sun, 28 Dec 2014 06:52:41 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <m7nkoo$15b$1@ger.gmane.org> <549F80FD.4050804@pobox.com> <11274819.qjhECasOKp@merkaba>
In-Reply-To: <11274819.qjhECasOKp@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2014 04:07 AM, Martin Steigerwald wrote:
> Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
>> Now:
>>
>> The complaining party has verified the minimum, repeatable case of
>> simple file allocation on a very fragmented system and the responding
>> party and several others have understood and supported the bug.
>
> I didn´t yet provide such a test case.

My bad.

>
> At the moment I can only reproduce this kworker thread using a CPU for
> minutes case with my /home filesystem.
>
> A mininmal test case for me would be to be able to reproduce it with a
> fresh BTRFS filesystem. But yet with my testcase with the fresh BTRFS I
> get 4800 instead of 270 IOPS.
>

A version of the test case to demonstrate absolutely system-clogging 
loads is pretty easy to construct.

Make a raid1 filesystem.
Balance it once to make sure the seed filesystem is fully integrated.

Create a bunch of small files that are at least 4K in size, but are 
randomly sized. Fill the entire filesystem with them.

BASH Script:
typeset -i counter=0
while
  dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + $RANDOM)) 
count=1 2>/dev/null
do
echo $counter >/dev/null #basically a noop
done

The while will exit when the dd encounters a full filesystem.

Then delete ~10% of the files with
rm *0

Run the while loop again, then delete a different 10% with "rm *1".

Then again with rm *2, etc...

Do this a few times and with each iteration the CPU usage gets worse and 
worse. You'll easily get system-wide stalls on all IO tasks lasting ten 
or more seconds.

I don't have enough spare storage to do this directly, so I used 
loopback devices. First I did it with the loopback files in COW mode. 
Then I did it again with the files in NOCOW mode. (the COW files got 
thick with overwrite real fast. 8-)

So anyway...

After I got through all ten digits on the rm (that is removing *0, then 
refilling, then *1 etc...) I figured the FS image was nicely fragmented.

At that point it was very easy to spike the kworker to 100% CPU with

dd if=/dev/urandom of=/mnt/Work/scratch bs=40k

The DD wold read 40k (a cpu spike for /dev/urandom processing) then it 
would write the 40k and the kworker would peg 100% on one CPU and stay 
there for a while. Then it would be back to the /dev/urandom spike.

So this laptop has been carefully detuned to prevent certain kinds of 
stalls (particularly the moveablecore= reservation, as previously 
mentioned, to prevent non-responsiveness of the UI) and I had to go 
through /dev/loop so that had a smoothing effect... but yep, there were 
clear kworker spikes that _did_ stop the IO path (the system monitor ap, 
for instance,  could not get I/O statistics for ten and fifteen second 
intervals and would stop logging/scrolling).

Progressively larger block sizes on the write path made things 
progressively worse...

dd if=/dev/urandom of=/mnt/Work/scratch bs=160k


And overwriting the file by just invoking DD again, was worse still 
(presumably from the juggling act) before resulting in a net 
out-of-space condition.

Switching from /dev/urandom to /dev/zero for writing the large file made 
things worse still -- probably since there were no respites for the 
kworker to catch up etc.

ASIDE: Playing with /proc/sys/vm/dirty_{background_,}ratio had lots of 
interesting and difficult to quantify effects on user-space 
applications. Cutting in half (5 and 10 instead of 10 and 20 
respectively) seemed to give some relief, but going further got harmful 
quickly. Diverging numbers was odd too. But it seemed a little brittle 
to play with these numbers.

SUPER FREAKY THING...

Every time I removed and recreated "scratch" I would get _radically_ 
different results for how much I could write into that remaining space 
and how long it took to do so. In theory I am reusing the exact same 
storage again and again. I'm not doing compression (the underlying 
filessytem behind the loop devices have compression but that would be 
disabled by the +C attribute). It's not enough space coming-and-going to 
cause data extents to be reclaimed or displaced by metadata. And the 
filessytem is otherwise completely unused.

But check it out...

Gust Work # rm scratch
Gust Work # dd if=/dev/zero of=/mnt/Work/scratch bs=160k count=1700
1700+0 records in
1700+0 records out
278528000 bytes (279 MB) copied, 1.4952 s, 186 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/zero of=/mnt/Work/scratch bs=160k count=1700
1700+0 records in
1700+0 records out
278528000 bytes (279 MB) copied, 292.135 s, 953 kB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/zero of=/mnt/Work/scratch bs=160k count=1700
dd: error writing ‘/mnt/Work/scratch’: No space left on device
93+0 records in
92+0 records out
15073280 bytes (15 MB) copied, 0.0453977 s, 332 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k count=1700
dd: error writing ‘/mnt/Work/scratch’: No space left on device
1090+0 records in
1089+0 records out
178421760 bytes (178 MB) copied, 115.991 s, 1.5 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k count=1700
dd: error writing ‘/mnt/Work/scratch’: No space left on device
332+0 records in
331+0 records out
54231040 bytes (54 MB) copied, 30.1589 s, 1.8 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k count=1700
dd: error writing ‘/mnt/Work/scratch’: No space left on device
622+0 records in
621+0 records out
101744640 bytes (102 MB) copied, 37.4813 s, 2.7 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k count=1700
1700+0 records in
1700+0 records out
278528000 bytes (279 MB) copied, 121.863 s, 2.3 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k count=1700
1700+0 records in
1700+0 records out
278528000 bytes (279 MB) copied, 24.2909 s, 11.5 MB/s
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k
dd: error writing ‘/mnt/Work/scratch’: No space left on device
1709+0 records in
1708+0 records out
279838720 bytes (280 MB) copied, 139.538 s, 2.0 MB/s
Gust Work # rm scratch
Gust Work # dd if=/dev/urandom of=/mnt/Work/scratch bs=160k
dd: error writing ‘/mnt/Work/scratch’: No space left on device
1424+0 records in
1423+0 records out
233144320 bytes (233 MB) copied, 102.257 s, 2.3 MB/s
Gust Work #

(and so on)

So...

Repeatable: yes.
Problematic: yes.

