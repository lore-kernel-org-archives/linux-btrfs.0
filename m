Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36344 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbbE2UDL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 16:03:11 -0400
Received: by pacux9 with SMTP id ux9so25877753pac.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 13:03:10 -0700 (PDT)
Date: Fri, 29 May 2015 13:03:06 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: Separate scrub_blocked_if_needed() to
 scrub_pause_on/off()
Message-ID: <20150529200306.GA13244@mew.dhcp4.washington.edu>
References: <5c5c914dad20c018cfe74174827219c418839f39.1432900529.git.zhaolei@cn.fujitsu.com>
 <db592d7da3170d0b43e66b146be70ae494a44760.1432900529.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <db592d7da3170d0b43e66b146be70ae494a44760.1432900529.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 29, 2015 at 07:55:33PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> It can reduce current duplicated code which is similar to
> scrub_blocked_if_needed() but can not call it because little
> different.
> It also used by my next patch which is in same case.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reviewed-by: Omar Sandoval <osandov@osandov.com>

-- 
Omar
