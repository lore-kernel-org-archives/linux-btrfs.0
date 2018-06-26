Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49631 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934936AbeFZOqN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 10:46:13 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D61C1AE7B
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 14:46:12 +0000 (UTC)
Date: Tue, 26 Jun 2018 16:43:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: annotate unlikely branches after V0 extent type
 removal
Message-ID: <20180626144319.GK27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530021456-20749-1-git-send-email-nborisov@suse.com>
 <20180626142414.12874-1-dsterba@suse.com>
 <102d6eae-cae6-1c1a-853c-c8fb41894c50@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <102d6eae-cae6-1c1a-853c-c8fb41894c50@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2018 at 05:31:40PM +0300, Nikolay Borisov wrote:
> 
> 
> On 26.06.2018 17:24, David Sterba wrote:
> > The v0 extent type checks are the right case for the unlikely
> > annotations as we don't expect to ever see them, so let's give the
> > compiler some hint.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> The question is how helpful those unlikelies are in the generated code.

They typically lead to inverse condition (so the jump is not taken) and
the body of the loop is moved farther away.

> Also according to the comment about __cold annotation this already gives
> the compiler a hint that any code leading to such a cold function is
> already unlikely.

Yes, that's another hint. The condition annotation affects the whole
statement block regardless. I also think that the unlikely in this case
serves as a code documentation (as long as this is consistent with other
uses of likely/unlikely).
