Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753320AbcLHOwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 09:52:53 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48F83ACE4
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 14:52:20 +0000 (UTC)
Date: Thu, 8 Dec 2016 15:52:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: Fix extents after finding all errors
Message-ID: <20161208145215.GG12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161201172808.1071-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161201172808.1071-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 11:28:08AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Simplifying the logic of fixing.
> 
> Calling fixup_extent_ref() after encountering every error causes
> more error messages after the extent is fixed. In case of multiple errors,
> this is confusing because the error message is displayed after the fix
> message and it works on stale data. It is best to show all errors and
> then fix the extents.
> 
> Set a variable and call fixup_extent_ref() if it is set. err is not used,
> so cleared it.
> 
> Changes since v1:
>  + assign fix from ret for a correct repair_abort code path
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, thanks.
