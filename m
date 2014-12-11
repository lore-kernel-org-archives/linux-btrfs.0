Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48092 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932937AbaLKCFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 21:05:23 -0500
Message-ID: <5488FBE0.7060309@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 10:05:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com> <547C0834.7090706@cn.fujitsu.com> <547CAF2E.7070109@pobox.com> <547D1339.10404@cn.fujitsu.com> <547F61F6.7020707@pobox.com> <548005B7.40503@cn.fujitsu.com> <20141210215729.GC22023@hungrycats.org>
In-Reply-To: <20141210215729.GC22023@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月11日 05:57
> On Thu, Dec 04, 2014 at 02:56:55PM +0800, Qu Wenruo wrote:
>> The main memory usage in btrfsck is extent record, which
>> we can't free them until we read them all in and checked, so even we
>> mmap/unmap, it can only help with
>> the extent_buffer(which is already freed if not used according to refs).
> I'm thinking aloud here, but is it *really* necessary to read everything
> into memory?
Totally agreed to only read what we need.
But some backref and counts on refs can only be determined after a full 
scan, especially for leaf/node corruption
case.
>    Maybe a multiple-pass algorithm might be possible, e.g. one
> to find free space by eliminating any areas that are occupied by extents,
> then other passes to rebuild the metadata in the free space.  Or, one
> pass to verify the connectivity of references and collect dangling refs,
> then a second pass which fixes only the dangling refs.
I have similar idea, but not multi-pass method, instead, using per 
sector scan + tree search for other data.
E.g in extent tree check, each time only record all extents in a block 
group, and check them.
After check, remove the good extents/block groups and then move to next 
block group.
For fs tree, any key with same objectid(ino) as a group, and only read  
the group in one time and remove
the already known healthy record. (info not fully gathered or bad record 
will still stay in memory)

But I don't consider this method can really save much memory though...
>
> Usually sequential reads are significantly faster than swapping--even
> if swapping on solid-state media.  It could be that reading 260GB of
> metadata sequentially two or three times is still faster than thrashing
> through random lookups in 20GB of swap on a 4GB machine.
>
Definitely, but if we want to reduce memory usage, it is almost 
unavoidable to do more disk IO, especially random
disk IO, so it will become a tradeoff, which may cause the already slow 
fsck more slow....

Thanks,
Qu
