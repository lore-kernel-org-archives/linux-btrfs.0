Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbcFUNVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 09:21:08 -0400
Date: Tue, 21 Jun 2016 21:20:30 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fstests: btrfs: add functions to set and reset
 required number of SCRATCH_DEV_POOL
Message-ID: <20160621132030.GX5140@eguan.usersys.redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1465980363-18906-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465980363-18906-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 04:46:03PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This patch provides functions
>  _scratch_dev_pool_get()
>  _scratch_dev_pool_put()
> 
> Which will help to set/reset SCRATCH_DEV_POOL with the required
> number of devices. SCRATCH_DEV_POOL_SAVED will hold all the devices.
> 
> Usage:
>   _scratch_dev_pool_get() <ndevs>
>   :: do stuff
> 
>   _scratch_dev_pool_put()
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

I think the helpers should be introduced when they are first used, so
that we know why they're introduced, and know how they're used with
clear examples.

So patch 1, 2 and 4 can be merged as one patch, patch 3 updates
btrfs/027, patch 4 and patch 5 can be merged as one patch, then comes
patch 6.

What do you think?

> ---
>  v2: Error message and comment section updates.
> 
>  common/rc | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 51092a0644f0..31c46ba1226e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -802,6 +802,61 @@ _scratch_mkfs()
>      esac
>  }
>  
> +#
> +# Generally test cases will have..
> +#   _require_scratch_dev_pool X
> +# to make sure it has the enough scratch devices including
> +# replace-target and spare device. Now arg1 here is the
> +# required number of scratch devices by a-test-case excluding
> +# the replace-target and spare device. So this function will
> +# set SCRATCH_DEV_POOL to the specified number of devices.
> +#
> +# Usage:
> +#  _scratch_dev_pool_get() <ndevs>
> +#     :: do stuff
> +#
> +#  _scratch_dev_pool_put()
> +#
> +_scratch_dev_pool_get()
> +{
> +	if [ $# != 1 ]; then

"-ne" "-eq" etc. are used for comparing integers, "=!" "==" are for
strings. And I think $#, $? are integers here, "-ne" would be better.

Thanks,
Eryu

> +		_fail "Usage: _scratch_dev_pool_get ndevs"
> +	fi
> +
> +	local test_ndevs=$1
> +	local config_ndevs=`echo $SCRATCH_DEV_POOL| wc -w`
> +	local devs[]="( $SCRATCH_DEV_POOL )"
> +
> +	typeset -p config_ndevs >/dev/null 2>&1
> +	if [ $? != 0 ]; then
> +		_fail "Bug: cant find SCRATCH_DEV_POOL ndevs"
> +	fi
> +
> +	if [ $config_ndevs -lt $test_ndevs ]; then
> +		_notrun "Need at least test requested number of ndevs $test_ndevs"
> +	fi
> +
> +	SCRATCH_DEV_POOL_SAVED=${SCRATCH_DEV_POOL}
> +	export SCRATCH_DEV_POOL_SAVED
> +	SCRATCH_DEV_POOL=${devs[@]:0:$test_ndevs}
> +	export SCRATCH_DEV_POOL
> +}
> +
> +_scratch_dev_pool_put()
> +{
> +	typeset -p SCRATCH_DEV_POOL_SAVED >/dev/null 2>&1
> +	if [ $? != 0 ]; then
> +		_fail "Bug: unset val, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
> +	fi
> +
> +	if [ -z "$SCRATCH_DEV_POOL_SAVED" ]; then
> +		_fail "Bug: str empty, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
> +	fi
> +
> +	export SCRATCH_DEV_POOL=$SCRATCH_DEV_POOL_SAVED
> +	export SCRATCH_DEV_POOL_SAVED=""
> +}
> +
>  _scratch_pool_mkfs()
>  {
>      case $FSTYP in
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
