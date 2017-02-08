Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932587AbdBHRiJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 12:38:09 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F3C67AC5B
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 15:18:54 +0000 (UTC)
Date: Wed, 8 Feb 2017 16:18:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: Remove unused function arg in
 delete_extent_records
Message-ID: <20170208151826.GG3366@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170203161532.6111-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170203161532.6111-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 03, 2017 at 10:15:32AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> new_len is not used in delete_extent_records().
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, thanks.
