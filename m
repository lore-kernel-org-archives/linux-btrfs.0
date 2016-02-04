Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbcBDOZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 09:25:25 -0500
Date: Thu, 4 Feb 2016 15:25:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: fix lockdep deadlock warning due to
 dev_replace
Message-ID: <20160204142508.GE9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
 <1437122959-23376-2-git-send-email-bo.li.liu@oracle.com>
 <56B30F79.4060907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56B30F79.4060907@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 04, 2016 at 04:44:41PM +0800, Qu Wenruo wrote:
> Hi
> 
> Will this patch get merged in next merge windows?
> (Although it should be merged in 4.5 merge window).
> 
> I also encountered the same warning, but with fsstress + some sync calls.

Besides a ping, you can help to get this patch merged by testing or
reviewing it.
