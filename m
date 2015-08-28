Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34734 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbH1NXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 09:23:17 -0400
Received: by iofe124 with SMTP id e124so27008105iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 06:23:16 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <55DE0E2D.6000001@fb.com>
References: <1440522583-32120-1-git-send-email-jbacik@fb.com>
	<20150826020609.GB5614@localhost.localdomain>
	<55DE0E2D.6000001@fb.com>
Date: Fri, 28 Aug 2015 14:23:16 +0100
Message-ID: <CAL3q7H54DhLzBTLF9corKDu8TZxozDERSDsyYO+ecSR1GcJ60w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: deal with error on secondary log properly
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 8:06 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 08/25/2015 10:06 PM, Liu Bo wrote:
>>
>> On Tue, Aug 25, 2015 at 01:09:43PM -0400, Josef Bacik wrote:
>>>
>>> If we have an fsync at the same time in two seperate subvolumes we could
>>> end up
>>> with the tree log pointing at invalid blocks.  We need to notice if our
>>> writeout
>>
>>
>> Mind to share more details of the problem?
>>
>
> It's the problem Filipe was trying to solve.  Say we fsync() on two
> different subvols, one of them will race in and be the one who commits the
> log root tree.  So process A waits on process B to add its log to the log
> root tree and write out its log.  If we get an IO error while writing out
> the log the log root tree will be pointing to invalid crap, and we also
> won't return an error back to userspace.  We need to notice if there was an
> error, turn on the transaction commit stuff since we've already updated the
> the log root tree with our subvol log so we don't get garbage on the disk,
> and we need to return an error to process B. Thanks,

Josef,

So the problem was that without forcing A to trigger a transaction
commit if B gets an error when writing one or more log tree
nodes/leafs, A could write a superblock pointing to a log root tree
for which not all nodes/leafs were persisted. Then B would fall back
to a transaction commit and everything would be ok - i.e. we would
only have a "small" time window where a superblock points to an
invalid log root tree.

So the fix here shouldn't be only to force A do a transaction commit
(call btrfs_set_log_full_commit())? Why do we need to make B return an
error to userspace and not fallback to a transaction commit too (as it
was before this change)? After all this is the kind of failure for
which we can fallback to a transaction commit without losing any inode
metadata (links, owner, group, xattrs, etc) nor file data.

The change looks good, just puzzled why we need to return the error to
userspace.

thanks

>
> Josef
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
