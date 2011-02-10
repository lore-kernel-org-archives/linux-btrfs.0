From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Thu, 10 Feb 2011 18:35:10 +0000 (UTC)
Message-ID: <ij1b4u$tsh$1@dough.gmane.org>
References: <iiqphe$217$1@dough.gmane.org> <4D51A0D9.9000701@libero.it>
	<iiscep$udg$1@dough.gmane.org> <4D52DC1E.2050302@libero.it>
	<iiusfk$lp4$1@dough.gmane.org> <4D542D79.9070402@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli, Thu, 10 Feb 2011 19:24:57 +0100:

> On 02/09/2011 09:12 PM, Lubos Kolouch wrote:
>> Goffredo Baroncelli, Wed, 09 Feb 2011 19:25:34 +0100:
>> 
>>> On 02/08/2011 10:26 PM, Lubos Kolouch wrote:
>>>> Goffredo Baroncelli, Tue, 08 Feb 2011 21:00:25 +0100:
>>>>
>>>>> On 02/08/2011 07:57 AM, Lubos Kolouch wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I'm hitting this issue - sda5 is a normal device, nothing to do
>>>>>> with loop, encryption etc.
>>>>>>
>>>>>> # mkfs.btrfs /dev/sda5
>>>>>>
>>>>>> WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL WARNING! -
>>>>>> see http://btrfs.wiki.kernel.org before using
>>>>>>
>>>>>> error checking /dev/sda5 mount status
>>>>>>
>>>>>> Is there something I can do to resolve this?
>>>>>
>>>>> Some months ago I posted a patch [*] which allows to create a
>>>>> filesystem even if an integrity tests fail. Anyway it would be
>>>>> interesting understand why mkfs.btrfs fails. It is possible to have
>>>>> a strace of the command ?
>>>>>
>>>>>
>>>> here ... http://paste.pocoo.org/show/334638/ but it is not in chroot,
>>>> it is in "normal" system
>>>>
>>>> Lubos
>>>>
>>>>
>>> Hi Lubos,
>>>
>>> Could you post also the output of "cat /proc/mounts" command and the
>>> output of "btrfs filesystem show" command. I cannot understand what
>>> should be the problem.
>> 
>> Hi Goffredo,
>> 
>> Sure,
>> # cat /proc/mounts
>> 
>> rootfs / rootfs rw 0 0
>> /dev/root / btrfs rw,noatime,compress,ssd 0 0 proc /proc proc
>> rw,nosuid,nodev,noexec,relatime 0 0 rc-svcdir /lib/rc/init.d tmpfs
>> rw,nosuid,nodev,noexec,relatime,size=1024k,mode=755 0 0 sysfs /sys
>> sysfs rw,nosuid,nodev,noexec,relatime 0 0 securityfs
>> /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
>> debugfs /sys/kernel/debug debugfs rw,nosuid,nodev,noexec,relatime 0 0
>> udev /dev devtmpfs
>> rw,nosuid,relatime,size=10240k,nr_inodes=217934,mode=755 0 0 fusectl
>> /sys/fs/fuse/connections fusectl rw,relatime 0 0 none /dev/pts devpts
>> rw,relatime,mode=600,ptmxmode=000 0 0 none /dev/shm tmpfs rw,relatime 0
>> 0
>> /dev/sda1 /boot ext2 rw,relatime,errors=continue 0 0 none
>> /var/tmp/portage tmpfs rw,relatime 0 0 binfmt_misc
>> /proc/sys/fs/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,relatime 0
>> 0
>> /dev/mapper/_dev_sda6 /home btrfs rw,noatime,compress,ssd 0 0
>> 
>> # btrfs filesystem show
>> 
>> Label: none  uuid: fd070c17-e98b-4b50-9fa8-3453482aafa2
>> 	Total devices 1 FS bytes used 5.51GB
>> 	devid    1 size 18.64GB used 10.79GB path /dev/sda2
>> 
>> Label: none  uuid: bf9a1b00-f8bd-44d3-b140-10eea088a60e
>> 	Total devices 1 FS bytes used 6.73GB
>> 	devid    1 size 19.54GB used 19.54GB path /dev/sda5
>> 
>> Label: none  uuid: ae0ba016-1945-4e7a-9fb4-e9311d199727
>> 	Total devices 1 FS bytes used 57.50GB devid    1 size 78.91GB used
>> 	78.91GB path /dev/dm-0
>> 
>> # mkfs.btrfs /dev/sda5
>> 
>> WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL WARNING! - see
>> http://btrfs.wiki.kernel.org before using
>> 
>> error checking /dev/sda5 mount status
>> 
>> Also, I can mount it no problem - strange, isn't it
> 
> 
> Ok, I think to have track down the problem. To me it seems a bug in
> mkfs.btrfs.
> 
> The first thing that should be highlighted is that you are trying to
> format an already btrfs formatted device. In this there is not anything
> wrong.
> 
> However, before formatting a device mkfs.btrfs performs some sanity
> check. It checks if the device is already mounted, scanning
> /proc/mounts.
> 
> In a normal case (the device which will be formatted doesn't contain a
> btrfs filesystem), mkfs.btrfs is smart enough to don't check device
> which are in /proc/mounts bat doesn't exist (like /dev/root).
> 
> Instead when the device which will be formatted already contains a btrfs
> filesystem, mkfs.btrfs performs a different checks. In fact it considers
> also the case of a multi-device based btrfs filesystem. However in this
> case it doesn't skip a not existent device but it raises an error. I
> think that this is a bug.
> 
> As workaround I suggest the following: make a link between the real root
> device and /dev/root.
> 
> It should be sufficient to format the device.
> 

Hello - you are right...

# ln -s /dev/sda2 /dev/root

# mkfs.btrfs /dev/sda5

WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sda5
	nodesize 4096 leafsize 4096 sectorsize 4096 size 19.54GB
Btrfs v0.19-35-g1b444cd-dirty


Lubos

