Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdKIRJo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 12:09:44 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 30343AC08
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Nov 2017 17:09:43 +0000 (UTC)
Date: Thu, 9 Nov 2017 18:07:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: print-tree: Print offset as tree
 objectid
Message-ID: <20171109170751.GR27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031060758.531-1-wqu@suse.com>
 <20171031060758.531-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031060758.531-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 02:07:58PM +0800, Qu Wenruo wrote:
> For case like tree reloc trees and subvolume trees, their key offset is
> the tree id.
> 
> For case like tree treloc tree for data reloc tree,
> The key will be outputted as:
> (TREE_RELOC ROOT_ITEM 18446744073709551607)
> 
> The minus number is long and even guys with real engineer brains can't
> easily get the meaning.
> 
> This patch will change the output format to:
> (TREE_RELOC ROOT_ITEM DATA_RELOC_TREE)
> 
> While for special offset value like 0 or (u64)-1, it's still shown as
> is.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
