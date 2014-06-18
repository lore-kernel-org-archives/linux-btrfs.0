Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:40774 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaFRFHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 01:07:09 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id DC8C13EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 14:07:07 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E6744AC059E
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 14:07:06 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 866731DB803B
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 14:07:06 +0900 (JST)
Message-ID: <53A11E62.6070308@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 14:06:42 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Adam Buchbinder <abuchbinder@google.com>, <linux-btrfs@vger.kernel.org>
CC: <dave@jikos.cz>
Subject: Re: [PATCH] Fix a use-after-free in the volumes code.
References: <1402703036-2447-1-git-send-email-abuchbinder@google.com>
In-Reply-To: <1402703036-2447-1-git-send-email-abuchbinder@google.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Adam,

(2014/06/14 8:43), Adam Buchbinder wrote:
> When a struct btrfs_fs_devices was being torn down by
> btrfs_close_devices(), there was an invalidated pointer in the global
> list fs_uuids which still pointed to it; if a device was closed and
> then reopened (which btrfs-convert does), freed memory would be
> accessed.

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

I confirmed ...

 - btrfs_fs_devices is linked to fs_uuids in device_list_add().
 - However, there is no list_del(btrfs_fs_devices) from
   fs_uuids at all.
 - There is at least one use-after-free of btrfs_fs_devices
   as you said (btrfs-convert).

P.S.
I suggest you to add "btrfs-progs: " or "btrfs:" tag to mail subject
from the next time.

Thanks,
Satoru

> 
> This was found using ThreadSanitizer (pretty much doing what
> AddressSanitizer would, but not exiting after the first failure).
> To reproduce, build with -fsanitize=thread and run 'make test'.
> Representative output is below.
> 
> This change makes the current tests TSan-clean.
> 
> WARNING: ThreadSanitizer: heap-use-after-free (pid=29161)
>    Read of size 8 at 0x7d180000eee0 by main thread:
>      #0 memcmp ??:0
>      #1 find_fsid .../volumes.c:81
>      #2 device_list_add .../volumes.c:95
>      #3 btrfs_scan_one_device .../volumes.c:259
>      #4 btrfs_scan_fs_devices .../disk-io.c:1002
>      #5 __open_ctree_fd .../disk-io.c:1090
>      #6 open_ctree_fd .../disk-io.c:1191
>      #7 do_convert .../btrfs-convert.c:2317
>      #8 main .../btrfs-convert.c:2745
> 
>    Previous write of size 8 at 0x7d180000eee0 by main thread:
>      #0 free ??:0
>      #1 btrfs_close_devices .../volumes.c:191
>      #2 close_ctree .../disk-io.c:1401
>      #3 do_convert .../btrfs-convert.c:2300
>      #4 main .../btrfs-convert.c:2745
> 
>    Location is heap block of size 96 at 0x7d180000eee0 allocated by main thread:
>      #0 calloc ??:0 (exe+0x00000002acc6)
>      #1 device_list_add .../volumes.c:97
>      #2 btrfs_scan_one_device .../volumes.c:259
>      #3 btrfs_scan_fs_devices .../disk-io.c:1002
>      #4 __open_ctree_fd .../disk-io.c:1090
>      #5 open_ctree_fd .../disk-io.c:1191
>      #6 do_convert .../btrfs-convert.c:2256
>      #7 main .../btrfs-convert.c:2745
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> ---
>   volumes.c | 1 +
>   volumes.h | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/volumes.c b/volumes.c
> index a61928c..36f6050 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -188,6 +188,7 @@ again:
>   		goto again;
>   	}
>   
> +	list_del(&fs_devices->list);
>   	free(fs_devices);
>   	return 0;
>   }
> diff --git a/volumes.h b/volumes.h
> index b1ff3d0..2e960b5 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -67,7 +67,7 @@ struct btrfs_device {
>   struct btrfs_fs_devices {
>   	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
>   
> -	/* the device with this id has the most recent coyp of the super */
> +	/* the device with this id has the most recent copy of the super */
>   	u64 latest_devid;
>   	u64 latest_trans;
>   	u64 lowest_devid;
> 

