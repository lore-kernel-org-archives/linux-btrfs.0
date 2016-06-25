Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:54096 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751101AbcFYAGN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 20:06:13 -0400
Date: Sat, 25 Jun 2016 01:06:10 +0100
Message-ID: <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
From: Vasco Almeida <vascomalmeida@sapo.pt>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
References: <loom.20160623T205347-371@post.gmane.org>
 <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo>
 <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
In-Reply-To: <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Citando Chris Murphy <lists@colorremedies.com>:

> On Fri, Jun 24, 2016 at 9:52 AM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
>
>>>
>>> From the pasted kernel messages:
>>> > Linux version 3.18.34-std473-amd64 (root@rl-sysrcd-p11) (gcc  
>>> version 4.8.5
>>> > (Gentoo 4.8.5 p1.3, pie-0.6.2) ) #2 SMP Tue May 24 20:34:19 UTC 2016
>>> 3.18.34 is ancient. Find something newer and try to remount normally.
>> Present information concerns openSUSE Leap 42.1 (x86_64) mount of root file
>> system at boot time. That should mount it normally. Hope that fits what you
>> mean.
>
> OK but it's not mounting it normally, it's still being forced readonly
> at btrfs_drop_snapshot and the only thing I'm coming up with search
> wise is that it's related to qgroups. Have you enabled quotas on this
> file system ever?

Unless openSUSE does that by default, I did not enable quotas. It is  
not something I am aware of doing.
>
>
>> btrfs-progs v4.1.2+20151002
>
> A lot of changes have happened since 4.1.2 I would still use something
> newer and try to repair it.

By repair do you mean issue "btrfs check --repair /device" ?

>> $ /usr/sbin/btrfs fi df /
>> Data, single: total=10.01GiB, used=9.06GiB
>> System, DUP: total=64.00MiB, used=16.00KiB
>> Metadata, DUP: total=1.12GiB, used=596.69MiB
>> GlobalReserve, single: total=208.00MiB, used=0.00B
>>
>> I forgot to mention in last e-mail that I ran Marc MERLIN's scrubbing script
>> [1] after mounting the device with "-o ro,recovery" on System Rescue CD.
>> Even after that device is forced readonly.
>
> OK but System Rescue CD uses an old kernel by btrfs standards, even
> account for all the backports in that particular version:
> 4.7.3) 2016-06-04:
> Standard kernels: Long-Term-Supported linux-3.18.34 (rescue32 + rescue64)
>
> So that's why I'm suggesting you use something newer, like 4.5.x, same
> for btrfs-progs. The old versions aren't working. There's no assurance
> it'll work with new versions, but that it doesn't get fixed up with
> old versions means you either try new versions or you rebuild the file
> system. *shrug*

I am using Fedora 24 and have issued "mount  
/dev/mapper/vg_pupu-lv_opensuse_root /mnt". Got some call trace and  
scary stuff that did not get before on other systems. Please check  
dmesg output linked below.

Linux catarina 4.5.7-300.fc24.x86_64 #1 SMP Wed Jun 8 18:12:45 UTC  
2016 x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs v4.5.2

# btrfs fi show
Label: none  uuid: ad167e92-fbb1-4148-b54d-6345b6fb26da
	Total devices 1 FS bytes used 9.63GiB
	devid    1 size 50.00GiB used 12.32GiB path  
/dev/mapper/vg_pupu-lv_opensuse_root
# btrfs fi df /mnt/
Data, single: total=10.01GiB, used=9.05GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.12GiB, used=597.62MiB
GlobalReserve, single: total=208.00MiB, used=224.00KiB

dmesg http://paste.fedoraproject.org/384352/80842814/
dmesg after umount http://paste.fedoraproject.org/384359/14668108/
diff between two http://paste.fedoraproject.org/384364/11704146/

btrfs check --readonly /dev/mappper/vg_pupu-lv_opensuse_root
http://paste.fedoraproject.org/384361/68112421/

After umount and mounting again, the device was normally mounted  
readwrite again:
/dev/mapper/vg_pupu-lv_opensuse_root on /mnt type btrfs  
(rw,relatime,seclabel,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot)
But trying to umount it afterwards makes umount command hang. Device  
no longer shows on mount output, though.
CTRL-C or SIGTERM can't kill umount.

dmesg http://paste.fedoraproject.org/384371/14668130/



>> I would like to find a solution to be able to mount normally readwrite again
>> and hopefully understand what caused the issue.
>
> My best guess is qgroup related, there were a lot of problems with
> multiple quota implementations and snapshots and openSUSE does take
> many many snapshots. So that could be it. But without a reproducer
> it's hard to say what caused it.

Thank you again for your time and reply.

