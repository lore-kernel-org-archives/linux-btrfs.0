Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbbHYRFF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:05:05 -0400
Date: Tue, 25 Aug 2015 19:04:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, theosib@gmail.com
Subject: Re: [PATCH 2/2] btrfs-progs: Use existing facility to replace
 read_data_extent function
Message-ID: <20150825170429.GO10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1440127287-21368-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440127287-21368-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 11:21:27AM +0800, Qu Wenruo wrote:
> Function read_data_extent() in btrfs-image.c is using manual-and-read
> codes.
> Replace it with existing read_extent_data() to reduce duplication.
> 
> Also, now we can use other mirror to try our best to do the dump, just
> like read_tree_block().
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
