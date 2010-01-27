From: briaeros007 <briaeros007@gmail.com>
Subject: Re: btrfs fsck doesn't modify a thing, and btrfs can not balance any
	data on a new device
Date: Wed, 27 Jan 2010 12:33:03 +0100
Message-ID: <61bf8f4f1001270333o3914f410r833ad2157612bcc3@mail.gmail.com>
References: <61bf8f4f1001261316u36adbd6cvfeb9bfa0da196e13@mail.gmail.com>
	 <20100127023058.GE11767@dhcp231-156.rdu.redhat.com>
	 <61bf8f4f1001270112v20983f5eg6119306c693dbef2@mail.gmail.com>
	 <3d0408631001270129r6bc0378fqf257971a2fc3a609@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631001270129r6bc0378fqf257971a2fc3a609@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/1/27 Yan, Zheng <yanzheng@21cn.com>:
> On Wed, Jan 27, 2010 at 5:12 PM, briaeros007 <briaeros007@gmail.com> =
wrote:
>> 2010/1/27 Josef Bacik <josef@redhat.com>:
>>> On Tue, Jan 26, 2010 at 10:16:42PM +0100, briaeros007 wrote:
>>>> Hello,
>>>>
>>>> I have a btrfs volume on a two 1TB disk, and i've been trying to a=
dd a
>>>> new (1.5 TB) to this volume. I've done btrfsctl -a /dev/sdb /mnt/b=
trfs
>>>> without trouble, and btrfs-show see the third disk.
>>>> But I've got segfault when I try to balance the data.
>>>> And when a try a fsck, he do absolutely nothing. See the commands
>>>> below (and the dmesg)
>>>>
>>>> So if you have any idea, or want to do any additionnal tests (othe=
r
>>>> than throwing away data that are on theses disks, since, even if i
>>>> know btrfs is under heavy developpment, id'like to keep some data =
and
>>>> haven't the right device right now to do the transfer).
>>>>
>>>>
>>>> Cordially.
>>>>
>>>>
>>>> <root@oni:/home/alpha>
>>>> zsh/3 2 # umount /mnt/btrfs
>>>> umount: /mnt/btrfs: not mounted
>>>> [mar. 10/01/26 20:07
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 3 [1] # btrfsck /dev/sdb
>>>> failed to read /dev/sr0
>>>> bad block 2064048422912
>>>> bad block 924702326784
>>>> leaf parent key incorrect 2026404634624
>>>> bad block 2026404634624
>>>> leaf parent key incorrect 2045515939840
>>>> bad block 2045515939840
>>>> owner ref check failed [924702326784 4096]
>>>> owner ref check failed [2026404634624 4096]
>>>> owner ref check failed [2045515939840 4096]
>>>> owner ref check failed [2064048422912 4096]
>>>> found 1884638785584 bytes used err is 1
>>>> total csum bytes: 1836791604
>>>> total tree bytes: 3778641920
>>>> total fs tree bytes: 1484914688
>>>> btree space waste bytes: 611092845
>>>> file data blocks allocated: 1926324310016
>>>> =C2=A0referenced 1880273379328
>>>> Btrfs v0.19-4-gab8fb4c
>>>> [mar. 10/01/26 20:10
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 4 [1] # btrfsck /dev/sdb
>>>> failed to read /dev/sr0
>>>> bad block 2064048422912
>>>> bad block 924702326784
>>>> leaf parent key incorrect 2026404634624
>>>> bad block 2026404634624
>>>> leaf parent key incorrect 2045515939840
>>>> bad block 2045515939840
>>>> owner ref check failed [924702326784 4096]
>>>> owner ref check failed [2026404634624 4096]
>>>> owner ref check failed [2045515939840 4096]
>>>> owner ref check failed [2064048422912 4096]
>>>> found 1884638785584 bytes used err is 1
>>>> total csum bytes: 1836791604
>>>> total tree bytes: 3778641920
>>>> total fs tree bytes: 1484914688
>>>> btree space waste bytes: 611092845
>>>> file data blocks allocated: 1926324310016
>>>> =C2=A0referenced 1880273379328
>>>> Btrfs v0.19-4-gab8fb4c
>>>> [mar. 10/01/26 20:20
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 5 [1] # mount /mnt/btrfs
>>>> [mar. 10/01/26 21:38
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 6 # btrfs-show
>>>> failed to read /dev/sr0
>>>> Label: none=C2=A0 uuid: 3e021a76-954e-4f54-86a0-fa3849e451c2
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 3 FS byte=
s used 1.71TB
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 3 size 1.36TB used 3.99GB path /dev/sdb
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 2 size 931.51GB used 930.01GB path /dev/sdc
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 1 size 931.51GB used 929.00GB path /dev/sdd
>>>>
>>>> Btrfs v0.19-4-gab8fb4c
>>>> [mar. 10/01/26 21:38
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 7 # btrfs-vol -b /mnt/btrfs
>>>> zsh: segmentation fault=C2=A0 btrfs-vol -b /mnt/btrfs
>>>> [mar. 10/01/26 21:41
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 9 [139] #=C2=A0 dmesg |grep BUG
>>>> [ 6417.151192] kernel BUG at fs/btrfs/volumes.c:1746!
>>>> [mar. 10/01/26 21:42
>>>> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
>>>> <root@oni:/home/alpha>
>>>> zsh/3 10 #
>>>>
>>>> my dmesg, from the warning, then the bug
>>>>
>>>> [ 6413.080969] btrfs: relocating block group 2917377507328 flags 9
>>>> [ 6413.942527] btrfs: relocating block group 2914156281856 flags 9
>>>> [ 6416.792048] btrfs csum failed ino 258 off 249937920 csum 374924=
6389
>>>> private 2282873894
>>>> [ 6416.798204] btrfs csum failed ino 258 off 249937920 csum 374924=
6389
>>>> private 2282873894
>>>> [ 6416.837809] btrfs csum failed ino 258 off 249937920 csum 374924=
6389
>>>> private 2282873894
>>>> [ 6416.841459] btrfs csum failed ino 258 off 249937920 csum 374924=
6389
>>>> private 2282873894
>>>
>>> CSUM failures. =C2=A0Something is going horribly wrong. =C2=A0Eithe=
r one of the following
>>>
>>> 1) A bug
>>> 2) Bad memory
>>> 3) Something went wrong with the disk at some point
>>>
>>> 1 is hard to track down at this point, 3 is possible, but again har=
d to prove.
>>> So try running memtest86 on your system to rule out #2. =C2=A0If th=
e memory checks
>>> out, reformat and try again. =C2=A0If you keep having problems we'l=
l try and figure
>>> out if its #1 or #3. =C2=A0Thanks,
>>>
>>> Josef
>>>
>> Hello,
>>
>> Thanks for your answer, to be sure that the memory isn't in cause (o=
r
>> if it was, that it wouldn't bother me) i've already commanded ecc
>> memory.
>>
>> But what I don't understand is why btrfsck doesnt correct anything ?
>> It detects that X have a bad block, a bad leaf and all.
>> The "bad blocks" doesn't change between the two run of fsck (event
>> after a reboot), why it doesn't devalidate this block in the btree ?
>>
>
> The short answer is repairing error isn't implemented yet. I'm afraid=
 the
> only way to save your data is try mounting the FS in readonly mode an=
d
> copying the data out.
>
> Yan, Zheng
>

Ok, thanks. I have no trouble to access the data, but i thought that
the fsck was working. I will try to add the device once fsck can
correct the error.

Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
