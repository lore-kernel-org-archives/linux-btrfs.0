Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbcGKIrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 04:47:49 -0400
Date: Mon, 11 Jul 2016 10:48:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND PATCH] btrfs: Handle uninitialised inode eviction
Message-ID: <20160711084800.GR13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468219389-28736-1-git-send-email-kernel@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468219389-28736-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 09:43:09AM +0300, Nikolay Borisov wrote:
> The code flow in btrfs_new_inode allows for btrfs_evict_inode to be
> called with not fully initialised inode (e.g. ->root member not
> being set). This can happen when btrfs_set_inode_index in
> btrfs_new_inode fails, which in turn would call iput for the newly
> allocated inode. This in turn leads to vfs calling into btrfs_evict_inode.
> This leads to null pointer dereference. To handle this situation check whether
> the passed inode has root set and just free it in case it doesn't.
> 
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Hello, 
> 
> I belive this is fixes the issue reported in 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/57809

There's some time left before 4.7 release, so I'll send another pull
request, including this patch.
