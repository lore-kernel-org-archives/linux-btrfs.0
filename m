Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34575 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751351AbeEVMRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 08:17:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C2FBAEB5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 12:17:40 +0000 (UTC)
Date: Tue, 22 May 2018 14:14:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Use btrfs_mark_bg_unused() to replace open code
Message-ID: <20180522121455.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180522084347.3381-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522084347.3381-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 04:43:47PM +0800, Qu Wenruo wrote:
> Introduce a small helper, btrfs_mark_bg_unused(), to accquire needed
> locks and add a block group to unused_bgs list.

The helper is nice but hides that there's a reference taken on the 'bg'.
This would be good to add at least to the function comment or somehow
squeeze it into the function name itself, like
btrfs_get_and_mark_bg_unused.
