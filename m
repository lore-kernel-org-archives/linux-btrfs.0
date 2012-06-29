Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50552 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F2Kgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 06:36:47 -0400
Received: by eeit10 with SMTP id t10so1313514eei.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 03:36:46 -0700 (PDT)
Date: Fri, 29 Jun 2012 13:36:43 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs-progs: make get default report correctly
Message-ID: <20120629103643.GB1877@zambezi.lan>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 06:00:37PM +0800, Liu Bo wrote:
> We have both set-default and get-default, but actually our get-default
> does not show which one is the default one.
> 
> This patch plus the kernel side patch fix this.

Are you referring to the fact that get-default in Chris' btrfs-progs
master lists all subvolumes instead of showing the default one?  If so,
I fixed that problem a while ago, patch is in Hugo's integration branch.

Thanks,

		Ilya
