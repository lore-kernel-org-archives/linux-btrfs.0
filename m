Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932457AbcKKMxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 07:53:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9193AAC34
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Nov 2016 12:34:44 +0000 (UTC)
Date: Fri, 11 Nov 2016 13:34:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] Return best entry, if it is the first one
Message-ID: <20161111123442.GH12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161110150147.19766-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110150147.19766-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 09:01:46AM -0600, Goldwyn Rodrigues wrote:
> The find_most_right_entry() tends to miss on the best entry if it
> is the first one on the list and there are only two entries in the list.
> So, we assign both prev and best to entry.
> 
> To do this, the selection process (rather the rejection) has to be
> performed earlier to skip on broken==count.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, and I've put part of the changelog as comment to the code.
Minor nit, please don't forget to add the prefix to the subject. I fix
that, no problem, but the patches could be delayed if it's not clear
that's for progs.
