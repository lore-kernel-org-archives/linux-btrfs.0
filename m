Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36503 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754195AbdEIRoV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:44:21 -0400
Date: Tue, 9 May 2017 19:44:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: print-tree: Add leaf flags and backref
 revision output
Message-ID: <20170509174413.GJ5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170508073810.2811-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170508073810.2811-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 08, 2017 at 03:38:10PM +0800, Qu Wenruo wrote:
> Btrfs header has a u64 member flags, whose lowest 56 bits are for header
> flags like WRITTEN and RELOC.
> And its highest 8 bits are for backref revision.
> 
> Manually checking btrfs_header_flags() will be a pain, so add such leaf
> flags and backref revision output for print-tree.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
