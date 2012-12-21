Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47937 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2LULCq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 06:02:46 -0500
Message-ID: <50D43B5B.6030302@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 18:35:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs: fix missing write access release in btrfs_ioctl_resize()
References: <50D42998.1010100@cn.fujitsu.com> <50D4387C.5020104@giantdisaster.de>
In-Reply-To: <50D4387C.5020104@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Dec 2012 11:22:52 +0100, Stefan Behrens wrote:
> On Fri, 21 Dec 2012 17:19:20 +0800, Miao Xie wrote:
>> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
>> +		pr_info("btrfs: dev add/delete/balance/replace/resize operation"
>> +			" in progress\n");
>> +		mnt_drop_write_file(file);
> 
> grep and vi cannot do searches spanning multiple lines. That's why I
> created this pr_info() line with more than 80 columns (in accordance
> with Documentation/CodingStyle BTW ("never break user-visible strings")).
> 

You are right. I will update the patch soon.

Thanks
Miao

