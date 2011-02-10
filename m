From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs: issues with SUBVOL_SETFLAGS
Date: Thu, 10 Feb 2011 09:34:38 +0800
Message-ID: <4D5340AE.6040602@cn.fujitsu.com>
References: <1297278881.11434.36.camel@Dan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Dan Rosenberg <drosenberg@vsecurity.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297278881.11434.36.camel@Dan>
List-ID: <linux-btrfs.vger.kernel.org>

Dan Rosenberg wrote:
> Commit 0caa102da82799efaba88e234484786a9591c797 introduced the
> SUBVOL_SETFLAGS ioctl, which contains the following check:
> 
> 	if (flags & ~BTRFS_SUBVOL_CREATE_ASYNC)

Oops, should be:

if (flags & BTRFS_SUBVOL_CREATE_ASYNC)

> 		return -EINVAL;
> 
> 	if (flags & ~BTRFS_SUBVOL_RDONLY)
> 		return -EOPNOTSUPP;
> 
> Is it intentional that 0 is the only acceptable flags value?  In
> addition, there should probably be an inode ownership check before
> allowing setting subvolume flags.
> 

Thanks for pointing it out! Fix will be sent out soon.
