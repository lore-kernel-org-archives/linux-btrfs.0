Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752841AbeAaPJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:09:25 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2D956ACCD
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 15:09:24 +0000 (UTC)
Date: Wed, 31 Jan 2018 16:07:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: volumes: Cleanup stripe size calculation
Message-ID: <20180131150712.GC18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180131061634.17383-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180131061634.17383-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 02:16:34PM +0800, Qu Wenruo wrote:
> Cleanup the following things:
> 1) open coded SZ_16M round up
> 2) use min() to replace open-coded size comparison
> 3) code style
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to next, thanks.
