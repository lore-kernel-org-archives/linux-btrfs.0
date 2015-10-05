Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbJECeX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Oct 2015 22:34:23 -0400
Message-ID: <5611E169.1060902@oracle.com>
Date: Mon, 05 Oct 2015 10:33:13 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: sam tygier <samtygier@yahoo.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: Check metadata redundancy on balance
References: <muotgb$4mf$1@ger.gmane.org>
In-Reply-To: <muotgb$4mf$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Sam,

On 10/03/2015 11:50 PM, sam tygier wrote:
> Currently BTRFS allows you to make bad choices of data and
> metadata levels. For example -d raid1 -m raid0 means you can
> only use half your total disk space, but will loose everything
> if 1 disk fails. It should give a warning in these cases.

  Nice test case. however the way we calculate the impact of
  lost device would be per chunk, as in the upcoming patch -set.

     PATCH 1/5] btrfs: Introduce a new function to check if all chunks a 
OK for degraded mount

  The above patch-set should catch the bug here. Would you be able to
  confirm if this patch is still needed Or apply your patch on top of
  it ?

Thanks, Anand


> This patch is a follow up to
> [PATCH v2] btrfs-progs: check metadata redundancy
> in order to cover the case of using balance to convert to such
> a set of raid levels.
>
> A simple example to hit this is to create a single device fs,
> which will default to single:dup, then to add a second device and
> attempt to convert to raid1 with the command
> btrfs balance start -dconvert=raid1  /mnt
> this will result in a filesystem with raid1:dup, which will not
> survive the loss of one drive. I personally don't see why the tools
> should allow this, but in the previous thread a warning was
> considered sufficient.
>
> Changes in v2
> Use btrfs_get_num_tolerated_disk_barrier_failures()
>
> Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>
>
> From: Sam Tygier <samtygier@yahoo.co.uk>
> Date: Sat, 3 Oct 2015 16:43:48 +0100
> Subject: [PATCH] Btrfs: Check metadata redundancy on balance
>
> When converting a filesystem via balance check that metadata mode
> is at least as redundant as the data mode. For example give warning
> when:
> -dconvert=raid1 -mconvert=single
> ---
>   fs/btrfs/volumes.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6fc73586..40247e9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3584,6 +3584,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   		}
>   	} while (read_seqretry(&fs_info->profiles_lock, seq));
>
> +	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
> +		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
> +		btrfs_info(fs_info,
> +			"Warning: metatdata has lower redundancy than data\n");
> +	}
> +
>   	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>   		fs_info->num_tolerated_disk_barrier_failures = min(
>   			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
>
