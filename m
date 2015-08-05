Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbHEQxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 12:53:19 -0400
Date: Wed, 5 Aug 2015 18:52:58 +0200
From: David Sterba <dsterba@suse.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: Cleanup: Remove objectid's init-value in
 create_reloc_inode()
Message-ID: <20150805165258.GE31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
 <3fbb7f3239e285eb7d14b0f3c61944159b91813a.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3fbb7f3239e285eb7d14b0f3c61944159b91813a.1438768766.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 06:00:03PM +0800, Zhao Lei wrote:
> objectid's init-value is not used in any case, remove it.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
