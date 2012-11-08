Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:37521 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab2KHXeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 18:34:10 -0500
Message-ID: <509C4160.2050900@csamuel.org>
Date: Fri, 09 Nov 2012 10:33:52 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <sensille@gmx.net>,
        wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Btrfs-progs: disable qgroupid 0 for quota_tree
References: <509B8053.3080509@cn.fujitsu.com> <509B8197.2090601@cn.fujitsu.com>
In-Reply-To: <509B8197.2090601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/12 20:55, Miao Xie wrote:

> In kernel, qgroupid 0 is a special number when we run the quota group
> limit command.
> 
> So, we should not be able to create a quota group whose id is 0,
> otherwise the kernel can't deal with it. Fix it.

This is probably a stupid question - but if its not meant to be possible
to create such a thing shouldn't this be fixed in the kernel (as well as
here) to reject attempts from user space to create it?

Otherwise it's possible for a non-aware program (or a user who is
playing) to still create it.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
