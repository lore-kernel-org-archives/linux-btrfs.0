Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37498 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2KLCU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 21:20:58 -0500
Message-ID: <50A05D18.7080503@cn.fujitsu.com>
Date: Mon, 12 Nov 2012 10:21:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <sensille@gmx.net>,
        wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Btrfs-progs: disable qgroupid 0 for quota_tree
References: <509B8053.3080509@cn.fujitsu.com> <509B8197.2090601@cn.fujitsu.com> <509C4160.2050900@csamuel.org>
In-Reply-To: <509C4160.2050900@csamuel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 09 Nov 2012 10:33:52 +1100, Chris Samuel wrote:
> On 08/11/12 20:55, Miao Xie wrote:
> 
>> In kernel, qgroupid 0 is a special number when we run the quota group
>> limit command.
>>
>> So, we should not be able to create a quota group whose id is 0,
>> otherwise the kernel can't deal with it. Fix it.
> 
> This is probably a stupid question - but if its not meant to be possible
> to create such a thing shouldn't this be fixed in the kernel (as well as
> here) to reject attempts from user space to create it?
> 
> Otherwise it's possible for a non-aware program (or a user who is
> playing) to still create it.

Right. It also should be fixed in the kernel side, the patch is coming.

But since we know which number is valid or not, it is better that we also check
the arguments in the user tool before they are passed into the kernel. So, we
can avoid trapping into the kernel, which will waste time, and output the error
information as soon as possible.

Thanks
Miao
