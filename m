From: David Brown <davidb@davidb.org>
Subject: Re: [patch] Btrfs: silence a compiler warning
Date: Wed, 22 Feb 2012 08:29:26 -0800
Message-ID: <20120222162926.GA25392@davidb.org>
References: <20120222073055.GB7389@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120222073055.GB7389@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 22, 2012 at 10:30:55AM +0300, Dan Carpenter wrote:
>Gcc warns that "ret" can be used uninitialized.  It can't actually be
>used uninitialized because btrfs_num_copies() always returns 1 or more.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
>index 064b29b..c053e90 100644
>--- a/fs/btrfs/check-integrity.c
>+++ b/fs/btrfs/check-integrity.c
>@@ -643,7 +643,7 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(
> static int btrfsic_process_superblock(struct btrfsic_state *state,
> 				      struct btrfs_fs_devices *fs_devices)
> {
>-	int ret;
>+	int ret = 0;

Does

	int uninitialized_var(ret);

work?  The assignment to zero actually generates additional
(unnecessary) code.

David
