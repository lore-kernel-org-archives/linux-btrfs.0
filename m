Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbbJMMh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:37:28 -0400
Date: Tue, 13 Oct 2015 14:36:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Message-ID: <20151013123618.GI27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
 <20151013112848.GH27761@twin.jikos.cz>
 <002001d105ab$f6a96c60$e3fc4520$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <002001d105ab$f6a96c60$e3fc4520$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 07:40:30PM +0800, Zhao Lei wrote:
> > What I remember from the comment is that "it's slightly offset that would lead
> > to corruption".
> 
> Before this patch, I had done git blame to search why the condition was added,
> and hadn't found the exact reason.

found it: commit bc3f116fec194f1d7329b160c266fe16b9266a1e and it was not
aobut data/dup but mixed bgs with sectorisze != nodesize:

 26 +       nodesize = btrfs_super_nodesize(disk_super);
 27 +       leafsize = btrfs_super_leafsize(disk_super);
 28 +       sectorsize = btrfs_super_sectorsize(disk_super);
 29 +       stripesize = btrfs_super_stripesize(disk_super);
 30 +
 31 +       /*
 32 +        * mixed block groups end up with duplicate but slightly offset
 33 +        * extent buffers for the same range.  It leads to corruptions
 34 +        */
 35 +       if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
 36 +           (sectorsize != leafsize)) {
 37 +               printk(KERN_WARNING "btrfs: unequal leaf/node/sector sizes "
 38 +                               "are not allowed for mixed block groups on %s\n",
 39 +                               sb->s_id);
 40 +               goto fail_alloc;
 41 +       }
 42 +

> I will queue xfstests(btrfs/generic) at this profile with all mount option
> for multi-times, to check is something wrong with this.

Thanks. We need to cover more: the balance conversion forbids data/dup profile,
I'm not sure if scrub handles that properly, and the ususal suspects in the
rescue tools (fsck, restore, chunk-recover).
