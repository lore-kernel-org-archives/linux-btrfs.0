Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbbGXDDN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 23:03:13 -0400
Date: Fri, 24 Jul 2015 11:03:11 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@fb.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
Message-ID: <20150724030310.GN3945@dhcp-13-216.nay.redhat.com>
References: <cover.1437683940.git.osandov@fb.com>
 <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 01:51:50PM -0700, Omar Sandoval wrote:
> Replacing and scrubbing RAID 5/6 is now supported on Btrfs. Enable it in
> _btrfs_get_profile_configs while making it more generic to also support
> replace missing.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Looks great! Tested with default configs and user-defined configs.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
>  common/rc | 96 ++++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 49 insertions(+), 47 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 610045eab304..3e6fdb6ebcfa 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2748,60 +2748,62 @@ _btrfs_get_profile_configs()
>  		return
>  	fi
>  
> -	# no user specified btrfs profile configs, export the default configs
>  	if [ -z "$BTRFS_PROFILE_CONFIGS" ]; then
> -		# default configs
> -		_btrfs_profile_configs=(
> -			"-m single -d single"
> -			"-m dup -d single"
> -			"-m raid0 -d raid0"
> -			"-m raid1 -d raid0"
> -			"-m raid1 -d raid1"
> -			"-m raid10 -d raid10"
> -			"-m raid5 -d raid5"
> -			"-m raid6 -d raid6"
> +		# Default configurations to test.
> +		local configs=(
> +			"single:single"
> +			"dup:single"
> +			"raid0:raid0"
> +			"raid1:raid0"
> +			"raid1:raid1"
> +			"raid10:raid10"
> +			"raid5:raid5"
> +			"raid6:raid6"
>  		)
> +	else
> +		# User-provided configurations.
> +		local configs=(${BTRFS_PROFILE_CONFIGS[@]})
> +	fi
>  
> -		# remove dup/raid5/raid6 profiles if we're doing device replace
> -		# dup profile indicates only one device being used (SCRATCH_DEV),
> -		# but we don't want to replace SCRATCH_DEV, which will be used in
> -		# _scratch_mount/_check_scratch_fs etc.
> -		# and raid5/raid6 doesn't support replace yet
> +	_btrfs_profile_configs=()
> +	for cfg in "${configs[@]}"; do
> +		local supported=true
> +		local profiles=(${cfg/:/ })
>  		if [ "$1" == "replace" ]; then
> -			_btrfs_profile_configs=(
> -				"-m single -d single"
> -				"-m raid0 -d raid0"
> -				"-m raid1 -d raid0"
> -				"-m raid1 -d raid1"
> -				"-m raid10 -d raid10"
> -				# add these back when raid5/6 is working with replace
> -				#"-m raid5 -d raid5"
> -				#"-m raid6 -d raid6"
> +			# We can't do replace with these profiles because they
> +			# imply only one device ($SCRATCH_DEV), and we need to
> +			# keep $SCRATCH_DEV around for _scratch_mount
> +			# and _check_scratch_fs.
> +			local unsupported=(
> +				"single"
> +				"dup"
>  			)
> +		elif [ "$1" == "replace-missing" ]; then
> +			# We can't replace missing devices with these profiles
> +			# because there isn't enough redundancy.
> +			local unsupported=(
> +				"single"
> +				"dup"
> +				"raid0"
> +			)
> +		else
> +			local unsupported=()
>  		fi
> -		export _btrfs_profile_configs
> -		return
> -	fi
> -
> -	# parse user specified btrfs profile configs
> -	local i=0
> -	local cfg=""
> -	for cfg in $BTRFS_PROFILE_CONFIGS; do
> -		# turn "metadata:data" format to "-m metadata -d data"
> -		# and assign it to _btrfs_profile_configs array
> -		cfg=`echo "$cfg" | sed -e 's/^/-m /' -e 's/:/ -d /'`
> -		_btrfs_profile_configs[$i]="$cfg"
> -		let i=i+1
> -	done
> -
> -	if [ "$1" == "replace" ]; then
> -		if echo ${_btrfs_profile_configs[*]} | grep -q raid[56]; then
> -			_notrun "RAID5/6 doesn't support btrfs device replace yet"
> -		fi
> -		if echo ${_btrfs_profile_configs[*]} | grep -q dup; then
> -			_notrun "Do not set dup profile in btrfs device replace test"
> +		for unsupp in "${unsupported[@]}"; do
> +			if [ "${profiles[0]}" == "$unsupp" -o "${profiles[1]}" == "$unsupp" ]; then
> +			     if [ -z "$BTRFS_PROFILE_CONFIGS" ]; then
> +				     # For the default config, just omit it.
> +				     supported=false
> +			     else
> +				     # For user-provided config, don't run the test.
> +				     _notrun "Profile $unsupp not supported for $1"
> +			     fi
> +			fi
> +		done
> +		if "$supported"; then
> +			_btrfs_profile_configs+=("-m ${profiles[0]} -d ${profiles[1]}")
>  		fi
> -	fi
> +	done
>  	export _btrfs_profile_configs
>  }
>  
> -- 
> 2.4.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
