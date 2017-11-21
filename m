Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdKUNa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 08:30:26 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2800AABAE
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 13:30:25 +0000 (UTC)
Date: Tue, 21 Nov 2017 14:28:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: some code cleanup and documentation
Message-ID: <20171121132830.GI3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171120202449.22947-1-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171120202449.22947-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:24:46PM -0700, Edmund Nadolski wrote:
> This series adds a bit of code cleanup and some documentation in the
> form of comments. No operational change.
> 
> Edmund Nadolski (3):
>   btrfs: btrfs_inode_log_parent should use defined inode_only values.
>   btrfs: update some code documentation
>   btrfs: remove dead code from btrfs_get_extent

Patches 1 and 3 added to next, thanks.
