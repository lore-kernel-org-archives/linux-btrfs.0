Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45327 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633Ab2HHPNZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 11:13:25 -0400
Date: Wed, 8 Aug 2012 17:13:20 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't allocate a seperate csums array for direct
 reads
Message-ID: <20120808151320.GX17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1344027115-31893-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344027115-31893-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 03, 2012 at 04:51:55PM -0400, Josef Bacik wrote:
> We've been allocating a big array for csums instead of storing them in the
> io_tree like we do for buffered reads because previously we were locking the
> entire range, so we didn't have an extent state for each sector of the
> range.  But now that we do the range locking as we map the buffers we can
> limit the mapping lenght to sectorsize and use the private part of the
> io_tree for our csums.  This allows us to avoid an extra memory allocation
> for direct reads which could incur latency.  Thanks,

This assumes the checksum value fits into the private state, ie
sizeof(csum) == 4, sizeof(private) == 8. There are 32 bytes reserved for
csum bytes, someday another algo will land, and will have to reintroduce
the kmalloc in some way, but there will be more code changes needed. The
assumptions about csum of u32 type are widespread. Getting rid of the
kmalloc is a good idea, I think we should take this patch for now.


david
