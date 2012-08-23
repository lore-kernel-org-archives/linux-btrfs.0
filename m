Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:18817 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab2HWOBQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 10:01:16 -0400
Message-ID: <503637AC.7080103@giantdisaster.de>
Date: Thu, 23 Aug 2012 16:01:16 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@inwind.it>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v0 1/4] Add support for sysfs to btrfs.
References: <20120823120505.12203.11658.stgit@venice.bhome> <20120823121242.12203.50365.stgit@venice.bhome>
In-Reply-To: <20120823121242.12203.50365.stgit@venice.bhome>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Aug 2012 14:12:59 +0200, Goffredo Baroncelli wrote:
> Export via sysfs some information about the btrfs devices and
> filesystem.
> ---
>  fs/btrfs/super.c |    4 
>  fs/btrfs/sysfs.c |  933 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/sysfs.h |   31 ++
>  3 files changed, 963 insertions(+), 5 deletions(-)
>  create mode 100644 fs/btrfs/sysfs.h

Hi Goffredo,

The Signed-off-by line is missing, it is mandatory.

[...]
> +struct btrfs_sysfs_fsid {
> +		struct kobject			*kobj;
> +		struct list_head		list;
> +		u8						fsid[BTRFS_FSID_SIZE];
> +};

Tabsize needs to be 8.

> +static struct list_head btrfs_sysfs_device_list;
> +static struct list_head btrfs_sysfs_fs_devices_list;
> +static struct list_head btrfs_sysfs_filesystem_list;
> +static struct list_head btrfs_sysfs_fsid_list;
> +
> +
> +void uuid_unparse( u8 *uuid, char *out ){
> +	static char *i2x = "0123456789abcdef";
> +	static int 	lengths[] = {4,2,2,2,6,0};
> +	int 		i;
> +	
> +	for(i=0; ; i++){
> +		int j;
> +		for(j=0; j < lengths[i] ; j++, uuid++){
> +			*out++ = i2x[*uuid >> 4];
> +			*out++ = i2x[*uuid & 0x0f];
> +		}
> +		if( !lengths[i+1] ){
> +			*out = 0;
> +			break;
> +		}else{
> +			*out++ = '-';
> +		}
> +	}
> +}

All the missing spaces and all the spaces that are too much...
One line contains a trailing TAB character before the end of the line.
A newline is missing before the opening curly bracket of the function body.
An empty line between the 'int j;' and the code is common, like the one
after the 'int i;'.

[more lines deleted...]

Please refer to:
Documentation/SubmittingPatches
Documentation/SubmitChecklist
Documentation/CodingStyle

And apply:
scripts/checkpatch.pl

I did not look at the patch itself after noticing the style issues.
