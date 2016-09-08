Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753220AbcIHG0y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 02:26:54 -0400
Date: Thu, 8 Sep 2016 14:17:56 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: common: Enhance
 _exclude_scratch_mount_option to handle multiple options
Message-ID: <20160908061756.GV27776@eguan.usersys.redhat.com>
References: <20160908025221.11618-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160908025221.11618-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 10:52:21AM +0800, Qu Wenruo wrote:
> Enhance _exclude_scratch_mount_option() function to normalize mount
> options.
> Now it can understand and extract real mount option from string like
> "-o opt1,opt2 -oopt3".
> 
> And now we do word grep to handle mount options like noinode_cache and
> inode_cache.
> 
> Finally, allow it to accept multiple options at the same time.
> No need for multiple _exclude_scratch_mount_option lines now
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> changelog:
> v2:
>    Don't introduce new 'fstype' parameter, suggested by Dave and Eryu.
>    Use easier grep -w method, suggested by Dave and Eryu.
> ---
>  common/rc      | 22 ++++++++++++++++++----
>  tests/ext4/271 |  6 ++----
>  tests/xfs/134  |  3 +--
>  3 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 04039a4..23c007a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3183,12 +3183,26 @@ _require_cloner()
>  		_notrun "cloner binary not present at $CLONER_PROG"
>  }
>  
> -# skip test if MKFS_OPTIONS contains the given string
> +# Normalize mount options from global $MOUNT_OPTIONS
> +# Convert options like "-o opt1,opt2 -oopt3" to
> +# "opt1 opt2 opt3"
> +_normalize_mount_options()
> +{
> +	echo $MOUNT_OPTIONS | sed -n 's/-o\s*\(\S*\)/\1/gp' |\
> +		sed 's/,/ /g'
> +}
> +
> +# skip test if MOUNT_OPTIONS contains the given string

Make "string" plural? Because it accepts multiple arguments now :)

>  _exclude_scratch_mount_option()
>  {
> -	if echo $MOUNT_OPTIONS | grep -q "$1"; then
> -		_notrun "mount option \"$1\" not allowed in this test"
> -	fi
> +	mnt_opts=$(_normalize_mount_options)
> +
> +	while [ $# -gt 1 ]; do

"-gt" should be "-ge" or "-gt 0", otherwise the last mount option in
arguments is not checked (no check is done if there's only one option).

I can fix them at commit time if there's no other review comments.

Thanks,
Eryu
