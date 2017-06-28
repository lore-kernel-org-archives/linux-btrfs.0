Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751723AbdF1O3U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 10:29:20 -0400
Date: Wed, 28 Jun 2017 16:28:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.13, part 1
Message-ID: <20170628142808.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1498229425.git.dsterba@suse.com>
 <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 24, 2017 at 06:05:03PM +0800, Wang Shilong wrote:
> Sorry for bikeshedding.

No problem, I won't read the rest of the mail then. (IOW, don't write
such things if you want people to read your mail.)

> On Fri, Jun 23, 2017 at 11:16 PM, David Sterba <dsterba@suse.com> wrote:
> > Hi,
> >
> > this is the main batch for 4.13. There are some user visible changes, see
> > below. The core updates improve error handling (mostly related to bios), with
> > the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
> >
> > Fabian Frederick (1):
> >       btrfs: kmap() can't fail
> >
> <..SNIP..>
> >
> > Sargun Dhillon (2):
> >       btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE
> >       btrfs: Add quota_override knob into sysfs
> >
> > Su Yue (9):
> >       btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
> >       btrfs: Check name_len with boundary in verify dir_item
> >       btrfs: Check name_len on add_inode_ref call path
> >       btrfs: Verify dir_item in replay_xattr_deletes
> >       btrfs: Check name_len in btrfs_check_ref_name_override
> >       btrfs: Check name_len before read in iterate_dir_item
> >       btrfs: Check name_len before reading btrfs_get_name
> >       btrfs: Check name_len before in btrfs_del_root_ref
> >       btrfs: Verify dir_item in iterate_object_props
> 
> Hmm..add those check might be expensive for metadata operations,
> especially in hot path, i could see similar behavior in Ext4 for ext4
> dentry check.

The checks are really simple, comparing a few numbers, and performed in
places that do not seem to be performance critical. The validation is
supposed to happen after the blocks are read from the disk (or using the
interface that does that, the page might be actually cached).

> Could we run some metadata tests to confirm？it makes sense to
> add check but with min affects to performace.

We can run such tests, I expect that the effect won't be measurable.
