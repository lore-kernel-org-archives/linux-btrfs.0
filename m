Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdK1Pit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:38:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5DFF5AE6F
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 15:38:48 +0000 (UTC)
Date: Tue, 28 Nov 2017 16:36:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 4/7] btrfs-progs: mkfs/rootdir: Introduce function to get
 end position of last device extent
Message-ID: <20171128153651.GR3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020015907.25430-1-wqu@suse.com>
 <20171020015907.25430-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020015907.25430-5-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:59:04AM +0800, Qu Wenruo wrote:
> Useful for later 'mkfs.btrfs --rootdir' shrink support.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
