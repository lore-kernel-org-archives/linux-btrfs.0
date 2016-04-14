Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:43322 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcDNJWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 05:22:54 -0400
Date: Thu, 14 Apr 2016 12:22:47 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 00/13] Introduce device state 'failed', spare device
 and auto replace
Message-ID: <20160414092246.GB17024@jeknote.loshitsa1.net>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
 <20160413212143.GA28202@jeknote.loshitsa1.net>
 <570F5897.6090701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <570F5897.6090701@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 04:45:11PM +0800, Anand Jain wrote:
> 
> 
> 
> Thanks for the report ! more below..
> 
> 
>  You may use simpler devmgt tool, https://github.com/asj/devmgt

Thanks, will try.

> 
>  You are failing the replace-target, presumably when the replace is
>  still running, however note that this patch-set does not fail the
>  replace-target for errors (as of now I have no idea how to do that
>  without leading to a messy situation), and so it would follow the
>  original code as without this patch.
>  Next, originally with-out this patch-set we won't close any device
>  for errors. So when you delete the device at the block-layer and
>  re-attach (scan) most probably you are having a newer device path
>  to the block device. (which kind of defeats the idea of testing
>  an intermittently disappearing device), so I doubt, if the test
>  case is reliable,  and above panic is btrfs related and if its
>  this patch-set related.

No, It is fixed by my latest patch (about of s_bdev field in
superblock). Actual sequence which leads to oops is:
1) FS is mounted, s_bdev is NULL
2) failed device is closed, s_bdev untouched
3) missing device is replaced, s_bdev is set to non-NULL – bdev of
the replaced device
4) at second device closing, s_bdev is "changed" to first device from
the device list but it is... some device because closed dev still
didn't delete from the list!
5) after device closing, s_bdev points to invalid bdev.
6) umount -> sync_filesystem() -> sync_blokdev(s_bdev) -> OOPS.


-- 
Yauhen Kharuzhy
