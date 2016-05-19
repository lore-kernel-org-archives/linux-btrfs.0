Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbcESMYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 08:24:32 -0400
Date: Thu, 19 May 2016 14:24:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Subject: Re: [PATCH] btrfs-progs: Enhance tree block check by checking empty
 leaf or node
Message-ID: <20160519122403.GD29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463647475-22102-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463647475-22102-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 04:44:35PM +0800, Qu Wenruo wrote:
> For btrfs, it's possible to have empty leaf, but empty node is not
> possible.
> 
> Add check for empty node for tree blocks.
> 
> Suggested-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
