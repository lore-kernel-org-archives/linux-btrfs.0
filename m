Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932313AbeCIQ6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 11:58:24 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51A7BAF08
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 16:58:23 +0000 (UTC)
Date: Fri, 9 Mar 2018 17:56:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/3] btrfs-progs: Split original mode check to its own
Message-ID: <20180309165602.GA23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180206070223.28791-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180206070223.28791-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 06, 2018 at 03:02:20PM +0800, Qu Wenruo wrote:
> This time, there are 2 patches too large to reach mail list, so please
> fetch the whole patchset from github as usual:
> https://github.com/adam900710/btrfs-progs/tree/split_check_part2

I missed this patch series, sorry. The changes look good, there
are unfortunatelly merge conflicts due to the asan/ubsan fixes that
should be trivial to resolve. Can you please rebase the branch and let
mek now? Thanks.
