Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3AYGJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 01:09:19 -0500
Message-ID: <510221B5.4050906@cn.fujitsu.com>
Date: Fri, 25 Jan 2013 14:09:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: bo.li.liu@oracle.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
References: <50FE6E9C.2040803@cn.fujitsu.com> <20130122142414.GA15978@liubo> <50FF50EF.9010907@cn.fujitsu.com> <20130123035647.GB17162@liubo.jp.oracle.com> <50FF6AC1.6030602@cn.fujitsu.com> <20130123060618.GC17162@liubo.jp.oracle.com> <50FF8437.3010703@cn.fujitsu.com> <20130123081751.GF17162@liubo.jp.oracle.com> <50FFA633.1070101@cn.fujitsu.com> <20130123095132.GA31998@liubo.jp.oracle.com> <50FFB978.3060802@cn.fujitsu.com> <CAOcd+r3vjE6SksVaVRPp2b9c0wUyNtoC3xQNy5OZw-Bx7Pt5ww@mail.gmail.com> <5100991B.6080601@cn.fujitsu.com> <CAOcd+r1d9j9zeqJe74xe3dJynFmfsv5MhFkvY7bhb+iUOMwETA@mail.gmail.com>
In-Reply-To: <CAOcd+r1d9j9zeqJe74xe3dJynFmfsv5MhFkvY7bhb+iUOMwETA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 24 Jan 2013 18:20:06 +0200, Alex Lyakas wrote:
>>> - Is there something that user-space can do to avoid flushing the
>>> delalloc during snap-commit? For example, if the user-space stops the
>>> IO and does a normal commit, this will not call
>>> btrfs_start_delalloc_inodes(), but this should ensure that *some* data
>>> is safe on disk. Then the user-space triggers snap creation (which is
>>> another commit), and then resume the IO? Because without the ongoing
>>> IO, snap creation is very fast.
>>
>> We can sync the fs before creating snapshot, in this way, we needn't flush
>> the delalloc while committing the transaction. But I don't think it is good
>> way. Because for the users, the page cache is transparent.
> 
> I was always under impression that in Linux you must be aware of the
> page cache. For exampe, if a C program writes to a file, it is also
> responsible to fsync() the file (and check return value), to make sure
> that data has been persisted. However, for snap creation, it is
> perhaps better to do this automatically for the user.
> 
>>
>> I have a idea to improve this problem:
> I think the below idea is very good:
> 
>> - introduce per-subvolume delalloc inode list
> Perfect.
> 
>> - flush the delalloc inode list of the source subvolume in create_snapshot(),
>>   not flush it in commit_transaction(). In this way, we just flush once.
> Perfect.
> 
>> - don't do the delalloc flush in commit_transaction() if there are pending snapshots
> Perfect.
> 
>> - If FLUSHONCOMMIT is set, just call btrfs_start_delalloc_inodes() before while loop,
>>   and call btrfs_wait_ordered_extents() after the while loop.
> In case FLUSHONCOMMIT is not set, but there are pending snapshots, is
> it also needed to call btrfs_wait_ordered_extents(), since we have
> started the delalloc IO in create_snapshot()?

Yes, because FLUSHONCOMMIT will flush all delalloc inodes, including the source subvolumes
and the others which are not being snapshoted.

> I have run additional tests with your patchset. It definitely improves
> the two bugs. However, I have a question: if the IO to the filesystem
> continues during extent_write_cache_pages() loop, can it add more
> dirty pages to the flush this function is doing? Basically, I am
> looking for some way to separate "old" delallocs that must be flushed
> vs "new" delallocs that were added after we started committing.

We can not add dirty pages into the extents which are under the disk IO, but
we can add dirty pages into the other extents which belong to the same file, but
is not under the disk IO.
(Some developers have discuss the issue(unstable page problem) that if we can
dirty the extent that is under the disk IO or not in the past. Their approach is
allocate a new page to store the new data. But some developers disagree this idea
because the disk become more and more fast, it is unnecessary, and if the free
memory is not enough, we still need wait the IO.)

I think flushing the delalloc inodes at the beginning of btrfs_commit_transaction()
is a simple way to separate "old" delallocs and "new" delallocs.

> For example, with your current patches, the extent_write_cache_pages()
> is called at least twice per inode (I know that your new idea will fix
> it). In my case, the first call submitted 22671 pages (inode is 10Gb)
> and the second call submitted 33705 pages. Between those two calls
> there were 6531 pages that were submitted twice. I noticed that if I
> stop the IO and then immediately trigger snap creation, much less
> pages are submitted.
> 
> I played with the freeze_super() API, which also syncs the filesystem,
> so delalloc flush is not needed in this case, like you mentioned.
> However, the snap creation flow also calls mnt_want_write_file(),
> which blocks if the FS is freezed.
> Does it make sense to have some kind of a light-freeze functionality,
> which would only block the new writers (and possibly wait for
> in-flight writer threads to complete), but will not do the
> sync_filesystem part, but only the SB_FREEZE_WRITE part?

I have implemented a light-freeze functionality for the R/W->R/O change
of the subvolume(The patch will send out later). But I don't think it is
necessary to introduce it to the snapshot creation.

Thanks
Miao
