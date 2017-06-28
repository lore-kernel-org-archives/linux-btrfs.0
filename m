Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751489AbdF1OjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 10:39:11 -0400
Date: Wed, 28 Jun 2017 16:38:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Wang Shilong <wangshilong1991@gmail.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.13, part 1
Message-ID: <20170628143800.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1498229425.git.dsterba@suse.com>
 <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
 <93c6aac1-dfc3-ba27-6607-2439e7b3748d@suse.com>
 <2361fb3f-dfde-cc9e-ac40-23c612771bc6@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2361fb3f-dfde-cc9e-ac40-23c612771bc6@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 08:53:14AM +0800, Qu Wenruo wrote:
> At 06/26/2017 05:34 AM, Jeff Mahoney wrote:
> > On 6/24/17 6:05 AM, Wang Shilong wrote:
> >> Sorry for bikeshedding.
> >>
> >> On Fri, Jun 23, 2017 at 11:16 PM, David Sterba <dsterba@suse.com> wrote:
> >>> Hi,
> >>>
> >>> this is the main batch for 4.13. There are some user visible changes, see
> >>> below. The core updates improve error handling (mostly related to bios), with
> >>> the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
> >>>
> >>> Fabian Frederick (1):
> >>>        btrfs: kmap() can't fail
> >>>
> >> <..SNIP..>
> >>>
> >>> Sargun Dhillon (2):
> >>>        btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE
> >>>        btrfs: Add quota_override knob into sysfs
> >>>
> >>> Su Yue (9):
> >>>        btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
> >>>        btrfs: Check name_len with boundary in verify dir_item
> >>>        btrfs: Check name_len on add_inode_ref call path
> >>>        btrfs: Verify dir_item in replay_xattr_deletes
> >>>        btrfs: Check name_len in btrfs_check_ref_name_override
> >>>        btrfs: Check name_len before read in iterate_dir_item
> >>>        btrfs: Check name_len before reading btrfs_get_name
> >>>        btrfs: Check name_len before in btrfs_del_root_ref
> >>>        btrfs: Verify dir_item in iterate_object_props
> >>
> >> Hmm..add those check might be expensive for metadata operations,
> >> especially in hot path, i could see similar behavior in Ext4 for ext4
> >> dentry check.
> >>
> >> Could we run some metadata tests to confirm？it makes sense to
> >> add check but with min affects to performace.
> 
> IIRC there is a backtrace in one of the patches.
> If needed, we can also upload the fuzzed image.
> Although we don't have good enough test suite which accepts fuzzed image 
> for kernel.

As we have the fuzzed images in progs, I started prototyping a way to
export just the testsuite from the git repository, to a tarball. The
test would then iterate over the stored images and attempt to mount
them. So any images you'd like mount-tested, also submit to btrfs-progs.
