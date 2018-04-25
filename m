Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbeDYUDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 16:03:44 -0400
Date: Wed, 25 Apr 2018 22:01:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: set keep_lock when necessary in
 btrfs_defrag_leaves
Message-ID: <20180425200109.GP21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524620434-108372-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524620434-108372-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 09:40:34AM +0800, Liu Bo wrote:
> path->keep_lock is set but @path immediatley gets released, this sets
> ->keep_lock only when it's necessary.

Can you please write down more details for context? This mostly repeats
what the code does, but not why. Thanks.
