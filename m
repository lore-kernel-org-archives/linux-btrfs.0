Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752493AbbJMNNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 09:13:32 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com> <20151013112848.GH27761@twin.jikos.cz> <002001d105ab$f6a96c60$e3fc4520$@cn.fujitsu.com> <20151013123618.GI27761@twin.jikos.cz>
In-Reply-To: <20151013123618.GI27761@twin.jikos.cz>
Subject: RE: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Date: Tue, 13 Oct 2015 21:13:17 +0800
Message-ID: <003201d105b8$ed549600$c7fdc200$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, October 13, 2015 8:36 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: dsterba@suse.cz; linux-btrfs@vger.kernel.org; clm@fb.com
> Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
> 
> On Tue, Oct 13, 2015 at 07:40:30PM +0800, Zhao Lei wrote:
> > > What I remember from the comment is that "it's slightly offset that
> > > would lead to corruption".
> >
> > Before this patch, I had done git blame to search why the condition
> > was added, and hadn't found the exact reason.
> 
> found it: commit bc3f116fec194f1d7329b160c266fe16b9266a1e and it was not
> aobut data/dup but mixed bgs with sectorisze != nodesize:
> 
>  26 +       nodesize = btrfs_super_nodesize(disk_super);
>  27 +       leafsize = btrfs_super_leafsize(disk_super);
>  28 +       sectorsize = btrfs_super_sectorsize(disk_super);
>  29 +       stripesize = btrfs_super_stripesize(disk_super);
>  30 +
>  31 +       /*
>  32 +        * mixed block groups end up with duplicate but slightly offset
>  33 +        * extent buffers for the same range.  It leads to corruptions
>  34 +        */
>  35 +       if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> &&
>  36 +           (sectorsize != leafsize)) {
>  37 +               printk(KERN_WARNING "btrfs: unequal
> leaf/node/sector sizes "
>  38 +                               "are not allowed for mixed block
> groups on %s\n",
>  39 +                               sb->s_id);
>  40 +               goto fail_alloc;
>  41 +       }
>  42 +
> 
Thanks for this information, I'll investigate is similar problem in non-mixed
with dup.

> > I will queue xfstests(btrfs/generic) at this profile with all mount
> > option for multi-times, to check is something wrong with this.
> 
> Thanks. We need to cover more: the balance conversion forbids data/dup
> profile, I'm not sure if scrub handles that properly, and the ususal suspects in
> the rescue tools (fsck, restore, chunk-recover).
>
Agree, a new profile may be have potential problem because existing code
haven't check the support status.

IMHO, it is still necessary except we can prove this function should not exist.
But we'll need to do more works to confirm above potential problem.

Thanks
Zhaolei


