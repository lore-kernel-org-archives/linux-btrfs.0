Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58299 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUOE7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 10:04:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0329A7C06B0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 08:04:59 -0600 (MDT)
Date: Wed, 21 Aug 2013 10:04:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Josef Bacik <jbacik@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
Message-ID: <20130821140456.GM3990@localhost.localdomain>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
 <20130813141542.GF2150@localhost.localdomain>
 <CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
 <CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
 <CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 21, 2013 at 08:44:55AM -0500, Mitch Harder wrote:
> On Thu, Aug 15, 2013 at 12:29 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
> > I'm running into a curious problem.
> >
> > In the process of making my script portable, I am breaking the ability
> > to replicate the error.
> >
> > I'm trying to isolate the aspect of my local script that is triggering
> > the error.  No firm insights yet.
> >
> >
> > On Tue, Aug 13, 2013 at 11:03 AM, Mitch Harder
> > <mitch.harder@sabayonlinux.org> wrote:
> >> Let me work on making that script more portable, and hopefully quicker
> >> to reproduce.
> >>
> >> On Tue, Aug 13, 2013 at 9:15 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> >>> On Mon, Aug 12, 2013 at 11:06:27PM -0500, Mitch Harder wrote:
> >>>> I'm hitting a btrfs Kernel BUG running a snapshot stress script with
> >>>> linux-3.11.0-rc5.
> >>>>
> >>>
> >>> I can haz script?  Thanks,
> >>>
> 
> I've had a hard time assembling a portable reproducer for this issue.
> 
> I discovered that my reproducer was highly dependent on a local
> archive of out-of-date git kernel sources.  My efforts to reproduce
> the error with a portable set of scripts with publicly available
> kernel git sources weren't successful.
> 
> It seems like this issue is related to a corner-case workload that is
> difficult to reproduce.
> 
> So I've bisected the error I was seeing with my local script, and
> identified the following commit as triggering my issue:
> 
> commit:    3c64a1aba7cfcb04f79e76f859b3d66660275d59
> Btrfs: cleanup: don't check the same thing twice
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=for-linus&id=3c64a1aba7cfcb04
> 
> I tested a kernel which reverted this change, and also added WARN_ON
> lines to provide a back trace.
> 
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index 4b86916..336d628 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -82,6 +82,12 @@ static struct dentry *btrfs_get_dentry(struct
> super_block *sb, u64 objectid,
>          goto fail;
>      }
> 
> +    if (btrfs_root_refs(&root->root_item) == 0) {
> +        WARN_ON(1);
> +        err = -ENOENT;
> +        goto fail;
> +    }
> +
>      key.objectid = objectid;
>      btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
>      key.offset = 0;
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 94413af..4010257 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -310,6 +310,12 @@ static int __btrfs_run_defrag_inode(struct
> btrfs_fs_info *fs_info,
>          goto cleanup;
>      }
> 
> +    if (btrfs_root_refs(&inode_root->root_item) == 0) {
> +        WARN_ON(1);
> +        ret = -ENOENT;
> +        goto cleanup;
> +    }
> +

Funnily enough I just added this check back in a different commit.  Now that I
look at the reasoning tho this cleanup patch was wrong.  We do check if
root_refs is 0 in btrfs_read_fs_root_no_name, but only if the root isn't already
in cache.  If it is in cache we will happily return it with no issue.  So either
we should add the extra check for the in-cache case (probably a good idea), or
go back and add all of these checks back.  Thanks,

Josef
