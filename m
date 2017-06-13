Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752078AbdFMNWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 09:22:49 -0400
Date: Tue, 13 Jun 2017 15:21:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH] btrfs: use ino_t for inode in tracer
Message-ID: <20170613132143.GU25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
 <20170613064151.GA17424@infradead.org>
 <8c7e2250-aa58-2da6-a09c-38f470cdc31c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8c7e2250-aa58-2da6-a09c-38f470cdc31c@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 13, 2017 at 04:12:10PM +0800, Anand Jain wrote:
> 
> 
> On 06/13/2017 02:41 PM, Christoph Hellwig wrote:
> > I thought btrfs supports 64-bit inodes, in which case this will
> > truncate the inode number on 32-bit architectures.
> 
>   Good catch. Thanks !
> 
>   Will send the updated patch.

Hold on. We should then use u64 everywhere in the tracepoints. And this
would mean more extensive changes than just switching a few types. Eg.
pass 'struct btrfs_inode' instead of 'struct inode', reflecting the
recent changes to the function prototypes to always use btrfs_inode for
any functions that do not interface to VFS.

We can use the btrfs_ino helper to extract the inode number. This is
already done in some places so this would unify them. And not only the
inode number, there are some further cleanups possible in the
tracepoints.

I'd rather not divert the work to tracepoints at this moment and
postpone it for next cycle, as the wgon ino types are not critical.
