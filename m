Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53423 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdCMQYf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 12:24:35 -0400
Date: Mon, 13 Mar 2017 17:23:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 2/2] btrfs-progs: dump-tree: Also output log root tree
Message-ID: <20170313162356.GM14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170303041345.11760-1-quwenruo@cn.fujitsu.com>
 <20170303041345.11760-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170303041345.11760-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 03, 2017 at 12:13:45PM +0800, Qu Wenruo wrote:
> In btrfs-dump-tree, we output any existing log tree, however we don't
> output the log root tree, which records all root items for log trees.
> 
> This makes it confusing for any one who want to know where the log tree
> comes from.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

What's the base of this patch or is there a patch that I've missed to
apply? This fails on current devel, 4.10, 4.9.1 and I don't see patch
1/2 in my mailbox or on patchwork. Please refresh and resend.
