Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832AbaJ3OdN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 10:33:13 -0400
Date: Thu, 30 Oct 2014 15:33:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
Message-ID: <20141030143310.GA21354@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 08:51:09AM +0800, Anand Jain wrote:
> --- a/volumes.c
> +++ b/volumes.c
> @@ -30,6 +30,7 @@
>  #include "print-tree.h"
>  #include "volumes.h"
>  #include "math.h"
> +#include "utils.h"
>  
>  struct stripe {
>  	struct btrfs_device *dev;
> @@ -1533,6 +1534,30 @@ btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
>  	return NULL;
>  }
>  
> +/*
> + * Register all devices in the fs_uuid list created in the user
> + * space. Ensure btrfs_scan_lblkid() is called before this func.
> + */
> +int btrfs_register_all_devices(void)

I think this belongs to utils.c, btrfs_register_one_device is also there
and it is an API funcion for the commands. You can use
btrfs_scanned_uuids() to get to the fs_uuids variable that's locally
defined in volumes.c .
