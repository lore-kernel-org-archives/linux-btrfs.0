From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Fri, 06 Jan 2012 14:04:12 +0200
Message-ID: <4F06E33C.8090104@gmail.com>
References: <cover.1301542804.git.larry@elder-gods.org> <20110401133405.GA17956@infradead.org> <1301665083-sup-3969@think> <201112222324.16871.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112222324.16871.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 22/12/2011 2:24 =CE=BC=CE=BC, Chris Samuel wrote:
> Christoph,
>
> On Sat, 2 Apr 2011 12:40:11 AM Chris Mason wrote:
>
>> Excerpts from Christoph Hellwig's message of 2011-04-01 09:34:05
> -0400:
>>
>>> I don't think it's a good idea to introduce any user visible
>>> operations over subvolume boundaries.  Currently we don't have
>>> any operations over mount boundaries, which is pretty
>>> fumdamental to the unix filesystem semantics.  If you want to
>>> change this please come up with a clear description of the
>>> semantics and post it to linux-fsdevel for discussion.  That of
>>> course requires a clear description of the btrfs subvolumes,
>>> which is still completely missing.
>>
>> The subvolume is just a directory tree that can be snapshotted, and
>> has it's own private inode number space.
>>
>> reflink across subvolumes is no different from copying a file from
>> one subvolume to another at the VFS level.  The src and
>> destination are different files and different inodes, they just
>> happen to share data extents.
>
> Were Chris Mason's points above enough to sway your opposition to thi=
s
> functionality/patch?
>
> There is demand for the ability to move data between subvolumes
> without needing to copy the extents themselves, it's cropped up again
> on the list in recent days.
>
> It seems a little hard (and counterintuitive) to enforce a wasteful
> use of resources to copy data between different parts of the same
> filesystem which happen to be a on a different subvolume when it's
> permitted&  functional to the same filesystem on the same subvolume.
>
> I don't dispute the comment about documentation on subvolumes though,
> there is a short discussion of them on the btrfs wiki in the sysadmin=
s
> guide, but not really a lot of detail. :-)
>
> All the best,
> Chris

Me too wants cp --reflink across subvolumes. Please make this feature=20
available to us, as its a "poor man's dedupe" and would give big space=20
savings for many use cases.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
