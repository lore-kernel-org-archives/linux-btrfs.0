Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbCWXwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 19:52:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 33B91ADBF
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 23:52:00 +0000 (UTC)
Date: Tue, 24 Mar 2015 00:51:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: cleanup orphans while looking up default subvolume
Message-ID: <20150323235159.GR20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <550C60A1.9000708@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550C60A1.9000708@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 02:02:09PM -0400, Jeff Mahoney wrote:
> Orphans in the fs tree are cleaned up via open_ctree and subvolume
> orphans are cleaned via btrfs_lookup_dentry -- except when a default
> subvolume is in use.  The name for the default subvolume uses a manual
> lookup that doesn't trigger orphan cleanup and needs to trigger it
> manually as well. This doesn't apply to the remount case since the
> subvolumes are cleaned up by walking the root radix tree.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
