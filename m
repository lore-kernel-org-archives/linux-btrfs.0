Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18515 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab3H2CnS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 22:43:18 -0400
Date: Thu, 29 Aug 2013 10:43:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: lilofile <lilofile@aliyun.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: bug
Message-ID: <20130829024304.GA22790@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <7c55ea3f-bb6d-4e77-8d2f-6368b437ed6a@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7c55ea3f-bb6d-4e77-8d2f-6368b437ed6a@aliyun.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 10:34:00AM +0800, lilofile wrote:
>  I made a btrfs on five disks using RAID5 (-d raid5 for mount option). When a power failure occurs, I can not remount btrfs after my system reboots. Dmesg for remount is presented as following:
>  
> [  192.713953] bio: create slab <bio-1> at 1
> [  192.716230] Btrfs loaded
> [  192.717177] device fsid a0dff7ea-9354-43fd-8516-0e17f370991d devid 1 transid 6 /dev/sdb
> [  192.717712] btrfs: disk space caching is enabled
> [  192.720572] btrfs: failed to read the system array on sdb
> [  192.723398] btrfs: open_ctree failed
>  
> linux md raid5 have resync , the test seems btrfs raid5 have not resync,how fix the bug?

Have you tried 'btrfs device scan' before mounting it?

-liubo
