Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60063 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KSNH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 08:07:59 -0500
Received: by mail-gh0-f174.google.com with SMTP id g15so202851ghb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2012 05:07:58 -0800 (PST)
Date: Mon, 19 Nov 2012 11:07:52 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash - Null dereference - 3.7.0-rc5-00068-gc5e35d6
Message-ID: <20121119130752.GA3457@joana>
References: <20121119025540.GA3858@joana>
 <20121119103221.GA8810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121119103221.GA8810@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

* Liu Bo <bo.li.liu@oracle.com> [2012-11-19 18:32:23 +0800]:

> On Mon, Nov 19, 2012 at 12:55:40AM -0200, Gustavo Padovan wrote:
> > Hi,
> > 
> > my system suddenly crashed and gave me this dump:
> > 
> > http://imgur.com/oO6S0
> > 
> > I checked and there is not btrfs commit in linus' tree since I compiled this
> > kernel.
> > 
> 
> Hi Gustavo,
> 
> It's weird that NULL pointer oops happens here.
> 
> Since you own the kernel, you may also have debuginfo left,
> 
> can you please run
> 'gdb fs/btrfs/btrfs.ko' and 'list *block_rsv_release_bytes+0x21' to
> check which one is NULL pointer?


(gdb) list *block_rsv_release_bytes+0x21
0xffffffff811a83c1 is in block_rsv_release_bytes
(fs/btrfs/extent-tree.c:4065).
4060	
4061	static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
4062					    struct btrfs_block_rsv *block_rsv,
4063					    struct btrfs_block_rsv *dest, u64
num_bytes)
4064	{
4065		struct btrfs_space_info *space_info = block_rsv->space_info;
4066	
4067		spin_lock(&block_rsv->lock);
4068		if (num_bytes == (u64)-1)
4069			num_bytes = block_rsv->size;
(gdb) 

Seems block_rsv is NULL here and looking to btrfs_block_rsv_release() it can
only be NULL at this point if global_rsv->full is true otherwise the crash
would happen there. I didn't go any further than this.

	Gustavo
