Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbbFZOw1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 10:52:27 -0400
Date: Fri, 26 Jun 2015 16:52:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add nbytes output for print-tree and
 reformat inode output
Message-ID: <20150626145225.GZ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434685760-2013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434685760-2013-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 11:49:19AM +0800, Qu Wenruo wrote:
> The original implement doesn't output nbytes in btrfs_inode.
> Add the output and since the output is too long, reformat it to multi
> lines.
> 
> This is very handy to debug related bugs.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
