Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41875 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753838AbeDQRGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 13:06:03 -0400
Date: Tue, 17 Apr 2018 19:03:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] btrfs: Refactor btrfs_ioctl_snap_destroy() by
 using btrfs_delete_subvolume()
Message-ID: <20180417170330.GG21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
 <e4e8ecc3-fc4f-5967-1bf3-9f5abbac0c62@jp.fujitsu.com>
 <20180416175330.GS21272@twin.jikos.cz>
 <b373228a-a871-784a-0b46-45b77951a091@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b373228a-a871-784a-0b46-45b77951a091@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 09:21:16AM +0900, Misono Tomohiro wrote:
> On 2018/04/17 2:53, David Sterba wrote:
> > On Wed, Apr 11, 2018 at 02:20:49PM +0900, Misono Tomohiro wrote:
> >> Use btrfs_delete_subvolume() to refactor btrfs_ioctl_snap_destroy().
> >> The permission check is still done in btrfs_ioctl_snap_destroy(). Also,
> >> call of d_delete() is still required since btrfs_delete_subvolume()
> >> does not call it.
> >>
> >> As a result, btrfs_unlink_subvol() and may_destroy_subvol()
> >> become static functions. No functional change happens.
> >>
> >> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> > 
> > Why is this still split into two patches? Factoring out a function
> > should happen in one patch, ie 2 and 3 in one go. Do you have a reason
> > not to do it like that?
> 
> I thought this reduces code change in one patch and might be good, but
> I'm completely fine with merging 2nd and 3rd patches.

This makes the rewiew harder, if the code is moved the diff can be long
but we have both pieces to compare. Moving code is considered one
logical change and should not introduce any other changes, besides
renaming or formatting fixups.

> Should I send v5?

Yes please, this is not a trivial change and the changelogs need to be
adjusted. Thanks.
