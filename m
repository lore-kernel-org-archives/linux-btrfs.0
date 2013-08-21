Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49829 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3HUN6l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 09:58:41 -0400
Message-ID: <5214C78C.3030001@giantdisaster.de>
Date: Wed, 21 Aug 2013 15:58:36 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_CHECK_DEV_EXCL_OPS ioctl to
 check dev excl op
References: <1377090643-23658-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1377090643-23658-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 21 Aug 2013 21:10:42 +0800, Anand Jain wrote:
> This patch provides an ioctl to check if the FS is performing
> any device exclusive operations like device add remove balance
> etc. Basically any operation which will set
> fs_info->mutually_exclusive_operation_running to true
> 
> This will be necessary for any user cli which has to know
> the state before putting long running commands to background.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c           |   10 ++++++++++
>  include/uapi/linux/btrfs.h |    1 +
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 89f346c..3544a90 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4420,6 +4420,14 @@ out_unlock:
>  	return ret;
>  }
>  
> +static int btrfs_ioctl_check_dev_excl_op(struct btrfs_root *root,
> +		void __user *arg)
> +{
> +	if (atomic_read(&root->fs_info->mutually_exclusive_operation_running))
> +		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> +	return 0;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -4532,6 +4540,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_set_fslabel(file, argp);
>  	case BTRFS_IOC_FILE_EXTENT_SAME:
>  		return btrfs_ioctl_file_extent_same(file, argp);
> +	case BTRFS_IOC_CHECK_DEV_EXCL_OPS:
> +		return btrfs_ioctl_check_dev_excl_op(root, NULL);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 90d7bd9..a4fa6eb 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -606,5 +606,6 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  				    struct btrfs_ioctl_dev_replace_args)
>  #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
>  					 struct btrfs_ioctl_same_args)
> +#define BTRFS_IOC_CHECK_DEV_EXCL_OPS _IO(BTRFS_IOCTL_MAGIC, 56)
>  
>  #endif /* _UAPI_LINUX_BTRFS_H */
> 

IMHO this is just a workaround for a design flaw.

Now it is like this (in the replace CLI without the "do not background"
option):
1. in user mode, check that the ioctl will succeed, exit with failure if
the checks fail
2. fork
3. exit(0) the parent
4. the backgrounded child executes the ioctl, the result is _ignored_
5. the user _has to_ check the status (progress, completion, errors) by
calling 'btrfs replace status' which can optionally block until the
replace procedure is finished, or optionally periodically print the
status. The exit value of 'btrfs replace status' is set depending on
whether there had been errors.

Step #1 is incomplete and can never be complete due to race conditions
and because the checks in the kernel could be enhanced without updating
the progs. Your patch is trying to improve step #1, to keep up with the
checks in the kernel code.

With the "do not background" option for btrfs replace it looks like this:
1. check that the ioctl will succeed (just because the code is shared
with the case that the "do not background" option is not set)
2. execute the ioctl, the result is used to generate error messages and
to build the exit code, the process does not terminate before the
procedure is finished
3. the user _can_ check the status (progress, completion, errors) by
calling 'btrfs replace status'

I'd prefer it like this in both cases:
1. execute the ioctl (don't check anything in user mode before), set a
flag whether the "do not background" option is set
2. in the kernel code inside the ioctl, perform all checks until there
is no more regular reason to fail
3. in case of errors, return from the ioctl with an error code
4. if backgrounding was requested, return from the ioctl indicating that
all checks had succeeded
5. if the ioctl failed, print an error message and set the exit value
accordingly
6. if the ioctl succeeded and backgrounding was requested, background in
user mode and call the ioctl again, this time with the "do not
background" option

This way we would still have the issue with the possible race, but at
least the checks would be done only in one place. And the additional
ioctl(CHECK_DEV_EXCL_OPS) would be avoided.

