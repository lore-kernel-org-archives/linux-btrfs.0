Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbcEQMvT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 08:51:19 -0400
Date: Tue, 17 May 2016 14:50:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/4] btrfs-progs: ctree: return earlier for
 btrfs_previous_item
Message-ID: <20160517125051.GL511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463456878-17550-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463456878-17550-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 11:47:56AM +0800, Qu Wenruo wrote:
> Btrfs_previous_item() has a parameter to specify minimal objectid to
> return.
> 
> But surprisingly it doesn't use it at all.
> Although that's OK, but it would take years long for large tree, so
> return it earlier.

This makes it closer to the kernel implementation, but still not equal,
there are some more shortcuts. Can you please port them as well? This
patch is independent of the rest so I'd take it separatelly.
