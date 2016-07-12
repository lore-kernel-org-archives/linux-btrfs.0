Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbcGLQLw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 12:11:52 -0400
Date: Tue, 12 Jul 2016 18:12:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix free space calculation in dump_space_info()
Message-ID: <20160712161201.GF10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160711113004.4896-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160711113004.4896-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 07:30:04PM +0800, Wang Xiaoguang wrote:
> In btrfs, btrfs_space_info's bytes_may_use is treated as fs used
> space, as what we do in reserve_metadata_bytes() or
> btrfs_alloc_data_chunk_ondemand(), so in dump_space_info(), when
> calculating free space, we should also minus btrfs_space_info's
> bytes_may_use.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
