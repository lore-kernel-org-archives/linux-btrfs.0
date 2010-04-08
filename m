From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ENOTEMPTY on "rm -rf" for snapshot and subvolume
Date: Thu, 8 Apr 2010 09:52:16 -0400
Message-ID: <20100408135216.GE1400@think>
References: <4BBD26E4.7070106@gluster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Harshavardhana <harsha@gluster.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBD26E4.7070106@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 07, 2010 at 05:44:20PM -0700, Harshavardhana wrote:
> Hi Everyone,
> 
>      Recently i created a snapshot of an existing volume which had
> some amount of data.
>      Now that after creating the snapshot i have tried deleting the
> same snapshot.  But i am
>      getting ENOTEMPTY for "rmdir". But when i see the actual files
> inside are deleted
>      not the parent directory.
> 
>      From the code it looks like
> 
>      if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
>             inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
>                 return -ENOTEMPTY;
> 
>      Why would "unlink" succeeds for the files inside the
> directory?, yet returning ENOTEMPTY

You need to use the snapshot deletion ioctl to actually delete the
snapshot.

> 
>      This looks odd after this, i  went ahead and tried deleting the
> the existing volume itself
>      same result.
> 
>      So i was wondering if at all this is supposed to work this way,
> do i need to use "btrfs"
>      commands to delete subvolumes always? and their relative snapshots?.

Yes.  We could add support for doing this inside rm, it isn't a huge
amount of code.

> 
>      But either in that case too returning ENOTEMPTY does confuse a
> user a lot. Isn't it valid
>      just by returning EPERM will explain a lot to users saying that
> this is a snapshot of a
>      subvolume or a parent subvolume which is not supposed to be
> deleted this way.

Good point, eperm might be more intuitive.

-chris
