From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Sun, 17 Aug 2008 14:40:39 +0100
Message-ID: <1218980439.3184.304.camel@pmac.infradead.org>
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
> OK. I had copied over this code snippet from
> inode.c:btrfs_inode_by_name, 
> which has the condition 'if (slot >= nritems)' removed now by this.
> 
> changeset:   631:87490dc3bb59
> user:        "Yan Zheng" <yanzheng@21cn.com>
> date:        Thu Jul 24 12:19:32 2008 -0400
> summary:     Fix .. lookup corner case

Er, isn't that just moving the error case around?

That's commit 3dcd1334c286fa4467219302ff2f9a4a190fbb9c in the git tree:
http://git.kernel.org/?p=linux/kernel/git/dwmw2/btrfs-kernel-unstable.git;a=commitdiff;h=3dcd1334

Your version fails if the item we want is in slot 0, because we don't
jump forward to the next leaf.

The new version fails if it's in the _last_ slot -- the return from
btrfs_search_slot() now points to the first slot in the next leaf, and
we treat that as an error instead of rewinding to the one we want. It's
just the same error, but in reverse.

Or am I missing something?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



