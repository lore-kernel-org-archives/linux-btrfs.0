Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdIAHEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 03:04:43 -0400
Date: Fri, 1 Sep 2017 15:04:41 +0800
From: Eryu Guan <eguan@redhat.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Add new common filter function
Message-ID: <20170901070441.GQ27835@eguan.usersys.redhat.com>
References: <5f6cd84d-6e12-2b23-09fc-c0f744d1d2f2@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5f6cd84d-6e12-2b23-09fc-c0f744d1d2f2@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 02:39:44PM +0900, Misono, Tomohiro wrote:
> Several tests uses both _filter_test_dir and _filter_scratch
> concatenated by pipe to filter $TEST_DIR and $SCRATCH_MNT. However, this
> would fail if the shorter string is a substring of the other (like
> "/mnt" and "/mnt2").
> 
> This patch introduces new common filter function to safely call both
> _filter_test_dir and _filter_scratch.
> 
> I chedked this with btrfs/029, generic/409,410,411, and generic/381,383,
> xfs/106,108 (which calls _filter_quota). Thanks Eryu for advice.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Thanks! Though I don't think we need two separate patches, so I merged
the two patches together at commit time.

> ---
>  common/filter | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/filter b/common/filter
> index 1ef342b..75570f9 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -295,6 +295,17 @@ _filter_scratch()
>  	    -e "/.use_space/d"
>  }
>  
> +_filter_testdir_and_scratch()
> +{
> +	# filter both $TEST_DIR and $SCRATCH_MNT, but always filter the longer
> +	# string first if the other string is a substring of the first one
> +	if echo "$TEST_DIR" | grep -q "$SCRATCH_MNT"; then
> +	  _filter_test_dir | _filter_scratch
> +	else
> +	  _filter_scratch | _filter_test_dir

And fixed the indention here, used tab :)

Thanks,
Eryu

> +	fi
> +}
> +
>  # Turn any device in the scratch pool into SCRATCH_DEV
>  _filter_scratch_pool()
>  {
> -- 
> 2.9.5
> 
