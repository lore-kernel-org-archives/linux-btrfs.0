Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbcFAN6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:58:04 -0400
Date: Wed, 1 Jun 2016 15:57:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: corrupt-block: Add support to corrupt
 extent for skinny metadata
Message-ID: <20160601135725.GB29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464230162-7657-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464230162-7657-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 10:36:02AM +0800, Qu Wenruo wrote:
> For skinny metadata case, btrfs-corrupt-block can't corrupt a metadata
> extent due to the type judgment doesn't include BTRFS_METADATA_ITEM_KEY.
> 
> Fix it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
