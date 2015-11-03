Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbbKCMCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 07:02:20 -0500
Date: Tue, 3 Nov 2015 13:00:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: output device list in sorted order
Message-ID: <20151103120050.GJ13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0e4f0ae269fdaf041e1f53d2460e92ac3f926b88.1446548572.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0e4f0ae269fdaf041e1f53d2460e92ac3f926b88.1446548572.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 03, 2015 at 07:03:00PM +0800, Zhao Lei wrote:
> list_for_each_entry_reverse() in current code can not output
> devices in sorted order, because the sequence are broken in
> btrfs_alloc_chunk().
> 
> We can use list_sort() instead.
> 
> Before patch:
>  # mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf
>  ...
>  Number of devices:  3
>  Devices:
>     ID        SIZE  PATH
>      3     2.60GiB  /dev/vdf
>      1     2.60GiB  /dev/vdd
>      2     2.60GiB  /dev/vde
> 
> After patch:
>  # mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf
>  ...
>  Number of devices:  3
>  Devices:
>     ID        SIZE  PATH
>      1     2.60GiB  /dev/vdd
>      2     2.60GiB  /dev/vde
>      3     2.60GiB  /dev/vdf
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Nice, thanks.
