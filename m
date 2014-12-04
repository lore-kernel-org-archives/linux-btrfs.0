Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbaLDRfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 12:35:46 -0500
Date: Thu, 4 Dec 2014 18:35:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs:fsck: Recover btree with some corrupted
 leaf/node.
Message-ID: <20141204173546.GI9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1417661565-14595-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417661565-14595-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 04, 2014 at 10:52:44AM +0800, Qu Wenruo wrote:
> +	trans = btrfs_start_transaction(root, -1);

What does '-1' mean here? I've never seen this before, just curious.
