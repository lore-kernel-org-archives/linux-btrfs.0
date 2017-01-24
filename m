Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750792AbdAXMTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 07:19:44 -0500
Date: Tue, 24 Jan 2017 13:19:23 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH v4] btrfs-progs: Fix disable backtrace assert error
Message-ID: <20170124121923.GU11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170119040003.22773-1-quwenruo@cn.fujitsu.com>
 <20170124115522.GT11951@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170124115522.GT11951@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 12:55:22PM +0100, David Sterba wrote:
> On Thu, Jan 19, 2017 at 12:00:03PM +0800, Qu Wenruo wrote:
> > Due to commit 00e769d04c2c83029d6c71(btrfs-progs: Correct value printed
> > by assertions/BUG_ON/WARN_ON), which changed the assert_trace()
> > parameter, the condition passed to assert/WARN_ON/BUG_ON are logical
> > notted for backtrace enabled and disabled case.
> > 
> > Such behavior makes us easier to pass value wrong, and in fact it did
> > cause us to pass wrong condition for ASSERT().
> > 
> > Instead of passing different conditions for ASSERT/WARN_ON/BUG_ON()
> > manually, this patch will use ASSERT() to implement the resting
> > ASSERT/WARN_ON/BUG() for disable backtrace case, and use assert_trace()
> > to implement ASSERT() and BUG_ON(), to allow them to print correct
> > value.
> > 
> > Also, move WARN_ON() out of the ifdef branch, as it's completely the
> > same for both branches.
> > 
> > Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Applied, thanks.

And FYI, I've added a trace dump for BUG_ON and removed the value
negation from ASSERT.
