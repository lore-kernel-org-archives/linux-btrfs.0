Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbcHJSDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:03:44 -0400
Date: Wed, 10 Aug 2016 12:09:57 +0200
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, jack@suse.com, viro@zeniv.linux.org.uk,
        dchinner@redhat.com, hch@lst.de
Subject: Re: [PATCH 2/2] writeback: allow for dirty metadata accounting
Message-ID: <20160810100957.GC12157@quack2.suse.cz>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
 <1470769707-26079-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470769707-26079-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 09-08-16 15:08:27, Josef Bacik wrote:
> Provide a mechanism for file systems to indicate how much dirty metadata they
> are holding.  This introduces a few things
> 
> 1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
> 2) WB stat for dirty metadata.  This way we know if we need to try and call into
> the file system to write out metadata.  This could potentially be used in the
> future to make balancing of dirty pages smarter.
> 3) A super callback to handle writing back dirty metadata.
> 
> A future patch will take advantage of this work in btrfs.  Thanks,

Hum, I once had a patch to allow filesystems to hook more into writeback
where a filesystem was just asked to do writeback and it could decide what
to do with it (it could use generic helpers to essentially replicate what
current writeback code does) but it could also choose some smarter strategy
of picking inodes to write. This scheme could easily accommodate your
metadata writeback as well and there are also other uses for it. But that
patch got broken by Tejun's cgroup aware writeback so one would have to
start from scratch.

We certainly have to think how to integrate this with cgroup aware
writeback. I guess your ->writeback_metadata() just does not bother and would
write anything in the root cgroup, right? After all you don't even pass the
information for which memcg the metadata writeback should be performed down
to the fs callback (that is encoded in the bdi_writeback structure). And
for now I think we could get away with that although it would need to be
handled properly in future I think.

If we created a generic filesystem writeback callback as I suggest, proper
integration with memcg writeback in unavoidable. But I have to think how to
do that best.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
