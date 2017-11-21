Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdKUPDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 10:03:18 -0500
Date: Tue, 21 Nov 2017 16:01:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        lists@colorremedies.com
Subject: Re: [PATCH] btrfs: Enhance btrfs_trim_fs function to handle error
 better
Message-ID: <20171121150122.GM3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171120055651.17892-1-wqu@suse.com>
 <20171120175106.GE3553@twin.jikos.cz>
 <6639f8f2-7842-65ad-bfbb-fa04439b58c2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6639f8f2-7842-65ad-bfbb-fa04439b58c2@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 09:07:01AM +0800, Qu Wenruo wrote:
> On 2017年11月21日 01:51, David Sterba wrote:
> > On Mon, Nov 20, 2017 at 01:56:51PM +0800, Qu Wenruo wrote:
> >> Function btrfs_trim_fs() doesn't handle errors in a consistent way, if
> >> error happens when trimming existing block groups, it will skip the
> >> remaining blocks and continue to trim unallocated space for each device.
> >>
> >> And the return value will only reflect the final error from device
> >> trimming.
> >>
> >> This patch will fix such behavior by:
> >>
> >> 1) Recording first error from block group or device trimming
> >>    So return value will also reflect any error found when trimming.
> >>    Make developer more aware of the problem.
> >>
> >> 2) Outputting btrfs warning message for each trimming failure
> >>    Any error for block group or device trimming will cause btrfs warning
> >>    kernel message.
> > 
> > I think this could become too noisy, trimming failures are soft errors
> > IMO, so it should be enough to report all errors cumulatively
> > per-device.
> 
> Although block group trimming errors are not that obvious to be reported
> at per-device base.

The idea is to give an early warning that some device is not all ok, but
fstrim might be the wrong place to do such checks and reports anyway.

> >> @@ -11012,15 +11031,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >>  	list_for_each_entry(device, devices, dev_alloc_list) {
> >>  		ret = btrfs_trim_free_extents(device, range->minlen,
> >>  					      &group_trimmed);
> >> -		if (ret)
> >> +		if (ret) {
> >> +			btrfs_warn_rl(fs_info,
> >> +		"failed to trim unallocated space for devid %llu ret %d",
> >> +				      device->devid, ret);
> > 
> > So the idea is to print one message here, with devid, number of errors
> > and how many bytes were skipped.
> 
> About number of errors, did you mean also accounting the errors found in
> block group trimming?
> In that case, it may not be related to all devices of a block group.
> 
> So this doesn't look appropriate to account block group errors into
> device error.

Right, the more I think about that, the per-device reports make less
sense.

After another look to btrfs_trim_free_extents, there are some error
cases that are not fatal and mostly related to interrupting the whole
operation, so this needs to be reworked.
