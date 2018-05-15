Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbeEOSRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 14:17:49 -0400
Date: Tue, 15 May 2018 20:15:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs_search_slot cleanups
Message-ID: <20180515181508.GX6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 01:52:02AM +0800, Liu Bo wrote:
> These're the cleanups I made for btrfs_search_slot() and its callees.

All the patches have very terse changelog and I have no idea why you
think the code change is correct so I can compare my review against
that.

It's touching code around locking that's never bad to be more
verbose and introduce a bit of the context, the simple sentence is maybe
clear to you when you go through the code, but imagine you read the
changelog in a week or month or a year. It still needs to make sense or
give enough pointers to find out from the code.

Please update and resend, thanks.
