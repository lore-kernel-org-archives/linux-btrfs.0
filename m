Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbcFWJYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 05:24:10 -0400
Date: Thu, 23 Jun 2016 11:24:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: fix free space calculation in
 dump_space_info()
Message-ID: <20160623092433.GW4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466419625-6755-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20160620180951.GA16446@vader.DHCP.thefacebook.com>
 <57689CA1.7040000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57689CA1.7040000@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 09:47:13AM +0800, Wang Xiaoguang wrote:
> hello,
> 
> On 06/21/2016 02:09 AM, Omar Sandoval wrote:
> > On Mon, Jun 20, 2016 at 06:47:05PM +0800, Wang Xiaoguang wrote:
> >> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> >> ---
> >>   fs/btrfs/extent-tree.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index f3e6666..13a87fe 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -7736,8 +7736,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
> >>   	printk(KERN_INFO "BTRFS: space_info %llu has %llu free, is %sfull\n",
> >>   	       info->flags,
> >>   	       info->total_bytes - info->bytes_used - info->bytes_pinned -
> >> -	       info->bytes_reserved - info->bytes_readonly,
> >> -	       (info->full) ? "" : "not ");
> >> +	       info->bytes_reserved - info->bytes_readonly -
> >> +	       info->bytes_may_use, (info->full) ? "" : "not ");
> >>   	printk(KERN_INFO "BTRFS: space_info total=%llu, used=%llu, pinned=%llu, "
> >>   	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
> >>   	       info->total_bytes, info->bytes_used, info->bytes_pinned,
> > I think you meant to send this to linux-btrfs@vger.kernel.org
> Yes, should I resend it to linux-btrfs@vger.kernel.org again? thanks.

Yes please so we have it in the patchwork archive.
