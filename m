Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753352AbeDXKue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 06:50:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2561AAC64
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 10:50:33 +0000 (UTC)
Date: Tue, 24 Apr 2018 12:48:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
Message-ID: <20180424104800.GB21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424044809.29838-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 12:48:07PM +0800, Qu Wenruo wrote:
> Although we have already checked incompat flags manually before really
> mounting it, we could still enhance btrfs_check_super_valid() to check
> incompat flags for later write time super block validation check.

But the calls are in reverse. First the validation is called and then
the incompat bits are verified if the filesystem is mountable.

With change in this patch, any uknonwn incompat bit at mount time will
be reported as corruption. This does not make sense.

I've read the discussion under previous version again, IMHO the best way
to report what's going on is to use 2 functions for mount ant pre-commit
time.

We can't expect that random user will understand that new unsupported
flags actually mean corruption or that unsupported bits at mount time
are not really a corruption.
