Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ip-88.staren.nu ([77.110.19.88]:37400 "EHLO iapetus.neab.net"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbdHAOjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 10:39:55 -0400
Date: Tue, 1 Aug 2017 16:39:52 +0200 (CEST)
From: pwm <pwm@iapetus.neab.net>
To: Hugo Mills <hugo@carfax.org.uk>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Massive loss of disk space
In-Reply-To: <20170801122039.GX7140@carfax.org.uk>
Message-ID: <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net> <20170801122039.GX7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the links and suggestions.

I did try your suggestions but it didn't solve the underlying problem.



pwm@europium:~$ sudo btrfs balance start -v -dusage=20 /mnt/snap_04
Dumping filters: flags 0x1, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=20
Done, had to relocate 4596 out of 9317 chunks


pwm@europium:~$ sudo btrfs balance start -mconvert=dup,soft /mnt/snap_04/
Done, had to relocate 2 out of 4721 chunks


pwm@europium:~$ sudo btrfs fi df /mnt/snap_04
Data, single: total=4.60TiB, used=4.59TiB
System, DUP: total=40.00MiB, used=512.00KiB
Metadata, DUP: total=6.50GiB, used=4.81GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


pwm@europium:~$ sudo btrfs fi show /mnt/snap_04
Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
         Total devices 1 FS bytes used 4.60TiB
         devid    1 size 9.09TiB used 4.61TiB path /dev/sdg1


So now device 1 usage is down from 9.09TiB to 4.61TiB.

But if I test to fallocate() to grow the large parity file, I directly 
fail. I wrote a little help program that just focuses on fallocate() 
instead of having to run snapraid with lots of unknown additional actions 
being performed.


Original file size is  5050486226944 bytes
Trying to grow file to 5151751667712 bytes
Failed fallocate [No space left on device]



And result after shows 'used' have jumped up to 9.09TiB again.

root@europium:/mnt# btrfs fi show snap_04
Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
         Total devices 1 FS bytes used 4.60TiB
         devid    1 size 9.09TiB used 9.09TiB path /dev/sdg1

root@europium:/mnt# btrfs fi df /mnt/snap_04/
Data, single: total=9.08TiB, used=4.59TiB
System, DUP: total=40.00MiB, used=992.00KiB
Metadata, DUP: total=6.50GiB, used=4.81GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


It's almost like the file system have decided that it needs to make a 
snapshot and store two complete copies of the complete file, which is 
obviously not going to work with a file larger than 50% of the file 
system.

No issue at all to grow the parity file on the other parity disk. And 
that's why I wonder if there is some undetected file system corruption.

/Per W

On Tue, 1 Aug 2017, Hugo Mills wrote:

>   Hi, Per,
>
>   Start here:
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29
>
>   In your case, I'd suggest using "-dusage=20" to start with, as
> it'll probably free up quite a lot of your existing allocation.
>
> And this may also be of interest, in how to read the output of the
> tools:
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools
>
>   Finally, I note that you've still got some "single" chunks present
> for metadata. It won't affect your space allocation issues, but I
> would recommend getting rid of them anyway:
>
> # btrfs balance start -mconvert=dup,soft
>
>   Hugo.
>
> On Tue, Aug 01, 2017 at 01:43:23PM +0200, pwm wrote:
>> I have a 10TB file system with a parity file for a snapraid.
>> However, I can suddenly not extend the parity file despite the file
>> system only being about 50% filled - I should have 5TB of
>> unallocated space. When trying to extend the parity file,
>> fallocate() just returns ENOSPC, i.e. that the disk is full.
>>
>> Machine was originally a Debian 8 (Jessie) but after I detected the
>> issue and no btrfs tool did show any errors, I have updated to
>> Debian 9 (Snatch) to get a newer kernel and newer btrfs tools.
>>
>> pwm@europium:/mnt$ btrfs --version
>> btrfs-progs v4.7.3
>> pwm@europium:/mnt$ uname -a
>> Linux europium 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2
>> (2017-06-26) x86_64 GNU/Linux
>>
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ ls -l
>> total 4932703608
>> -rw------- 1 root root     319148889 Jul  8 04:21 snapraid.content
>> -rw------- 1 root root     283115520 Aug  1 04:08 snapraid.content.tmp
>> -rw------- 1 root root 5050486226944 Jul 31 17:14 snapraid.parity
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ df .
>> Filesystem      1K-blocks       Used  Available Use% Mounted on
>> /dev/sdg1      9766434816 4944614648 4819831432  51% /mnt/snap_04
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ sudo btrfs fi show .
>> Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
>>         Total devices 1 FS bytes used 4.60TiB
>>         devid    1 size 9.09TiB used 9.09TiB path /dev/sdg1
>>
>> Compare this with the second snapraid parity disk:
>> pwm@europium:/mnt/snap_04$ sudo btrfs fi show /mnt/snap_05/
>> Label: 'snap_05'  uuid: bac477e3-e78c-43ee-8402-6bdfff194567
>>         Total devices 1 FS bytes used 4.69TiB
>>         devid    1 size 9.09TiB used 4.70TiB path /dev/sdi1
>>
>> So on one parity disk, devid is 9.09TiB used - on the other only 4.70TiB.
>> While almost the same amount of file system usage. And almost
>> identical usage pattern. It's an archival RAID, so there is hardly
>> any writes to the parity files because there are almost no file
>> changes to the data files. The main usage is that the parity file
>> gets extended when one of the data disks reaches a new high water
>> mark.
>>
>> The only file that gets regularly rewritten is the snapraid.content
>> file that gets regenerated after every scrub.
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ sudo btrfs fi df .
>> Data, single: total=9.08TiB, used=4.59TiB
>> System, DUP: total=8.00MiB, used=992.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, DUP: total=6.00GiB, used=4.81GiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ sudo btrfs filesystem du .
>>      Total   Exclusive  Set shared  Filename
>>    4.59TiB     4.59TiB           -  ./snapraid.parity
>>  304.37MiB   304.37MiB           -  ./snapraid.content
>>  270.00MiB   270.00MiB           -  ./snapraid.content.tmp
>>    4.59TiB     4.59TiB       0.00B  .
>>
>>
>>
>> pwm@europium:/mnt/snap_04$ sudo btrfs filesystem usage .
>> Overall:
>>     Device size:                   9.09TiB
>>     Device allocated:              9.09TiB
>>     Device unallocated:              0.00B
>>     Device missing:                  0.00B
>>     Used:                          4.60TiB
>>     Free (estimated):              4.49TiB      (min: 4.49TiB)
>>     Data ratio:                       1.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 0.00B)
>>
>> Data,single: Size:9.08TiB, Used:4.59TiB
>>    /dev/sdg1       9.08TiB
>>
>> Metadata,single: Size:8.00MiB, Used:0.00B
>>    /dev/sdg1       8.00MiB
>>
>> Metadata,DUP: Size:6.00GiB, Used:4.81GiB
>>    /dev/sdg1      12.00GiB
>>
>> System,single: Size:4.00MiB, Used:0.00B
>>    /dev/sdg1       4.00MiB
>>
>> System,DUP: Size:8.00MiB, Used:992.00KiB
>>    /dev/sdg1      16.00MiB
>>
>> Unallocated:
>>    /dev/sdg1         0.00B
>>
>>
>>
>> pwm@europium:~$ sudo btrfs check /dev/sdg1
>> Checking filesystem on /dev/sdg1
>> UUID: c46df8fa-03db-4b32-8beb-5521d9931a31
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 5057294639104 bytes used err is 0
>> total csum bytes: 4529856120
>> total tree bytes: 5170151424
>> total fs tree bytes: 178700288
>> total extent tree bytes: 209616896
>> btree space waste bytes: 182357204
>> file data blocks allocated: 5073330888704
>>  referenced 5052040339456
>>
>>
>>
>> pwm@europium:~$ sudo btrfs scrub status /mnt/snap_04/
>> scrub status for c46df8fa-03db-4b32-8beb-5521d9931a31
>>         scrub started at Mon Jul 31 21:26:50 2017 and finished after
>> 06:53:47
>>         total bytes scrubbed: 4.60TiB with 0 errors
>>
>>
>>
>> So where have my 5TB disk space gone lost?
>> And what should I do to be able to get it back again?
>>
>> I could obviously reformat the partition and rebuild the parity
>> since I still have one good parity, but that doesn't feel like a
>> good route. It isn't impossible this might happen again.
>>
>> /Per W
>
> -- 
> Hugo Mills             | Well, sir, the floor is yours. But remember, the
> hugo@... carfax.org.uk | roof is ours!
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                             The Goons
>
