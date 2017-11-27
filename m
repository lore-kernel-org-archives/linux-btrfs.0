Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbdK0TEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 14:04:24 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CCB56AC99
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 19:04:22 +0000 (UTC)
Date: Mon, 27 Nov 2017 20:02:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/3] btrfs-progs: test/fsck: Introduce test images
 containing tree reloc tree
Message-ID: <20171127190226.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171110013419.15159-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171110013419.15159-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 09:34:17AM +0800, Qu Wenruo wrote:
> Tree reloc tree is a special tree with very short life spawn.
> It acts as a special snapshot for any tree, with related nodes/leaves or
> EXTENT_DATA modified to point to new position.
> 
> Considering the short life spawn and its specialness, it should be quite
> reasonable to keep them as both corner case for fsck and educational
> dump for anyone interested in relocation.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1-3 applied, thanks.
