Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39715 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaA2Qmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 11:42:31 -0500
Received: by mail-qa0-f51.google.com with SMTP id f11so2796611qae.10
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 08:42:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E3D66A.7010705@fb.com>
References: <CAEx9m47jxKWro0x6U7h9Ma2=kGTNm7cGFM+VZkFyHvY7qt87dg@mail.gmail.com>
 <52E3D66A.7010705@fb.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Wed, 29 Jan 2014 17:42:11 +0100
Message-ID: <CAEx9m46oaMO_Co2rAt4DjHFvGoxYPgWFgaDQZH9BF-69TbmxVA@mail.gmail.com>
Subject: Re: questions regarding fsync in btrfs
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 January 2014 16:21, Josef Bacik <jbacik@fb.com> wrote:
>
> On 01/24/2014 07:09 PM, Aastha Mehta wrote:
>>
>> Hello,
>>
>> I would like to clarify a bit on how the fsync works in btrfs. The log
>> tree journals only the metadata of the files that have been modified
>> prior to the fsync, correct? It does not log the data extents of
>> files, which are directly sync'ed to the disk. Also, if I understand
>> correctly, fsync and fdatasync are the same thing in btrfs currently.
>> Is it more like fsync or fdatasync?
>
>
> More like fsync.  Because we cow we always are updating metadata so there is
> no "fdatasync", we can't get away with just flushing the data.
>
>
>> What exactly happens once a file inode is in the tree log? Does it
>> mean it is guaranteed to be persisted on disk, or is it already on
>> disk? I see two flags in btrfs_sync_file -
>> BTRFS_INODE_HAS_ASYNC_EXTENT and BTRFS_INODE_NEEDS_FULL_SYNC. I do not
>> fully understand them. After full sync, what does log_dentry_safe and
>> sync_log do?
>
>
> It is guaranteed to be on disk.  We copy all of the inode metadata to the
> log, sync the log and the data and the super block that points to hte tree
> log.  HAS_ASYNC_EXTENT is for compression where we will return to writepages
> without actually having marked the page as writeback, so we need to go back
> and re-lock the pages to make sure it has passed through the async
> compression threads and the pages have been properly marked writeback so we
> can wait on them properly.  NEEDS_FULL_SYNC means we can't do our fancy
> tricks of only updating some of the metadata, we have to go and copy all of
> the inode metadata (the inode, its references, its xattrs) and all of its
> extents.  log_dentry_safe copies all the info into the tree log and sync_log
> syncs the tree log to disk and writes out a super that points to the tree
> log.
>
>> Finally, Wikipedia says that "the items in the log tree are replayed
>> and deleted at the next full tree commit or (if there was a system
>> crash) at the next remount". Even if there is no crash, why is there a
>> need to replay the log?
>>
> There isn't, once we commit a transaction we commit a super that doesn't
> point to the tree log and we free up the blocks we used for the tree log.
> The tree log only exists for one transaction, if we crash before a
> transaction commits we will see that there is a tree log on the next mount
> and replay it.  If we commit the transaction we simply free the tree log and
> carry on.  Thanks,
>
> Josef


Thank you for your response. I ran few small experiments and I see
that fsync on an average leads to writing of about 30-40KB of
metadata, irrespective of the amount of data changes. I wonder why is
it so much? Besides the superblocks and a couple of blocks in the tree
log, what else may be updated? Also, why does it seem to be
independent of the amount of writes?

Thanks,
Aastha.
