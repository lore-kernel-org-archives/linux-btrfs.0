From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/9] some fixes for bugs spotted by valgrind
Date: Fri, 3 Jun 2011 01:26:36 +0200
Message-ID: <20110602232636.GJ27166@one.firstfloor.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org> <20110531221037.0454f16e@sf> <m262oot2bw.fsf@firstfloor.org> <20110603001325.4a64b7c3@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyfox@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110603001325.4a64b7c3@sf>
List-ID: <linux-btrfs.vger.kernel.org>

>         bh = btrfs_read_dev_super(fs_devices->latest_bdev);
>         if (!bh) {
>                 err = -EINVAL;
>                 goto fail_alloc;
>         }
> 
>         memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy));
>         memcpy(&fs_info->super_for_commit, &fs_info->super_copy,
>                sizeof(fs_info->super_for_commit));
>         brelse(bh);
> 
> But the way superblocks are written look racy.

FWIW for my ext4 checksumming work I had to add an extra lock to stabilize 
the super block (and the inodes) during checksumming.

Maybe something similar is needed here too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
