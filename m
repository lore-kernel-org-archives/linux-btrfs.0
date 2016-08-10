Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50154 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473AbcHJSDV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:03:21 -0400
Subject: Re: [PATCH 2/2] writeback: allow for dirty metadata accounting
To: Jan Kara <jack@suse.cz>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
 <1470769707-26079-3-git-send-email-jbacik@fb.com>
 <20160810100957.GC12157@quack2.suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <8d745233-4cfc-f0c2-9ba4-fee74eb1940e@fb.com>
Date: Wed, 10 Aug 2016 10:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <20160810100957.GC12157@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2016 06:09 AM, Jan Kara wrote:
> On Tue 09-08-16 15:08:27, Josef Bacik wrote:
>> Provide a mechanism for file systems to indicate how much dirty metadata they
>> are holding.  This introduces a few things
>>
>> 1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
>> 2) WB stat for dirty metadata.  This way we know if we need to try and call into
>> the file system to write out metadata.  This could potentially be used in the
>> future to make balancing of dirty pages smarter.
>> 3) A super callback to handle writing back dirty metadata.
>>
>> A future patch will take advantage of this work in btrfs.  Thanks,
>
> Hum, I once had a patch to allow filesystems to hook more into writeback
> where a filesystem was just asked to do writeback and it could decide what
> to do with it (it could use generic helpers to essentially replicate what
> current writeback code does) but it could also choose some smarter strategy
> of picking inodes to write. This scheme could easily accommodate your
> metadata writeback as well and there are also other uses for it. But that
> patch got broken by Tejun's cgroup aware writeback so one would have to
> start from scratch.
>
> We certainly have to think how to integrate this with cgroup aware
> writeback. I guess your ->writeback_metadata() just does not bother and would
> write anything in the root cgroup, right? After all you don't even pass the
> information for which memcg the metadata writeback should be performed down
> to the fs callback (that is encoded in the bdi_writeback structure). And
> for now I think we could get away with that although it would need to be
> handled properly in future I think.
>

I thought about this some but I'm not sure how to work it out so it's sane. 
Currently no other file system's metadata is covered by the writeback cgroup. 
Btrfs is simply by accident, we have an inode where all of our metadata is 
attached.  This doesn't make a whole lot of sense as the inode is tied to 
whichever task dirited it last, so you are going to end up with weird writeback 
behavior on btrfs metadata if you are using writeback cgroups.  I think removing 
this capability for now is actually better overall so we can come up with a 
different solution.

> If we created a generic filesystem writeback callback as I suggest, proper
> integration with memcg writeback in unavoidable. But I have to think how to
> do that best.

So the reason I'm doing this is because the last time I tried to kill our btree 
inode I got bogged down trying to reproduce our own special writeback logic for 
metadata.  I basically constantly oom'ed the box because we'd fill up memory 
with dirty metadata, and then I started just wholesale copying 
mm/page-writeback.c and mm/fs-writeback.c to try and stop the madness and gave 
up because that was just as crazy.

I think that having writeback a little more modularized so file systems can be 
smarter about picking inodes if they want is a good long term goal, but for now 
I'd like to get this work in so I can go about killing our fs wide inode.  Thanks,

Josef
