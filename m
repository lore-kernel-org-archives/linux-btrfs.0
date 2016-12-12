Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49139 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932389AbcLLQf0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 11:35:26 -0500
Date: Mon, 12 Dec 2016 17:35:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Prasanth K S R <kosigiprasanth@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Prasanth K S R <prasanth.ksr@dell.com>,
        dsterba@suse.com
Subject: Re: [PATCH 1/3] Btrfs-progs: subvol_uuid_search: Return error on
 memory allocation failure
Message-ID: <20161212163520.GV12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161210134744.10825-1-kosigiprasanth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161210134744.10825-1-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 10, 2016 at 07:17:42PM +0530, Prasanth K S R wrote:
> From: Prasanth K S R <prasanth.ksr@dell.com>
> 
> This commit fixes coverity defect CID 1328695.
> 
> Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>

Thanks, 1-3 applied.

JFYI, I've realized that subvol_uuid_search is part of the public API so
changing the return value would break the existing users (I know that
snapper uses this function), as it now returns just a pointer or NULL.
I'll fix that, a new function and library version bump would be needed.
