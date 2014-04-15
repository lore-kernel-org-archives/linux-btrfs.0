Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaDOQzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 12:55:17 -0400
Date: Tue, 15 Apr 2014 18:55:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: Add btrfs wiki reference to man pages.
Message-ID: <20140415165515.GY29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1397545492-3054-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397545492-3054-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 03:04:51PM +0800, Qu Wenruo wrote:
> Add btrfs wiki page reference to btrfs-check/btrfsck, btrfs-restore and
> btrfs-device as supplement.

I'd rather avoid any references to 'btrfsck', it's been deprecated and
'btrfs check' should be used, thouth I'm sure there are enough people
used to 'btrfsck' and this will take time before we can drop it
completely.

I'll add this patch as-is for now, but before the new documentation is
released, at least the deprecatio notice should be there.
