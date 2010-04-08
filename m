From: David Brown <btrfs@davidb.org>
Subject: Re: [PATCH] fs/btrfs: Return EPERM for rmdir on subvolumes and
 snapshots
Date: Thu, 8 Apr 2010 15:07:17 -0700
Message-ID: <20100408220717.GA15666@arch.davidb.org>
References: <1270758931-5291-1-git-send-email-harsha@gluster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Harshavardhana <harsha@gluster.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1270758931-5291-1-git-send-email-harsha@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 01:35:31PM -0700, Harshavardhana wrote:


> 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
> 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
>-		return -ENOTEMPTY;
>+		return -EPERM;

Don't you want to still return ENOTEMPTY for the size check, and only
the EPERM on the root of subvolume?

David
