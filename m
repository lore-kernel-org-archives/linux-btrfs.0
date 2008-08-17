From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Sun, 17 Aug 2008 14:30:17 +0100
Message-ID: <1218979817.3184.296.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200808171854.14275.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-17 at 18:54 +0530, Balaji Rao wrote:
> 
> 
> OK. I had copied over this code snippet from
> inode.c:btrfs_inode_by_name, 
> which has the condition 'if (slot >= nritems)' removed now by this.
> 
> changeset:   631:87490dc3bb59
> user:        "Yan Zheng" <yanzheng@21cn.com>
> date:        Thu Jul 24 12:19:32 2008 -0400
> summary:     Fix .. lookup corner case
> 
> I think we should refactor btrfs_inode_by_name into something we can
> use ?

I'm not entirely sure why btrfs_inode_by_name() handles "." and ".." at
all. We haven't needed that since the 2.2 kernel, have we?

I think we should just remove that code completely -- and remove the
similar code from btrfs_real_readdir() while we're at it -- just use
parent_ino(filp->f_path.dentry) instead. In _that_ case, we know the
dcache is connected.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



