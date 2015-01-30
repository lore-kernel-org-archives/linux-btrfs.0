Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbbA3TLp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 14:11:45 -0500
Date: Fri, 30 Jan 2015 20:11:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] vfs: Add sb_want_write() function to get vfsmount
 from a given sb.
Message-ID: <20150130191143.GU3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-7-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-7-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:51PM +0800, Qu Wenruo wrote:
> So introduce new sb_want_write() to do the protection agains a super
> block, which acts much like mnt_want_write() but will return success if
> the super block is read-write.

I like the new interface and think that it could be used in the per-fs
background threads instead of the raw MS_RDONLY checks. From a brief
look it may not apply everywhere as sb_start_write could wait, but there
are a few candidates.

> 
> Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
> Signed-off-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
