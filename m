Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbeDIOdt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:33:49 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 375B2AE21
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 14:33:48 +0000 (UTC)
Date: Mon, 9 Apr 2018 16:31:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: check: Skip data csum verification for
 metadata dump
Message-ID: <20180409143118.GT8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180403053947.5908-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180403053947.5908-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 01:39:46PM +0800, Qu Wenruo wrote:
> For metadata dump (fs restored by btrfs-image), since no data is
> restored check sum verification will definitely report error.
> 
> Add such check in check_csums() and prompt for user.
> 
> Issue: #103
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
