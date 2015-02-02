Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbbBBS1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Feb 2015 13:27:47 -0500
Date: Mon, 2 Feb 2015 19:27:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs-progs: read_tree_block() and
 read_node_slot() cleanup.
Message-ID: <20150202182745.GD24227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422411175-28039-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422411175-28039-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 28, 2015 at 10:12:55AM +0800, Qu Wenruo wrote:
> Allow read_tree_block() and read_node_slot() to return error pointer.
> This should help caller to get more specified error number.
> 
> For existing callers, change (!eb) judgmentt to
> (!extent_buffer_uptodate(eb)) to keep the compatibility, and for caller
> missing the check, use PTR_ERR(eb) if possible.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied to 3.19, thanks.
