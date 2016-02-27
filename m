Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbcB0CnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 21:43:19 -0500
Date: Fri, 26 Feb 2016 18:45:34 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160227024533.GB11954@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160227023938.GB5286@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160227023938.GB5286@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 06:39:38PM -0800, Marc MERLIN wrote:
> btrfs-tools 4.4-1
> gargamel:~# uname -r
> 4.4.2-amd64-i915-volpreempt-20160214bc2
> 
> 2 drive array stopped working after a crash/reboot. Check --repair finds nothing wrong with it:
> 
> gargamel:~# btrfs check --repair /dev/mapper/raid0d1
> enabling repair mode
> Checking filesystem on /dev/mapper/raid0d1
> UUID: 01334b81-c0db-4e80-92e4-cac4da867651
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 1201345524312 bytes used err is 0
> total csum bytes: 1165124220
> total tree bytes: 8258322432
> total fs tree bytes: 5574197248
> total extent tree bytes: 1020428288
> btree space waste bytes: 1902023247
> file data blocks allocated: 1193398628352
>  referenced 1209324777472
> gargamel:~# mount /var/local/space
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> [ 8200.511021] BTRFS info (device dm-6): disk space caching is enabled
> [ 8200.533030] BTRFS: failed to read the system array on dm-6
> [ 8200.582097] BTRFS: open_ctree failed

Does 'btrfs dev scan' help?

Thanks,

-liubo

> 
> 
> gargamel:~# btrfs check --repair /dev/mapper/raid0d2
> enabling repair mode
> Checking filesystem on /dev/mapper/raid0d2
> UUID: 01334b81-c0db-4e80-92e4-cac4da867651
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 1201345540696 bytes used err is 0
> total csum bytes: 1165124220
> total tree bytes: 8258338816
> total fs tree bytes: 5574197248
> total extent tree bytes: 1020444672
> btree space waste bytes: 1902039421
> file data blocks allocated: 1193398628352
>  referenced 1209324777472
> gargamel:~# mount /var/local/space
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d1,
> [13373.606737] BTRFS info (device dm-6): disk space caching is enabled
> [13373.628682] BTRFS: failed to read the system array on dm-6
> [13373.672607] BTRFS: open_ctree failed
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
