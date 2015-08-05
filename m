Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbbHEQ6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 12:58:17 -0400
Date: Wed, 5 Aug 2015 18:57:56 +0200
From: David Sterba <dsterba@suse.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Cleanup: Remove chunk_objectid argument from
 btrfs_relocate_chunk()
Message-ID: <20150805165756.GF31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
 <c99521398156d533c225f99a12b9dbd76e84bda1.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c99521398156d533c225f99a12b9dbd76e84bda1.1438768766.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 06:00:04PM +0800, Zhao Lei wrote:
> Remove chunk_objectid argument from btrfs_relocate_chunk() because
> it is not necessary, it can also cleanup some code in caller for
> prepare its value.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
