Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47085 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2HXQqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 12:46:40 -0400
Date: Fri, 24 Aug 2012 18:46:34 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use larger limit for transition of logical to
 inode
Message-ID: <20120824164633.GC17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
 <1345712189-6455-2-git-send-email-bo.li.liu@oracle.com>
 <503600DD.9030309@jan-o-sch.net>
 <503604C2.90400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503604C2.90400@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2012 at 06:24:02PM +0800, Liu Bo wrote:
> > Hum. I added this because I wanted to avoid allocations > PAGE_SIZE. We're doing
> > kmalloc GFP_NOFS with whatever one enters as size, I'm not sure that's a good
> > idea without any sanitizing.
> 
> Yeah, I agree.
> 
> So we do need to make some sanity checks, according to my tests,
> we need about 30k to resolve a file shared by 4000 snapshots.
> 
> What about 32k as a upside limit?

64k? As it's an upper limit, let's make it a bit higher than what one
can reach normally.

> > Second, we should probably add a fall back option to vmalloc, in case kmalloc
> > fails? Or should we even go for vmalloc directly, what do you think?
> 
> Given loi->size is not reliable, going for vmalloc for an ioctl is reasonable.

Yeah, vmalloc is ok here, we can safely afford to return ENOMEM.

AFAICS, we could possibly reuse the userspace buffer, iff build_ino_list
uses copy_to_user instead of directly writing to the data buffer. This
would eliminate the kernel-side ENOMEM completely at the cost of
function call overhead and the access_ok checks. And compared to the
simplicity of just vmalloc with rare occurence of ENOMEM, I don't think
it's worth the work.

david
