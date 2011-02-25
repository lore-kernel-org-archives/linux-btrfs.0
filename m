From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Btrfs: add ioctl to set compress or cow per file/dir
Date: Fri, 25 Feb 2011 11:21:57 +0800
Message-ID: <4D672055.3010601@cn.fujitsu.com>
References: <4D6627A7.7050001@cn.fujitsu.com> <1298558707-sup-8570@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1298558707-sup-8570@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2011 10:54 PM, Chris Mason wrote:
> Excerpts from liubo's message of 2011-02-24 04:40:55 -0500:
>> Data compression and data cow are controlled across the entire FS by mount
>> options right now.  ioctls are needed to set this on a per file or per
>> directory basis.  This has been proposed previously, but VFS developers
>> wanted us to use generic ioctls rather than btrfs-specific ones.
>>
>> We need to fit these into the existing per-inode flags, and to use the generic
>> FS_IOCTL_SETFLAGS ioctl.  For data compression, there are the existing
>> compression flags of vfs inode, while for datacow, there is no flag to
>> indicate it, which we need to add.
>> So, what we will do is to add datacow flag in vfs inode flags and then to
>> set or to unset btrfs compress/cow flag on the corresponding btrfs inode's flag
>> per file or per directory.  Moreover, we also add a compression type ioctl to
>> make this feature more flexible.
>>
>> I really expect some advices and comments on the followings:
>>
>> - In this patch, I made a special ioctl to set compress type, and to record
>>   the compress_type per inode on disk, I've consumed some reserved space of
>>   btrfs_inode_item, so is this acceptable?
> 
> I don't expect people to mix compression types on the disk.  There
> really should just be one true compression method (probably LZO once it
> has been established for a while).  So, I'd prefer that we store this in
> the super, and just have flags in the inode for enabling or disabling
> compression.

It sounds nice and will make code neatly. :)
So, all files & directories will share the same compress type stored in the super.

> 
>>   Meanwhile, I got another idea from my collegue, could we just owe the whole
>>   compress type thing to new proper mount options, ie,
>>   mount xxx xxx -o compress=a,inode_compress=b?
>>   Seems that this makes mount more flexible.
> 
> It does make it more flexible, but I think sometimes extra flexibility
> leads to more QA time and isn't often used by the actual users ;)

ok.

> 
>> - When we are inclined to set inode's compression type, should it be a "force"
>>   mode?
>>   This is much like the difference between mount as compress and mount as
>>   compress-force.
> 
> I'd store this as flags in the super too.

ok.

> 
>> - For directory basis, after compress/cow ioctl on it, any files that are
>>   created or renamed in it, or moved into it, will inherit the directory's
>>   compress and datacow attribute.
>>   Here comes to some disputes, is it right that renamed and moved files
>>   also inherit the father directory's compress & datacow attribute?
>>   And if what we are dealing with is directory, should this behaviour be
>>   recursive or not?
>>   I'm inclined to leave these recursive things to btrfs-progs if this is
>>   necessary.
> 
> I'd say that if we rename a file into a directory it does inherit, but
> not make it recursive.
>

ok, got it.
I will send a new version based on this thread.

Thanks a lot for reviewing!

thanks,
liubo
 
> -chris
> 

