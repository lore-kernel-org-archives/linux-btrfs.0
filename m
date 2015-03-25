Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbbCYRWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 13:22:43 -0400
Date: Wed, 25 Mar 2015 18:22:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix build breakage
Message-ID: <20150325172241.GI20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <1427302321-3458-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427302321-3458-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 25, 2015 at 04:52:01PM +0000, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch adds necessary include file, fixing following build errors:
> 
> fs/btrfs/inode.c:8094:13: error: undefined identifier 'iov_iter_alignment'
> fs/btrfs/inode.c:8105:33: error: using member 'nr_segs' in incomplete struct iov_iter
> fs/btrfs/inode.c:8106:43: error: using member 'nr_segs' in incomplete struct iov_iter
> fs/btrfs/inode.c:8107:33: error: using member 'iov' in incomplete struct iov_iter
> fs/btrfs/inode.c:8140:17: error: undefined identifier 'iov_iter_count'
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks, we've a patch for that already

https://patchwork.kernel.org/patch/6069411/
