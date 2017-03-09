Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753861AbdCIQzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 11:55:35 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C0936AB9D
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Mar 2017 16:55:33 +0000 (UTC)
Date: Thu, 9 Mar 2017 17:54:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] qgroup: Retry after commit on getting EDQUOT
Message-ID: <20170309165458.GI14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170219133059.20939-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170219133059.20939-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 19, 2017 at 07:30:59AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> We are facing the same problem with EDQUOT which was experienced with
> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
> here is a fix. Let me know if it is too big a hammer.

On first look it does seem too heavy. Do you have numbers what's the
slowdown? If it's bearable we can stick with it and implement the
ticketed approach.
