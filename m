From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 10/12 v3] Btrfs: deal with EEXIST after iput
Date: Tue, 21 Jun 2011 10:00:02 -0400
Message-ID: <4E00A3E2.9030108@redhat.com>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com> <1308646193-7086-11-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308646193-7086-11-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2011 04:49 AM, Liu Bo wrote:
> There are two cases when BTRFS_I(inode)->logged_trans is zero:
> a) an inode is just allocated;
> b) iput an inode and reread it.
>
> However, in b) if btrfs is not committed yet, and this inode _may_ still remain
> in log tree.
>
> So we need to check the log tree to get logged_trans a right value
> in case it hits a EEXIST while logging.

Instead of doing this why not just check and see if the inode has been 
logged but the transaction has not yet been committed in 
btrfs_drop_inode?  That way the inode doesn't get evicted from cache 
until after we know it's ok and that way we don't have to waste a tree 
lookup.  Thanks,

Josef
