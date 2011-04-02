From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Sat, 2 Apr 2011 08:59:05 +0700
Message-ID: <AANLkTikizY1iTKVso9n4b2yN8Xn_VS5qWvt40HFuE31t@mail.gmail.com>
References: <cover.1301542804.git.larry@elder-gods.org>
	<20110331063636.GA5297@infradead.org>
	<1301572893-sup-3464@think>
	<20110401133405.GA17956@infradead.org>
	<1301665083-sup-3969@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301665083-sup-3969@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2011 at 8:40 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Christoph Hellwig's message of 2011-04-01 09:34:05 -040=
0:
>> I don't think it's a good idea to introduce any user visible operati=
ons
>> over subvolume boundaries. =A0Currently we don't have any operations=
 over
>> mount boundaries, which is pretty fumdamental to the unix filesystem
>> semantics. =A0If you want to change this please come up with a clear
>> description of the semantics and post it to linux-fsdevel for
>> discussion. =A0That of course requires a clear description of the
>> btrfs subvolumes, which is still completely missing.
>>
>
> The subvolume is just a directory tree that can be snapshotted, and h=
as
> it's own private inode number space.
>
> reflink across subvolumes is no different from copying a file from on=
e
> subvolume to another at the VFS level. =A0The src and destination are
> different files and different inodes, they just happen to share data
> extents.

=2E.. and currently copying file from one subvolume to another requires
copying the data as well. It'd be great if you could only copy the
metadata.

A good possible use that comes to mind is to quickly merge several
subvolumes into a new one.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
