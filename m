Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3466 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932230AbbKYCAv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 21:00:51 -0500
Subject: Re: shall distros run btrfsck on boot?(Off topic, btrfs per-inode
 tree idea)
To: Hugo Mills <hugo@carfax.org.uk>, Eric Sandeen <sandeen@redhat.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net> <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net> <5654CAE0.5040907@gmail.com>
 <5654E427.6060708@redhat.com> <20151124223349.GV24333@carfax.org.uk>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5655161F.5070309@cn.fujitsu.com>
Date: Wed, 25 Nov 2015 09:59:59 +0800
MIME-Version: 1.0
In-Reply-To: <20151124223349.GV24333@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hugo Mills wrote on 2015/11/24 22:33 +0000:
> On Tue, Nov 24, 2015 at 04:26:47PM -0600, Eric Sandeen wrote:
>> On 11/24/15 2:38 PM, Austin S Hemmelgarn wrote:
>>
>>> if the system was
>>> shut down cleanly, you're fine barring software bugs, but if it
>>> crashed, you should be running a check on the FS.
>>
>> Um, no...
>>
>> The *entire point* of having a journaling filesystem is that after a
>> crash or power loss, a journal replay on next mount will bring the
>> metadata into a consistent state.
>
>     Not an actual argument within the discussion, but an interesting
> observation on a fine distinction:
>
>     It's interesting to note that there's a difference here between
> journalling and CoW filesystems. A journalling FS needs a journal
> replay to become consistent. A CoW FS is _always_ consistent, by
> design. Now, btrfs has a log that should be replayed after an unclean
> shutdown, but that's all about the data that got written within the
> current transaction that wasn't committed,

In fact, log tree of btrfs is only used to speedup fsync. And there is a 
"notreelog" mount option to disable such log tree, if one uses it, fsync 
performance will just drop to the level of sync.

So it's just an optimization, although it's already quite away from the 
original topic, I think the best method for btrfs to improve fsync 
performance is to introduce something like ext*:

Per-file extent map tree.


The reason btrfs is slow on fsync is, file extent and inode info are all 
stored in the same tree(fs tree or subvolume tree).

To only fsync a inode, it's impossible only fsync all its file extents, 
but to sync the whole tree, which may just as slow as a full sync.

That's why log tree is introduced, only writeback file extents of an 
inode and record its metadata changes into the log tree.
And performance test result also supports this.


But other filesystem, at least ext* uses a better solution, each inode 
(no matter regular file or dir) has its own tree to record its file 
extents or dir entries.
Making fsync quite easy and straightforward.

If btrfs follows the same design, at least the random RW performance may 
have a boost and simplify the fsync codes.

Thanks,
Qu


> rather than about FS
> metadata consistency. This means that a read-only mount of btrfs can
> _actually_ be read-only, not modifying any of the data on the disk,
> whereas a read-only mount of a journalling FS _must_ modify the disk
> data after an unclean shitdown, in order to be useful (because the FS
> isn't consistent without the journal replay).
>
>     Hugo.
>


