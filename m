Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbcGDLri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 07:47:38 -0400
Date: Mon, 4 Jul 2016 13:48:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: convert: Fix a bug leads to
 discontinuous extents
Message-ID: <20160704114802.GC13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160627075011.24330-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160627075011.24330-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 03:50:10PM +0800, Qu Wenruo wrote:
> Btrfs_record_file_extent() will split extents using max extent size(128M).
> It works well for real file extents, but not that well for large
> hole extent, as hole doesn't have extent size limit.
> 
> In that case, it will only insert one 128M hole, and skip the rest,
> leading to discontinuous extent error for converted btrfs.
> 
> Fix it by not splitting hole extents.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
