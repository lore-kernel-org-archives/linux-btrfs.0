From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Mon, 13 Feb 2012 13:57:57 +0800
Message-ID: <4F38A665.4030506@cn.fujitsu.com>
References: <20270.59513.240729.662692@localhost.localdomain>	<4F3386D8.6010108@cn.fujitsu.com>	<20275.60248.386622.516828@localhost.localdomain>	<4F34795B.2020004@cn.fujitsu.com> <20279.61547.888033.662423@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Lutz Euler <lutz.euler@freenet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20279.61547.888033.662423@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2012 01:01 AM, Lutz Euler wrote:
> Hi,
> 
> tl;dr: btrfs_trim_fs, IMHO, needs more thorough surgery.
> 
> Thanks for providing the new patch. I think it will work in the case
> that "fstrim" is called without specifying a range to trim (that is,
> defaulting to the whole filesystem), but I didn't test that yet, sorry.
> 
> Instead, I have been thinking about what happens if a range smaller than
> the whole filesystem is specified. After all, the observation that in my
> filesystem the smallest "objectid" is already larger than the filesystem
> size still holds even in that case, and wanting to trim only part of the
> filesystem seems to be a valid wish, too.
> 
> So I dug into the code myself and came to the conclusion that the
> way "btrfs_trim_fs" interprets the range passed from the ioctl is
> fundamentally broken.
> 
> Instead of papering over that I'd very much prefer a more thorough fix
> here, which in addition might make it unnecessary to treat the "trim the
> complete filesystem" case specially. Please read on for the details:
> 
> The current implementation of "btrfs_trim_fs" simply compares the
> objectid's it finds in the chunk tree against the range passed from
> the ioctl, seemingly assuming that both kinds of numbers span the same
> range. But this is clearly not true: Even without adding and deleting
> of devices, in a simple mirror the objectids will span only about half
> the size of the filesystem. With suitable add/delete of devices I can
> construct a filesystem with a smallest objectid of 0 and a largest
> objectid much larger than the size of the filesystem (so, obviously,
> with large holes in the set of used objectid's), or, as in my filesystem
> mentioned above, with a smallest objectid larger than the size of the
> filesystem.
> 
[...]
> So, to make bulk discard of ranges useful, it seems the incoming range
> should be interpreted relative to the size of the filesystem and not to
> the allocated chunks. As AFAIK the size of the filesystem is just the
> sum of the sizes of its devices it might be possible to map the range
> onto a virtual concatenation of the devices, these perhaps ordered by
> devid, and then to find the free space by searching for the resulting
> devid(s) and device-relative offsets in the device tree?
> 

Actually I have no idea how to deal with this properly :(

Because btrfs supports multi-devices so that we have to set the filesystem
logical range to [0, (u64)-1] to get things to work well, while other
filesystems's logical range is [0, device's total_bytes].

What's more, in btrfs, devices can be mirrored to RAID, and the free space is
also ordered by logical addr [0, (u64)-1], so IMO it is impossible to interpreted the range.

I'd better pick up "treat the "trim the complete filesystem" case specially",
and drop the following commit:

commit f4c697e6406da5dd445eda8d923c53e1138793dd
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Mon Sep 5 16:34:54 2011 +0200

    btrfs: return EINVAL if start > total_bytes in fitrim ioctl
    
    We should retirn EINVAL if the start is beyond the end of the file
    system in the btrfs_ioctl_fitrim(). Fix that by adding the appropriate
    check for it.
    
    Also in the btrfs_trim_fs() it is possible that len+start might overflow
    if big values are passed. Fix it by decrementing the len so that start+len
    is equal to the file system size in the worst case.
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>

thanks,
liubo

> I understand that currently unallocated space is never trimmed?
> To nevertheless do that might be useful after a balance or at file
> system creation time? If there is a way to find the unallocated space
> for a device, this could be improved at the same time, too.
> 
> Kind regards,
> 
> Lutz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

