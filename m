Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbaGXNZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:25:55 -0400
Date: Thu, 24 Jul 2014 15:25:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/10] Btrfs: fix wrong generation check of super block
 on a seed device
Message-ID: <20140724132554.GC1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
 <1406173035-29478-4-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406173035-29478-4-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:37:09AM +0800, Miao Xie wrote:
> The super block generation of the seed devices is not the same as the
> filesystem which sprouted from them because we don't update the super
> block on the seed devices when we change that new filesystem. So we
> should not use the generation of that new filesystem to check the super
> block generation on the seed devices, Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Good catch.

Reviewed-by: David Sterba <dsterba@suse.cz>
