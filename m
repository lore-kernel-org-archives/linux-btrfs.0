From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Deny sys_link across subvolumes.
Date: Thu, 12 Nov 2009 10:00:39 -0500
Message-ID: <20091112150039.GD3196@think>
References: <4AEA7A07.4020006@jp.fujitsu.com>
 <4AFBB5D2.3060405@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AFBB5D2.3060405@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 04:14:26PM +0900, TARUISI Hiroaki wrote:
> 
> From: Christian Parpart <trapni@gentoo.org>
> 
> I rebased Christian Parpart's patch to deny hard link across
> subvolumes. Original patch modifies also btrfs_rename, but
> I excluded it because we can move across subvolumes now and
> it make no problem.

Thanks for sending this in again.

Actually, we still can't rename across subvolumes, but we do support
renaming subvolumes.  Do you have some time to add more checks to rename
as well?

-chris
