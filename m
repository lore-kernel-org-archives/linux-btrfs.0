From: Tomas Zvala <tomas@zvala.cz>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with large
 max_sectors_kb
Date: Mon, 28 Feb 2011 13:26:07 +0100
Message-ID: <4D6B945F.3030501@zvala.cz>
References: <bug-29302-10286@https.bugzilla.kernel.org/> <20110217153719.9ecc67df.akpm@linux-foundation.org> <20110218174315.GD5615@twin.jikos.cz> <1298056463-sup-4453@think> <20110218115603.5f235b07.akpm@linux-foundation.org> <1298059754-sup-2258@think> <4D60F5C2.2040907@zvala.cz> <1298300392-sup-8700@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	bugzilla-daemon <bugzilla-daemon@bugzilla.kernel.org>,
	bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
	fox <fox@murder.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298300392-sup-8700@think>
List-ID: <linux-btrfs.vger.kernel.org>


On 02/21/2011 04:08 PM, Chris Mason wrote:
> Excerpts from Tomas Zvala's message of 2011-02-20 06:06:42 -0500:
>> On 18.2.2011 21:18, Chris Mason wrote:
>>> Ok, so it isn't part of the open devices code that prints errors, my
>>> guess is we're failing to read a good super.
>>>
>>> Could you please mkfs.btrfs /dev/xxx, sync, then btrfsck /dev/xxx, I want
>>> to make sure things are really getting written.
>>>
>>> Here's a patch that makes sure we have a good bdev after scanning,
>>> hopefully it will let us debug things without your box going boom.
>>>
>>> -chris
>>>
>>>
>> Hello Chris,
>> I patched the kernel, recompiled and installed, but I don't see the
>> message in the kernel log.  I forgot to mention before, that
>> max_hw_sectors_kb and thus max_sectors_kb is 4096.
> ok, more below.
>
>> Linux stg-top 2.6.37stg #7 SMP Sun Feb 20 10:48:57 CET 2011 x86_64
>> Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux
>>
>>
>> With default max_sectors_kb = 512
>> mkfs, sync, btrfsck going through fine
>> first mount is fine
>>
>> [112005]stg-top ~ # cat /sys/block/sdb/queue/max_sectors_kb
>> 512
>> [112012]stg-top ~ # mkfs.btrfs /dev/sdb
>>
>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> fs created label (null) on /dev/sdb
>>           nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
>> Btrfs Btrfs v0.19
>> [112045]stg-top ~ # sync
>> [112046]stg-top ~ # btrfsck /dev/sdb
>> found 28672 bytes used err is 0
>> total csum bytes: 0
>> total tree bytes: 28672
>> total fs tree bytes: 8192
>> btree space waste bytes: 23875
>> file data blocks allocated: 0
>>    referenced 0
>> Btrfs Btrfs v0.19
>> [112050]stg-top ~ # mount /dev/sdb /mnt/
>> [112054]stg-top ~ # df /mnt/
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdb             2929685760        56 2927559936   1% /mnt
>> [112057]stg-top ~ # umount /mnt
>>
>>
>> With max_sectors_kb = 4096
>> mkfs, sync, btrfsck is fine
>> second mount  BUGs out
>>
>> [112100]stg-top ~ # echo 4096>  /sys/block/sdb/queue/max_sectors_kb
>> [112107]stg-top ~ # mkfs.btrfs /dev/sdb
>>
>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> fs created label (null) on /dev/sdb
>>           nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
>> Btrfs Btrfs v0.19
>> [112113]stg-top ~ # sync
>> [112117]stg-top ~ # btrfsck /dev/sdb
>> found 28672 bytes used err is 0
>> total csum bytes: 0
>> total tree bytes: 28672
>> total fs tree bytes: 8192
>> btree space waste bytes: 23875
>> file data blocks allocated: 0
>>    referenced 0
>> Btrfs Btrfs v0.19
>> [112123]stg-top ~ # mount /dev/sdb /mnt/
>> Killed
> At this point, your box is broken.  You have to reboot before anything
> new is valid (sorry).  Could you please:
>
> Set max_sectors_kb to 4096
> mkfs.btrfs /dev/xxx
> sync
> echo 3>  /proc/sys/vm/drop_caches
> btrfsck /dev/xxx
>
> Don't try and mount, clearly my patch isn't saving us.
>
> -chris
>
Hello Chris,
I'm sorry it took so long, I've been a bit busy lately ...

[132926]stg-bot linux-2.6.37-scst # cat 
/sys/block/sdb/queue/max_hw_sectors_kb > /sys/block/sdb/queue/max_sectors_kb
[132932]stg-bot linux-2.6.37-scst # mkfs.btrfs /dev/sdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb
     nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
Btrfs Btrfs v0.19
[132945]stg-bot linux-2.6.37-scst # sync
[132948]stg-bot linux-2.6.37-scst # echo 3 > /proc/sys/vm/drop_caches
[132958]stg-bot linux-2.6.37-scst # btrfsc
btrfsck   btrfsctl
[132958]stg-bot linux-2.6.37-scst # btrfsck /dev/sdb
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
  referenced 0
Btrfs Btrfs v0.19


And still cannot mount.


Tomas
