Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbcEaQpU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 12:45:20 -0400
Date: Tue, 31 May 2016 18:44:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Add support to rollback new
 convert image
Message-ID: <20160531164441.GK29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160531024600.11382-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160531024600.11382-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 10:46:00AM +0800, Qu Wenruo wrote:
> For new btrfs-convert, it's less restrict for metadata chunk allocation.
> While the may_rollback() function is still following the restrict 1:1
> mapping check for all chunks, it will not allow some new convert image
> to be rolled back.
> 
> Add new per extent check for new convert to allow it to be rolled back.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied with some minor adjustments, convert tests pass, thanks.
