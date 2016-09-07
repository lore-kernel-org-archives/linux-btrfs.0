Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751081AbcIGEHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 00:07:50 -0400
Date: Wed, 7 Sep 2016 12:07:47 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Enhance _exclude_scratch_mount_option
 to handle multiply options and generic fs type
Message-ID: <20160907040747.GP27776@eguan.usersys.redhat.com>
References: <20160905071333.24688-1-quwenruo@cn.fujitsu.com>
 <20160906042039.GN27776@eguan.usersys.redhat.com>
 <1bdfe67d-17ca-c95b-a10d-f9ac072b1aca@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1bdfe67d-17ca-c95b-a10d-f9ac072b1aca@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 01:06:39PM +0800, Qu Wenruo wrote:
> 
> 
> At 09/06/2016 12:20 PM, Eryu Guan wrote:
> > On Mon, Sep 05, 2016 at 03:13:33PM +0800, Qu Wenruo wrote:
> > > Enhance _exclude_scratch_mount_option() function to get real mount
> > > options from $MOUNT_OPTIONS.
> > 
> > This seems unnecessarily complex to me.
> 
> Considering the fact that we didn't specify any other options except -o,
> yes, it's a quite complex than original one.
> 
> But, it's still needed for case like "-oopt3" can't be handled by "grep -w",
> as there is no space between "-o" and "opt3".
> 
> > 
> > > 
> > > Now it can understand and extract real mount option from string like
> > > "-o opt1,opt2 -oopt3".
> > > Furthermore, it doesn't use grep method, which can lead to false alert
> > > for options like inode_cache and noinode_cache.
> > > It now do compare with the first n characters of the prohibited list,
> > > so it can handle "data=" and above "no" prefix well.
> > 
> > I think we can fix it by adding "-w" option to grep, and replacing
> > "data=" with "data", "=" seems not necessary.
> 
> In that case, "-oopt3" can't be handled by "-w" option.

Ah, I missed that. Then "normalize" MOUNT_OPTIONS first should be OK,
like what you do in this patch.

> 
> > 
> > > 
> > > And add a new parameter, 'fstype' for _exclude_scratch_mount_option().
> > > So for generic test cases, it can still prohibit mount options for given
> > > fs(mainly for btrfs though)
> > 
> > This requires every caller of this helper provides an additional fstype
> > argument, and in most cases this argument is not useful (generic or
> > current FSTYP). If btrfs needs to be handled differently, how about
> > checking the fstype in the test and adding additional mount option rules
> > if fstype is btrfs?
> 
> Currently, only 2 callers in fact. ext4/271 and xfs/134.
> So the cost is still quite low to add a 'fstype'.

I mean in most cases the fstype is not useful, not only to existing
callers but also to future callers. We can always add special-case when
needed for a certain fstype.

And there're other callers outside of test case, e.g.
_require_metadata_journaling()
_require_atime()
where you have no idea which filesystem is under testing.

> 
> The main object is, to info reviewer or testcase writer which fs type needs
> special handling.
> 
> Considering not every contributor will add comment about excluded mount
> options, and in case generic test cases needs to exclude one mount option
> for given fstype, it will be quite hard to find the reason.
> 
> So with new fstype parameter, at least we known which fstype is to be blame.
> (Although, it will be btrfs for most of time)

Reviewers and maintainers should ask for comments to explain the reason
why a certain mount option is excluded. So I'd suggest something
like(not tested)

# skip test if MOUNT_OPTIONS contains the given mount options
_exclude_scratch_mount_option()
{
	local opts=`echo $MOUNT_OPTIONS | sed 's/-o/ /g'`
	for opt in $*; do
		if echo $opts | grep -qw "$opt"; then
			_notrun "mount option \"$opt\" not allowed in this test"
		fi
	done
}

And in normal case, we do

# exclude mount option xxx because ...
_exclude_scratch_mount_option "opt1" "opt2"

And when btrfs needs special handling

# comments to explain why btrfs needs special handling
if [ "$FSTYP" == "btrfs" ]; then
	_exclude_scratch_mount_option "opt1" "opt2"
fi

Thanks,
Eryu
