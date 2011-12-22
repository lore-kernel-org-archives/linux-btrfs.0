From: Malwina Bartoszynska <m.bartoszynska@rootbox.com>
Subject: Re: "btrfs: open_ctree failed" error
Date: Thu, 22 Dec 2011 10:43:57 +0100
Message-ID: <4EF2FBDD.3090709@rootbox.com>
References: <loom.20111221T141346-863@post.gmane.org> <20111221190605.GY19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111221190605.GY19266@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 2011-12-21 20:06, Chris Mason pisze:
> On Wed, Dec 21, 2011 at 01:54:06PM +0000, Malwina Bartoszynska wrote:
>> Hello,
>> after unmounting btrfs partition, I can't mount it again.
>>
>> root@xxx:~# btrfs device scan
>> Scanning for Btrfs filesystems
>> root@xxx:~# mount /dev/sdb /data/osd.0/
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so
>>
>> root@xxxx:~# dmesg|tail
>> [57192.607912] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid
>> 2 transid14429 /dev/sda
>> [57204.796573] end_request: I/O error, dev fd0, sector 0
>> [57231.660913] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid 1
>>   transid 14429 /dev/sdb
>> [57231.680387] parent transid verify failed on 424308420608 wanted 6970
>>   found 8959
>> [57231.680546] parent transid verify failed on 424308420608 wanted 6970
>> found 8959
>> [57231.680705] parent transid verify failed on 424308420608 wanted 6970
>> found 8959
>> [57231.680861] parent transid verify failed on 424308420608 wanted 6970
>> found 8959
>> [57231.680869] parent transid verify failed on 424308420608 wanted 6970
>> found 8959
>> [57231.680875] Failed to read block groups: -5
>> [57231.704165] btrfs: open_ctree failed
> Can you tell us more about this filesystem?  Was there an unclean
> shutdown or did you just unmount, mount again?
>
> The confusing thing is that all of your disks seem to have the same copy
> of the block, so it looks like things were written properly.
>
> -chris
There was no shutdown before this, filesystem was just unmounted(which 
looked as properly done - no errors). Then tried to mount it again.
Is there way of fixing it?
--
Malwina Bartoszynska
