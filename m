Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48683 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754476AbeEHKo3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 06:44:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38AC8ACA8
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 10:44:28 +0000 (UTC)
Date: Tue, 8 May 2018 12:41:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix delalloc inodes leaking on btrfs unmount
Message-ID: <20180508104150.GH6649@suse.cz>
Reply-To: dsterba@suse.cz
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <20180507225822.GG6649@twin.jikos.cz>
 <366832e3-26c1-55a2-e1ab-be5efdb99b7c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <366832e3-26c1-55a2-e1ab-be5efdb99b7c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 08:16:37AM +0300, Nikolay Borisov wrote:
> >> properly cleanup delalloc inodes and as a result cleans up the code a bit. 
> >>
> >> I've given it a good bashing through xfstest (4 full xfstest cycles + 100 
> >> iterations of generic/475 since it was hitting some early assertion failures,
> >> which are fixed in the final version) so am pretty confident in the change. 
> > 
> > One qemu testmachine complains.
> > 
> > The branch was ext/nikbor/delalloc-invalidate in my github repo. Other
> > tests seem "fine", unlikely to be related to this patchset.
> > 
> > The error here is a null pointer deref in end bio callback, which
> > matches a use-after-free scenario, so I think there's still something
> > left to fix.
> > 
> > generic/335             [22:34:50]
> 
> How easy is to repro this on this particular test? Like every other run
> or is it spurious?

It happened once, on first run of the testing setup, so I don't have
enough data to answer. I'll start another round and we'll see.
