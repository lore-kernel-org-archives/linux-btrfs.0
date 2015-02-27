Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbbB0QbC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 11:31:02 -0500
Date: Fri, 27 Feb 2015 17:31:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Make csum tree rebuild works with extent
 tree rebuild.
Message-ID: <20150227163100.GF8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422251582-23575-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422251582-23575-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 26, 2015 at 01:53:02PM +0800, Qu Wenruo wrote:
> Before this patch, csum tree rebuild will not work with extent tree
> rebuild, since extent tree rebuild will only build up basic block
> groups, but csum tree rebuild needs data extents to rebuild.
> So if one use btrfsck with --init-csum-tree and --init-extent-tree, csum
> tree will be empty and tons of "missing csum" error will be outputted.
> 
> This patch allows csum tree rebuild get its data from fs/subvol trees
> using regular file extents(which is also the only one using csum tree
> currently)
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
