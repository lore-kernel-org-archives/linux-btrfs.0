Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbeGSKJY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 06:09:24 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 32D25AD14
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 09:27:07 +0000 (UTC)
Date: Thu, 19 Jul 2018 11:27:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Add DATA_RELOC tree to essential
 non-empty tree list
Message-ID: <20180719092700.GE26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719070514.10740-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719070514.10740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 03:05:14PM +0800, Qu Wenruo wrote:
> DATA RELOC tree should also never be empty.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200407
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> It's possible just fold this fix into commit "btrfs: tree-checker: Detect
> invalid empty essential tree".

Done, thanks.
