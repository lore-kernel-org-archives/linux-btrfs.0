Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbcGYPhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 11:37:19 -0400
Date: Mon, 25 Jul 2016 17:37:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
Message-ID: <20160725153705.GC30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2016 at 03:19:59PM +0800, Qu Wenruo wrote:
> This patch will disable clone detection of send.

Making that unconditional is not the right way. We do have the send
operation flags in place so if you really think there's a need for
disabling the clones, let's add a flag for that (BTRFS_SEND_FLAG_*).
