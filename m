Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:37843 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754066Ab2FDISP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 04:18:15 -0400
Message-ID: <4FCC6F44.2030503@gmx.net>
Date: Mon, 04 Jun 2012 10:18:12 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: Maxim Mikheev <mikhmv@gmail.com>, linux-btrfs@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Help with data recovering
References: <4FC54A5D.8000600@gmail.com> <4FC55043.4050004@gmail.com> <CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com> <4FC55AB7.3000903@gmail.com> <CAE5mzvjYA-ojJWK8yqTbY6DZCoqcP9B_U2RwYGiahkp3C9t67g@mail.gmail.com> <4FC6D128.60308@gmail.com> <CAGJTRcibT_pufU4tKqbBpBfm8QiuW=dhQ8BAGzQnpxMCa-dOCQ@mail.gmail.com> <4FCA189F.9050000@gmail.com> <4FCC0DD7.9050807@cn.fujitsu.com> <4FCC12BA.9070701@gmail.com> <4FCC1A6F.8050805@cn.fujitsu.com> <4FCC1AE1.8050802@gmail.com> <4FCC2496.6070805@cn.fujitsu.com>
In-Reply-To: <4FCC2496.6070805@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.06.2012 04:59, Liu Bo wrote:
> On 06/04/2012 10:18 AM, Maxim Mikheev wrote:
> 
>> Hi Liu,
>>
>> 1) all of them not working (see dmesg at the end)
>> 2)
>> max@s0:~$ sudo btrfs scrub start /dev/sdb
>> ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
>> max@s0:~$ sudo btrfs scrub start /dev/sda
>> ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
>> max@s0:~$ sudo btrfs scrub start /dev/sdd
>> ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
>> max@s0:~$ sudo btrfs scrub start /dev/sde
>> ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
>> max@s0:~$ sudo btrfs scrub start /dev/sdf
>> ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
>>
> 

Even to scrub a single device, the filesystem has to be mounted.

