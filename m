Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932793AbeCSM5Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 08:57:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 476ACAD91
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 12:57:24 +0000 (UTC)
Date: Mon, 19 Mar 2018 13:55:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: convert/ext2: Remove check for
 ext2_ext_attr_entry->e_value_block
Message-ID: <20180319125500.GD6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180314005657.28471-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314005657.28471-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 08:56:57AM +0800, Qu Wenruo wrote:
> In latest e2fsprogs (1.44.0) definition of ext2_ext_attr_entry has
> removed member e_value_block, as currently ext* doesn't support it set
> anyway.
> 
> So remove such check so that we can pass compile.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
