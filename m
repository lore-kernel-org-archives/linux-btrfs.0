From: Karl Mardoff Kittilsen <karl@kittilsen.org>
Subject: Re: kernel BUG at /build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Date: Tue, 29 Nov 2011 16:29:54 +0100
Message-ID: <4ED4FA72.5050804@kittilsen.org>
References: <4ED437CE.3060909@kittilsen.org> <20111129151256.GJ24338@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129151256.GJ24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Den 29. nov. 2011 16:12, skrev Chris Mason:
> On Tue, Nov 29, 2011 at 02:39:26AM +0100, Karl Mardoff Kittilsen wrote:
>> Hi!
>>
>> Sending a mail on this issue, as advised on IRC.
>>
>> My /home file system fails to mount and the kernel seem to freeze
>> and I need to do the Alt+SysRq RSNEIUB routine to boot it safely.
>> The corruption happened on a 3.2-rc<something>  kernel and Ubuntu
>> 11.10, but I am now running on Ubuntu 12.04 with the 3.2.0-2-generic
>> kernel to see if that helped, it did not.
>> btrfsck from the latest btrfs-tools returns:
>>
>> karl@karl-precise:~/git/btrfs-progs$ sudo ./btrfsck /dev/md0
>> ref mismatch on [2176962560 8192] extent item 480, found 1
>> Incorrect local backref count on 2176970752 root 5 owner 2101705
>> offset 368640 found 1 wanted 3925868545
>> backpointer mismatch on [2176970752 4096]
>
> So the crashes below were because we tried to free one of these extents.
> You have two extents whose reference counts are way off.
>
> Unfortunately this is stored on disk, so different kernels aren't going
> to fix it (yet).  One of the extents is in a file with inode number
> 2101705, and the other is in a btree block (2176962560).
>
> I'll be able to fix this soon, but we can also make a patch that changes
> those BUG_ONs to just deal with the mismatch.  The worst case here would
> be leaking those two extents, about 12K of data.
>
> -chris

Thank you for looking into it, and that does sounds really promising. I 
am available to test any patches you want tested. Is there anything else 
that I can do to help getting this issue fixed?

Karl
