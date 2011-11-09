From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198
 btrfs_orphan_commit_root+0xa8/0xc0
Date: Wed, 9 Nov 2011 10:35:53 -0500
Message-ID: <20111109153552.GB1810@localhost.localdomain>
References: <4EBA54F2.3030801@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBA54F2.3030801@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 11:24:50AM +0100, Stefan Kleijkers wrote:
> Hello,
> 
> I'm seeing a lot of warnings in dmesg with a BTRFS filesystem. I'm
> using the 3.1 kernel, I found a patch for these warnings (
> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2)
> <http://marc.info/?l=linux-btrfs&m=131547325515336&w=2>, but that
> patch has already been included in 3.1. Are there any other patches
> I can try?
> 
> I'm using BTRFS in combination with Ceph and it looks like after a
> while with a high rsync workload that the IO stalls for some time,
> could the warnings result in IO stall?
> 

Can you run with this patch and see if you get warnings from extent-tree.c?
Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0b044e5..144cd8e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3721,6 +3721,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_lock(&block_rsv->lock);
 	if (num_bytes == (u64)-1)
 		num_bytes = block_rsv->size;
+	WARN_ON(block_rsv->size < num_bytes);
 	block_rsv->size -= num_bytes;
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
