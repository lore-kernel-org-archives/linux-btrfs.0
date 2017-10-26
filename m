Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932343AbdJZSPk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:15:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6214DACAB
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:15:39 +0000 (UTC)
Date: Thu, 26 Oct 2017 20:13:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 6/6] btrfs-progs: rescue: Fix zero-log mounted branch
Message-ID: <20171026181351.GF3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171017091312.31045-1-wqu@suse.com>
 <20171017091312.31045-7-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171017091312.31045-7-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 17, 2017 at 05:13:12PM +0800, Qu Wenruo wrote:
> Seems to be a typo that, in (ret > 0) branch of check_mounted(),
> zero-log set the return value but doesn't return.
> 
> Fix it by adding back the missing return.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
