Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50799 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759017AbcIWKrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 06:47:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5CCBAC4B
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 10:47:10 +0000 (UTC)
Date: Fri, 23 Sep 2016 12:45:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] Do not reassign count in btrfs_run_delayed_refs
Message-ID: <20160923104508.GV16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474571507-5375-1-git-send-email-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474571507-5375-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 02:11:47PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code cleanup. count is already (unsgined long)-1. That is the reason
> run_all was set. Do not reassign it (unsigned long)-1.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
