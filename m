Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50014 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2FDBn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jun 2012 21:43:26 -0400
Received: by vcbf11 with SMTP id f11so2203985vcb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jun 2012 18:43:25 -0700 (PDT)
Message-ID: <4FCC12BA.9070701@gmail.com>
Date: Sun, 03 Jun 2012 21:43:22 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FC54A5D.8000600@gmail.com> <4FC55043.4050004@gmail.com> <CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com> <4FC55AB7.3000903@gmail.com> <CAE5mzvjYA-ojJWK8yqTbY6DZCoqcP9B_U2RwYGiahkp3C9t67g@mail.gmail.com> <4FC6D128.60308@gmail.com> <CAGJTRcibT_pufU4tKqbBpBfm8QiuW=dhQ8BAGzQnpxMCa-dOCQ@mail.gmail.com> <4FCA189F.9050000@gmail.com> <4FCC0DD7.9050807@cn.fujitsu.com>
In-Reply-To: <4FCC0DD7.9050807@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

thanks for advice. I tried it before btrfsck. results are here:
max@s0:~$ sudo mount /tank -o recovery
[sudo] password for max:
mount: wrong fs type, bad option, bad superblock on /dev/sdf,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

max@s0:~$ sudo mount -o recovery /tank
mount: wrong fs type, bad option, bad superblock on /dev/sdf,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

dmesg after boot before mount -o recovery:
[   51.829352] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[   51.841153] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[   51.841603] btrfs read error corrected: ino 1 off 5468060241920 (dev 
/dev/sdb sector 2143292648)
[   51.841610] Failed to read block groups: -5
[   51.848057] btrfs: open_ctree failed
..............................
dmesg after both mounts:

[  123.687773] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5 
transid 9096 /dev/sdf
[  123.733678] btrfs: use lzo compression
[  123.733683] btrfs: enabling auto recovery
[  123.733686] btrfs: disk space caching is enabled
[  131.699910] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[  131.714018] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[  131.715059] btrfs read error corrected: ino 1 off 5468060241920 (dev 
/dev/sdb sector 2143292648)
[  131.715072] Failed to read block groups: -5
[  131.727176] btrfs: open_ctree failed
[  161.697873] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5 
transid 9096 /dev/sdf
[  161.746345] btrfs: use lzo compression
[  161.746354] btrfs: enabling auto recovery
[  161.746358] btrfs: disk space caching is enabled
[  169.720823] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[  169.732048] parent transid verify failed on 5468060241920 wanted 9096 
found 7621
[  169.732611] btrfs read error corrected: ino 1 off 5468060241920 (dev 
/dev/sdb sector 2143292648)
[  169.732623] Failed to read block groups: -5
[  169.743437] btrfs: open_ctree failed

So It does not work. I have seen in some posts command:

sudo mount -s 2 -o recovery /tank
Should I try it?

Please help me, I need to get this data ASAP.

Regards,
    Max

On 06/03/2012 09:22 PM, Liu Bo wrote:
> On 06/02/2012 09:43 PM, Maxim Mikheev wrote:
>
>> Repair was not helpful.
>> Is any other ways to get access to data?
>>
>> Please help....
>>
>
> Hi Maxim,
>
> Besides btrfsck --repair, we also have a recovery mount option to deal with your situation,
> maybe you can try mount xxx -o recovery and see if it helps?
>
>
> thanks,
> liubo
>
>> On 05/30/2012 11:15 PM, Michael K wrote:
>>> Let it run to completion. There is little you can do other than hope
>>> and wait.
>>>
>>> On May 30, 2012 9:02 PM, "Maxim Mikheev"<mikhmv@gmail.com
>>> <mailto:mikhmv@gmail.com>>  wrote:
>>>
>>>      btrfsck --repair running already for 26 hours.
>>>
>>>      Is it have sense to wait more?
>>>
>>>      Thanks
>>>
>>>      On 05/29/2012 07:36 PM, cwillu wrote:
>>>
>>>          On Tue, May 29, 2012 at 5:24 PM, Maxim
>>>          Mikheev<mikhmv@gmail.com<mailto:mikhmv@gmail.com>>   wrote:
>>>
>>>              Thank you for your answer.
>>>
>>>
>>>              The system kernel was and now:
>>>
>>>              Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21
>>>              09:22:02 UTC 2012
>>>              x86_64 x86_64 x86_64 GNU/Linux
>>>
>>>              the raid was created by:
>>>              mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>>>
>>>              Disk are connected through RocketRaid 2670.
>>>
>>>              for mounting I used line in fstab:
>>>              UUID=c9776e19-37eb-4f9c-bd6b-04e8dde97682    /tank
>>>               btrfs
>>>               defaults,compress=lzo    0    1
>>>
>>>              On machine was running several Virtual machines. Only one
>>>              was actively using
>>>              disks.
>>>
>>>              VM has active several threads:
>>>              1. 2 threads reading big files (50GB each)
>>>              2. reading from 50 files and writing one big file
>>>              3. The kernel panic happens when I run another program
>>>              with 30 threads of
>>>              reading/writing of small files.
>>>
>>>              Virtual Machine accessed to underline btrfs through 9-p
>>>              file system which
>>>              actively used xattr.
>>>
>>>              After reboot system was in this stage.
>>>
>>>              I hope that btrfsck --repair will not make it worse, It is
>>>              now running.
>>>
>>>          **twitch**
>>>
>>>          Well, I also hope it won't make it worse.  Do not cancel it
>>>          now, let
>>>          it finish (aborting it will  make things worse), but I suggest
>>>          waiting
>>>          until a few more people have weighed in before attempting
>>> anything
>>>          beyond that.
>>>
>>>      --
>>>      To unsubscribe from this list: send the line "unsubscribe
>>>      linux-btrfs" in
>>>      the body of a message to majordomo@vger.kernel.org
>>>      <mailto:majordomo@vger.kernel.org>
>>>      More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
