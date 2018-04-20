Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755366AbeDTPRi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 11:17:38 -0400
Date: Fri, 20 Apr 2018 17:15:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
Message-ID: <20180420151504.GR21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180419093816.888-1-wqu@suse.com>
 <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 10:32:03PM +0800, Anand Jain wrote:
> 
> 
> On 04/19/2018 05:38 PM, Qu Wenruo wrote:
> > Although we have already checked incompat flags manually before really
> > mounting it, we could still enhance btrfs_check_super_valid() to check
> > incompat flags for later write time super block validation check.
> > 
> > This patch adds such incompat flags check for btrfs_check_super_valid(),
> > currently it won't be triggered, but provides the basis for later write
> > time check.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >   fs/btrfs/disk-io.c | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 60caa68c3618..ec123158f051 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
> >   		ret = -EINVAL;
> >   	}
> >   
> > +	/*
> > +	 * Before calling btrfs_check_super_valid() we have already checked
> > +	 * incompat flags. So if we developr new incompat flags, it's must be
> > +	 * some corruption.
> > +	 */
> > +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> > +		btrfs_err(fs_info,
> > +		"corrupted incompat flags detected 0x%llx, supported 0x%llx",

> 2707         features = btrfs_super_incompat_flags(disk_super) &
> 2708                 ~BTRFS_FEATURE_INCOMPAT_SUPP;
> 2709         if (features) {
> 2710                 btrfs_err(fs_info,
> 2711                     "cannot mount because of unsupported optional features (%llx)",
> 2712                     features);
> 2713                 err = -EINVAL;
> 2714                 goto fail_alloc;
> 2715         }

So there's a "user experience" change, now that you pointed out the
other check. If a filesystem with incompat bits set will be mounted,
this will say 'you have corrupted filesystem', which is not IMO what we
want to tell.

Tough the extended btrfs_check_super_valid could catch the corrupted
incompat bits, what we need at mount time is wording from the 2nd
message ("cannot mount unsuppported features").

I think that there should be a separate function that does the
pre-commit checks, calls btrfs_check_super_valid and also validates the
incompat bit.
