Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:15621 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2LUKWx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 05:22:53 -0500
Message-ID: <50D4387C.5020104@giantdisaster.de>
Date: Fri, 21 Dec 2012 11:22:52 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs: fix missing write access release in btrfs_ioctl_resize()
References: <50D42998.1010100@cn.fujitsu.com>
In-Reply-To: <50D42998.1010100@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Dec 2012 17:19:20 +0800, Miao Xie wrote:
> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
> +		pr_info("btrfs: dev add/delete/balance/replace/resize operation"
> +			" in progress\n");
> +		mnt_drop_write_file(file);

grep and vi cannot do searches spanning multiple lines. That's why I
created this pr_info() line with more than 80 columns (in accordance
with Documentation/CodingStyle BTW ("never break user-visible strings")).

