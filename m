Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbbHaPf1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 11:35:27 -0400
Date: Mon, 31 Aug 2015 17:34:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs-progs: Simplify all-subvolumn-clean condition
 for wait_for_subvolume_cleaning
Message-ID: <20150831153448.GA11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
 <26cc4d36b398b1bb582532db5cd8e65019e1e812.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <26cc4d36b398b1bb582532db5cd8e65019e1e812.1440597812.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:03:39PM +0800, Zhao Lei wrote:
> Instead of using a dirty-subvolumn-counter in old code, this patch
> turn to use a simple and direct way:
>   If (not dirty-subvolumn found in current loop) {
>       return all_clean;
>   }
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied with minor modifications, thanks.
