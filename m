Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754549AbeDTLbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 07:31:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43FE9AF19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 11:31:05 +0000 (UTC)
Date: Fri, 20 Apr 2018 13:28:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 09/16] btrfs: cleanup helpers that reset balance state
Message-ID: <20180420112833.GL21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524146555.git.dsterba@suse.com>
 <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
 <aa843182-8cd9-448e-ccfb-1ec1b95e032f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aa843182-8cd9-448e-ccfb-1ec1b95e032f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 10:07:17AM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.04.2018 19:33, David Sterba wrote:
> > +		/* reset_balance_state needs volume_mutex */
> 
> Does it make sense to codify this invariant as lockdep_assert_held in
> reset_balance_state ?

No, the comment and the mutex will be removed in the following patches.

But yeah in general the lockdep annotations are better than the comments
stating which lock is supposed to be held.
