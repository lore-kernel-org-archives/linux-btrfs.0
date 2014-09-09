Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:51384 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaIIUZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 16:25:38 -0400
Message-ID: <540F63BC.6080601@inwind.it>
Date: Tue, 09 Sep 2014 22:31:56 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz,
        Chris Mason <clm@fb.com>
CC: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <540B6900.7000307@fb.com> <20140908090946.GI5636@twin.jikos.cz> <540D8D45.6000608@oracle.com> <540DE427.4040008@inwind.it> <540E7359.4050000@oracle.com>
In-Reply-To: <540E7359.4050000@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2014 05:26 AM, Anand Jain wrote:

Anand,
first thanks to discuss this with me; below my comments

>> You are talking about a ioctl: why not use (extending them when needed)
>> the sysfs information ?
> 
>  yeah, I understand I am the only person talking about ioctl,
>  and all others recommend sysfs. I understand I am wrong, but
>  just by mass. and I still have no idea why not ioctl ?

Because it is an interface difficult to extend.

>  Problem with sysfs:
>   - Note that sysfs supports only one parameter value with max length
>   u64, to rebuilt entire kernel's fs_uuid list in the user space
>   that would be quite a lot of sysfs files. should that be fine ?
>   Further we would need another traverser tool (python ?) to read
>   all these sysfs files. ? so that we could create fs_uuid list
>   in the user-space.
To me it seems that other fs interface scale well even if the number 
of items is big (think /proc)
 
>   - we would need all info about the kernel fs_uuid, even when the
>  device is not mounted.
Could you elaborate ? 
We have two kind of objects: filesystems and devices. A filesystem is
created when its first device is registered. When the filesystem
is mounted, further information are available.

Our hypothetical sysfs interface should export information about
filesystem and/or devices until they exist. If a filesystem is
mounted more information are exported. When it is umounted
less are exported.

This would not be different if we use a ioctl() interface.

> 
>   - thinking of nested seed with sysfs is more complicated, as we would
>  have same btrfs_device at multiple fs_devices. still we must represent
>  them in the sysfs.
I am not used to use seed device; so I can't comment.
 
>   - as of now fs_uuid can grow infinite with just "a" device.
>    ref: [PATCH 1/2] btrfs: device list could grow infinite
This is a btrfs problem. Doesn't make sense to store these information
if there aren't any device. When the last device disappear (is replaced),
the filesystem object should disappear too.
If a sysfs approach point out this problem... to me it seems good ! :-)

>    can't imagine anybody traversing through /sysfs to understand
>    what btrfs-kernel think of devices. user would prefer a cli
>    to know that instead.
sysfs is an interface, that doesn't means that is THE user interface.
Of course a CLI or a GUI will need.

> 
>   - sysfs layout has to be dynamic based on fs_uuids list changes,
>   devices added, removed, mounted replaced etc.. isn't it making
>   more unstable ?

$ find /sys | wc -l
27362
On my PC sysfs has more already than 20 thousands entries, and it is 
a quite simple machine. But this doesn't cause instability.
May be more difficult, but I don't think that sysfs is not capable 
to sustain that.


Already linux export a lot of sysfs files for each device. I.e.

$ find /sys/block/sda/ | wc -l
	190

these are hundreds entries for each disks. So I don't think that btrfs sysfs
interface could cause more problem even if a filesystem has
a lot of disks.

> 
> 
> appreciate your comments
The major problem of an ioctl() interface is that is very difficult 
to extend. Typically when we need to extend it , the current is 
marked as old/deprecated and a new one is generated.
However an ioctl() is an ABI so even the old interface have to be 
maintained.

One point about I have to agree with you is that a sysfs interface
is not good, is when:
- we need to export huge quantity of data
- we have an high rate of data

But these to me don't seem to apply to a sysfs btrfs interface.

> 
> Anand
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