> 
> (add Jan and Arne to cc, they are authors of scrub)
> 
> I'm not an expert on scrub, and I'm not clear how to scrub a device directly :(
> 
> btw, have you tried restore (for attempting to recover data from an unmountable filesystem):
> 
> https://btrfs.wiki.kernel.org/index.php/Restore
> 
> thanks,
> liubo
> 
> 
>> dmesg after all operations:
>> [ 2183.864056] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 2
>> transid 9096 /dev/sdb
>> [ 2183.916128] btrfs: disk space caching is enabled
>> [ 2191.863409] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2191.872937] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2191.873666] btrfs read error corrected: ino 1 off 5468060241920 (dev
>> /dev/sdb sector 2143292648)
>> [ 2191.873678] Failed to read block groups: -5
>> [ 2191.884636] btrfs: open_ctree failed
>> [ 2222.910225] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 3
>> transid 9095 /dev/sdd
>> [ 2222.959128] btrfs: disk space caching is enabled
>> [ 2231.264285] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2231.274306] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2231.275194] btrfs read error corrected: ino 1 off 5468060241920 (dev
>> /dev/sdd sector 2143292648)
>> [ 2231.275207] Failed to read block groups: -5
>> [ 2231.288795] btrfs: open_ctree failed
>> [ 2240.624691] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 4
>> transid 9096 /dev/sde
>> [ 2240.671344] btrfs: disk space caching is enabled
>> [ 2248.916772] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2248.928106] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2248.929091] btrfs read error corrected: ino 1 off 5468060241920 (dev
>> /dev/sdd sector 2143292648)
>> [ 2248.929105] Failed to read block groups: -5
>> [ 2248.939081] btrfs: open_ctree failed
>> [ 2253.829071] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5
>> transid 9096 /dev/sdf
>> [ 2253.879940] btrfs: disk space caching is enabled
>> [ 2261.754357] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2261.767118] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2261.767929] btrfs read error corrected: ino 1 off 5468060241920 (dev
>> /dev/sdb sector 2143292648)
>> [ 2261.767942] Failed to read block groups: -5
>> [ 2261.778219] btrfs: open_ctree failed
>> [ 2309.831415] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 1
>> transid 9096 /dev/sda
>> [ 2309.904520] btrfs: disk space caching is enabled
>> [ 2318.286463] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2318.302991] parent transid verify failed on 5468060241920 wanted 9096
>> found 7621
>> [ 2318.304000] btrfs read error corrected: ino 1 off 5468060241920 (dev
>> /dev/sdd sector 2143292648)
>> [ 2318.304013] Failed to read block groups: -5
>> [ 2318.314587] btrfs: open_ctree failed
>>
>> On 06/03/2012 10:16 PM, Liu Bo wrote:
>>> On 06/04/2012 09:43 AM, Maxim Mikheev wrote:
>>>
>>>> Hi Liu,
>>>>
>>>> thanks for advice. I tried it before btrfsck. results are here:
>>>> max@s0:~$ sudo mount /tank -o recovery
>>>> [sudo] password for max:
>>>> mount: wrong fs type, bad option, bad superblock on /dev/sdf,
>>>>         missing codepage or helper program, or other error
>>>>         In some cases useful info is found in syslog - try
>>>>         dmesg | tail  or so
>>>>
>>>> max@s0:~$ sudo mount -o recovery /tank
>>>> mount: wrong fs type, bad option, bad superblock on /dev/sdf,
>>>>         missing codepage or helper program, or other error
>>>>         In some cases useful info is found in syslog - try
>>>>         dmesg | tail  or so
>>>>
>>>
>>> Two possible ways:
>>>
>>> 1)
>>> I noticed that your btrfs had 5 partitions in all:
>>> mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>>>
>>> Can you try to mount other disk partitions instead by hand, like:
>>> mount /dev/sdb /tank
>>> mount /dev/sdc /tank
>>> mount /dev/sdd /tank
>>> mount /dev/sde /tank
>>> mount /dev/sdf /tank
>>>
>>> 2)
>>> use btrfs's scrub to resort to metadata backups created by RAID1.
>>>
>>> thanks,
>>> liubo
>>>
>>>> dmesg after boot before mount -o recovery:
>>>> [   51.829352] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [   51.841153] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [   51.841603] btrfs read error corrected: ino 1 off 5468060241920 (dev
>>>> /dev/sdb sector 2143292648)
>>>> [   51.841610] Failed to read block groups: -5
>>>> [   51.848057] btrfs: open_ctree failed
>>>> ..............................
>>>> dmesg after both mounts:
>>>>
>>>> [  123.687773] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5
>>>> transid 9096 /dev/sdf
>>>> [  123.733678] btrfs: use lzo compression
>>>> [  123.733683] btrfs: enabling auto recovery
>>>> [  123.733686] btrfs: disk space caching is enabled
>>>> [  131.699910] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [  131.714018] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [  131.715059] btrfs read error corrected: ino 1 off 5468060241920 (dev
>>>> /dev/sdb sector 2143292648)
>>>> [  131.715072] Failed to read block groups: -5
>>>> [  131.727176] btrfs: open_ctree failed
>>>> [  161.697873] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5
>>>> transid 9096 /dev/sdf
>>>> [  161.746345] btrfs: use lzo compression
>>>> [  161.746354] btrfs: enabling auto recovery
>>>> [  161.746358] btrfs: disk space caching is enabled
>>>> [  169.720823] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [  169.732048] parent transid verify failed on 5468060241920 wanted 9096
>>>> found 7621
>>>> [  169.732611] btrfs read error corrected: ino 1 off 5468060241920 (dev
>>>> /dev/sdb sector 2143292648)
>>>> [  169.732623] Failed to read block groups: -5
>>>> [  169.743437] btrfs: open_ctree failed
>>>>
>>>> So It does not work. I have seen in some posts command:
>>>>
>>>> sudo mount -s 2 -o recovery /tank
>>>> Should I try it?
>>>>
>>>> Please help me, I need to get this data ASAP.
>>>>
>>>> Regards,
>>>>     Max
>>>>
>>>> On 06/03/2012 09:22 PM, Liu Bo wrote:
>>>>> On 06/02/2012 09:43 PM, Maxim Mikheev wrote:
>>>>>
>>>>>> Repair was not helpful.
>>>>>> Is any other ways to get access to data?
>>>>>>
>>>>>> Please help....
>>>>>>
>>>>> Hi Maxim,
>>>>>
>>>>> Besides btrfsck --repair, we also have a recovery mount option to deal
>>>>> with your situation,
>>>>> maybe you can try mount xxx -o recovery and see if it helps?
>>>>>
>>>>>
>>>>> thanks,
>>>>> liubo
>>>>>
>>>>>> On 05/30/2012 11:15 PM, Michael K wrote:
>>>>>>> Let it run to completion. There is little you can do other than hope
>>>>>>> and wait.
>>>>>>>
>>>>>>> On May 30, 2012 9:02 PM, "Maxim Mikheev"<mikhmv@gmail.com
>>>>>>> <mailto:mikhmv@gmail.com>>   wrote:
>>>>>>>
>>>>>>>       btrfsck --repair running already for 26 hours.
>>>>>>>
>>>>>>>       Is it have sense to wait more?
>>>>>>>
>>>>>>>       Thanks
>>>>>>>
>>>>>>>       On 05/29/2012 07:36 PM, cwillu wrote:
>>>>>>>
>>>>>>>           On Tue, May 29, 2012 at 5:24 PM, Maxim
>>>>>>>           Mikheev<mikhmv@gmail.com<mailto:mikhmv@gmail.com>>   
>>>>>>> wrote:
>>>>>>>
>>>>>>>               Thank you for your answer.
>>>>>>>
>>>>>>>
>>>>>>>               The system kernel was and now:
>>>>>>>
>>>>>>>               Linux s0 3.4.0-030400-generic #201205210521 SMP Mon
>>>>>>> May 21
>>>>>>>               09:22:02 UTC 2012
>>>>>>>               x86_64 x86_64 x86_64 GNU/Linux
>>>>>>>
>>>>>>>               the raid was created by:
>>>>>>>               mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>>>>>>>
>>>>>>>               Disk are connected through RocketRaid 2670.
>>>>>>>
>>>>>>>               for mounting I used line in fstab:
>>>>>>>               UUID=c9776e19-37eb-4f9c-bd6b-04e8dde97682    /tank
>>>>>>>                btrfs
>>>>>>>                defaults,compress=lzo    0    1
>>>>>>>
>>>>>>>               On machine was running several Virtual machines.
>>>>>>> Only one
>>>>>>>               was actively using
>>>>>>>               disks.
>>>>>>>
>>>>>>>               VM has active several threads:
>>>>>>>               1. 2 threads reading big files (50GB each)
>>>>>>>               2. reading from 50 files and writing one big file
>>>>>>>               3. The kernel panic happens when I run another program
>>>>>>>               with 30 threads of
>>>>>>>               reading/writing of small files.
>>>>>>>
>>>>>>>               Virtual Machine accessed to underline btrfs through 9-p
>>>>>>>               file system which
>>>>>>>               actively used xattr.
>>>>>>>
>>>>>>>               After reboot system was in this stage.
>>>>>>>
>>>>>>>               I hope that btrfsck --repair will not make it worse,
>>>>>>> It is
>>>>>>>               now running.
>>>>>>>
>>>>>>>           **twitch**
>>>>>>>
>>>>>>>           Well, I also hope it won't make it worse.  Do not cancel it
>>>>>>>           now, let
>>>>>>>           it finish (aborting it will  make things worse), but I
>>>>>>> suggest
>>>>>>>           waiting
>>>>>>>           until a few more people have weighed in before attempting
>>>>>>> anything
>>>>>>>           beyond that.
>>>>>>>
>>>>>>>       --
>>>>>>>       To unsubscribe from this list: send the line "unsubscribe
>>>>>>>       linux-btrfs" in
>>>>>>>       the body of a message to majordomo@vger.kernel.org
>>>>>>>       <mailto:majordomo@vger.kernel.org>
>>>>>>>       More majordomo info at
>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>
