From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 07 Feb 2012 12:17:23 +0800
Message-ID: <4F30A5D3.60706@cn.fujitsu.com>
References: <20120205184128.GC18806@localhost.localdomain> <20120207033945.GA5639@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: nemesis@icequake.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120207033945.GA5639@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2012 11:39 AM, Ryan C. Underwood wrote:
> Does anyone have any idea how I should proceed with the below quoted
> situation?  Unfortunately, I am going to have to give up on btrfs if
> it is really so fragile.  I am using kernel 3.2.2 and btrfs-tools
> from November.
> 
> On Sun, Feb 05, 2012 at 12:41:28PM -0600, Ryan C. Underwood wrote:
>> Hi,
>>
>> I had a RAID5 double disk failure (40 megs or so bad sectors near
>> middle of the second failed disk), bad news but I recovered what I was
>> able to.
>>
>> The RAID contained a dm-crypt physical volume which then contained
>> four logical volumes.  Two are EXT4 and two BTRFS, about 1TB in size
>> each.
>>
>> The failure occurred while the volumes were online and in use, so in
>> addition to what was unreadable, all pending writes to the device
>> between the failure and when the problem was discovered were lost as
>> well.
>>

Hi Ryan,

So on the failure, what does dmesg show?  checksum errors?


>> The two ext4, fortunately, had some relatively minor corruption which
>> was cleared up with a few rounds of fsck.  The two btrfs are
>> completely unhappy though and I do not know how to proceed, since
>> btrfs problems are new to me.  Any suggestions are welcome.
>>

btrfsck is not ready for data recovery, but only for error checking.
But btrfs-tools do have some features that may help us, e.g zero-log.

More recovery details refer to the thread from Hugo:
http://www.spinics.net/lists/linux-btrfs/msg14890.html


thanks,
liubo

>> Here is the basic picture of what is going on.
>>
>> # cat /etc/fstab
>> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
>> #/dev/mapper/tr5ut-media        /mnt/media      btrfs
>> defaults,compress=lzo,space_cache 0       2
>>
>> /dev/mapper/tr5ut-media /mnt/media      ext4 defaults 0 2
>>
>> /dev/mapper/tr5ut-vicep--library        /vicepa auto
>> defaults,compress=lzo,space_cache  0       2
>>
>> /dev/mapper/tr5ut-vicep--clones         /vicepb auto
>> defaults,compress=lzo,space_cache  0       2
>>
>>
>> You can see that btrfs device scan does not find anything, while
>> btrfs-show finds one of the volumes and not the other.  Fscking the
>> found volume halts due to checksum and assertion errors, while fscking
>> the other volume fails completely, I guess due to a missing
>> 'superblock' type structure?
>>
>>
>> seraph:~# btrfs device scan
>> Scanning for Btrfs filesystems
>> failed to read /dev/sr0
>>
>>
>> seraph:~# btrfs-show
>> **
>> ** WARNING: this program is considered deprecated
>> ** Please consider to switch to the btrfs utility
>> **
>> failed to read /dev/sr0: No medium found
>> Label: vicep-library  uuid: 89b14d35-b31a-4fbe-a2d9-cb83cbcd3851
>>         Total devices 1 FS bytes used 254.35GB
>>         devid    1 size 1.00TB used 299.04GB path /dev/dm-32
>>
>> Btrfs Btrfs v0.19
>>
>>
>> seraph:~# btrfsck /dev/mapper/tr5ut-vicep--library
>> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
>> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
>> checksum verify failed on 317874630656 wanted 491D9C1A found FFFFFFA6
>> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
>> Csum didn't match
>> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
>> `!(path->slots[0] == 0)' failed.
>> Aborted
>>
>>
>> seraph:~# btrfsck /dev/mapper/tr5ut-vicep--clones
>> No valid Btrfs found on /dev/mapper/tr5ut-vicep--clones
>>
>>
>> seraph:~# dpkg -l btrfs-tools
>> Desired=Unknown/Install/Remove/Purge/Hold
>> |
>> Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
>> |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
>> ||/ Name                                          Version
>> Description
>> +++-=============================================-=============================================-==========================================================================================================
>> ii  btrfs-tools                                   0.19+20111105-2
>> Checksumming Copy on Write Filesystem utilities
>>
>>
>> -- 
>> Ryan C. Underwood, <nemesis@icequake.net>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

