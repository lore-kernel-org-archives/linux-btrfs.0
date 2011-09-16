From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] Btrfs: don't make a file partly checksummed through
 file clone
Date: Fri, 16 Sep 2011 11:01:08 +0800
Message-ID: <4E72BBF4.7010705@cn.fujitsu.com>
References: <4E703AC1.5060205@cn.fujitsu.com> <20110915111638.GD22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Sage Weil <sage@newdream.net>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110915111638.GD22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Wed, Sep 14, 2011 at 01:25:21PM +0800, Li Zefan wrote:
>> It's because part of the file is checksummed and the other part is not,
>> and then btrfs will complain checksum is not found when we read the file.
>>
>> Disallow file clone if src and dst file have different checksum flag,
>> so we ensure a file is completely checksummed or unchecksummed.
> 
> Your fix prevents the bug, but I don't think it's good to let file clone
> fail without any other message. ret is set to -EINVAL at the time of
> 'goto out_fput', which is fine, but the user has no clue what happened
> or how to fix it.

While I agree with you on this comment..

> 
> The nodatasum status is recorded in inode flags and remains like that
> regardless of the 'mount -o nodatasum', persistent and de facto
> unchangable (unless the file is created again with the opposite nodatasum
> mount). Even more, the user has no way to find out nodatasum flag of
> any inode/file (the corresponding FS_NODATASUM_FL is not there).
> 
> My suggestion how to fix this:
> 1. add FS_NODATASUM_FL file flag and code to set/get via setflags ioctl

This means we can have a file partly checksummed, which is what we want
to avoid in this patch.

> 2. [this patch to skip cloning in case of nodatasum flag mismatch]
> 3. ... add a printk why it failed

I don't think this is a good idea.

> 
> The user then has at least option to drop/add the nodatasum flag for one of
> the. Unfortunatelly this makes file cloning less straightforward.
> 

I don't know if Chris has plan on finer-grained checksum (not per file
but per extent), if yes, we can eliminate this constraint in file cloning
in the future.
