Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdLLTJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 14:09:57 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC19BAF85
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 19:09:56 +0000 (UTC)
Date: Tue, 12 Dec 2017 20:07:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Rename bin_search -> btrfs_bin_search
Message-ID: <20171212190756.GU3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512743263-18791-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512743263-18791-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 04:27:43PM +0200, Nikolay Borisov wrote:
> Currently there are 2 function doing binary search on btrfs nodes:
> bin_search and btrfs_bin_search. The latter being a simple wrapper for
> the former. So eliminate the wrapper and just rename bin_search to
> btrfs_bin_search. No functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
