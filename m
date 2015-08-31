Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbbHaPVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 11:21:16 -0400
Date: Mon, 31 Aug 2015 17:20:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: Fix wrong return value of
 wait_for_subvolume_cleaning()
Message-ID: <20150831152036.GY11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
 <75136f5acd2273246f1f240505a62de222372084.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <75136f5acd2273246f1f240505a62de222372084.1440597812.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:03:38PM +0800, Zhao Lei wrote:
> Reproduce:
>  # btrfs subvolume sync /mnt/btrfs
>  Subvolume id 323 is gone
>  # echo $?
>  1
>  #
> 
> Reason:
>  wait_for_subvolume_cleaning() return !0 in right case, because
>  value of ret is set to "is subvolume clean" state before return.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
