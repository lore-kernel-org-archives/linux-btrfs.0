Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45113 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753977AbeAaQ3g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:29:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2FD4ADA7
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 16:29:35 +0000 (UTC)
Date: Wed, 31 Jan 2018 17:27:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: fsck-tests: Rename tree-reloc-tree test
 number
Message-ID: <20180131162723.GI18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180131024036.23307-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180131024036.23307-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 10:40:36AM +0800, Qu Wenruo wrote:
> There are 2 fsck tests with the same number 027:
> tree-reloc-tree
> bad-extent-inline-ref-type
> 
> And we also have a hole in 015, so just rename tree-reloc-tree to 015,
> to get rid of the duplicated test number and fill in the hole.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied thanks. I've changed the subject so it mentions the numbers for
future reference.
