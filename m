Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38199 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeCIPwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 10:52:51 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 381F3AF2D
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 15:52:50 +0000 (UTC)
Date: Fri, 9 Mar 2018 16:50:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: dump-super: Don't verify csum if csum type
 or size is unknown
Message-ID: <20180309155029.GW23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180306021651.9364-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180306021651.9364-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 10:16:51AM +0800, Qu Wenruo wrote:
> Reported-by: Ken Swenson <flat@imo.uto.moe>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
