Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:1695 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751243AbcIGFd6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 01:33:58 -0400
Date: Wed, 7 Sep 2016 15:33:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Enhance _exclude_scratch_mount_option
 to handle multiply options and generic fs type
Message-ID: <20160907053353.GC22388@dastard>
References: <20160905071333.24688-1-quwenruo@cn.fujitsu.com>
 <20160906042039.GN27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160906042039.GN27776@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 12:20:39PM +0800, Eryu Guan wrote:
> On Mon, Sep 05, 2016 at 03:13:33PM +0800, Qu Wenruo wrote:
> > Enhance _exclude_scratch_mount_option() function to get real mount
> > options from $MOUNT_OPTIONS.
> 
> This seems unnecessarily complex to me.
> 
> > 
> > Now it can understand and extract real mount option from string like
> > "-o opt1,opt2 -oopt3".
> > Furthermore, it doesn't use grep method, which can lead to false alert
> > for options like inode_cache and noinode_cache.
> > It now do compare with the first n characters of the prohibited list,
> > so it can handle "data=" and above "no" prefix well.
> 
> I think we can fix it by adding "-w" option to grep, and replacing
> "data=" with "data", "=" seems not necessary.
> 
> > 
> > And add a new parameter, 'fstype' for _exclude_scratch_mount_option().
> > So for generic test cases, it can still prohibit mount options for given
> > fs(mainly for btrfs though)
> 
> This requires every caller of this helper provides an additional fstype
> argument, and in most cases this argument is not useful (generic or
> current FSTYP). If btrfs needs to be handled differently, how about
> checking the fstype in the test and adding additional mount option rules
> if fstype is btrfs?
> 
> > 
> > Finally, allow it to accept multiple options at the same time.
> > No need for multiple _exclude_scratch_mount_option lines now
> 
> So _exclude_scratch_mount_option is simply:
> 
> # skip test if MOUNT_OPTIONS contains the given mount options
> _exclude_scratch_mount_option()
> {
>         for opt in $*; do
>                 if echo $MOUNT_OPTIONS | grep -qw "$opt"; then
>                         _notrun "mount option \"$opt\" not allowed in this test"
>                 fi
>         done
> }
> 
> (Note that the comment in current code is wrong, MKFS_OPTIONS should be
> MOUNT_OPTIONS)
> 
> What do you and/or other people think?

Much simpler, easier to understand and tell why the test did not
run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
