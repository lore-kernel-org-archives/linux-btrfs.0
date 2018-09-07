Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbeIGSTc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 14:19:32 -0400
Date: Fri, 7 Sep 2018 15:38:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: qgroup: Deprecate unused features for
 btrfs_qgroup_inherit()
Message-ID: <20180907133813.GP24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180831022930.3465-1-wqu@suse.com>
 <20180905130030.GW24025@twin.jikos.cz>
 <6d55732f-4788-5e7c-e0a8-3f5e64ff3409@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6d55732f-4788-5e7c-e0a8-3f5e64ff3409@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 09:25:45PM +0800, Qu Wenruo wrote:
> > The deprecation should be done in a few steps. First issue a warning
> > that the feature is deprecated and will be removed in release X. Then
> > wait until somebody complains (or not) and remove the code in release X.
> > 
> > The X is something like 4.22, ie. at least 2 cycles after the
> > deprecation warning is added.
> 
> Thanks for the deprecation progress.
> 
> However I'm wondering if the "release X" is really needed in the warning
> message.

The specific version or date is IMHO a good practice. For features known
to be used the deprecation period may be years long and hard to predict
the version. In case of the qgroup inheritance it's a minor feature set
reduction and the 2 release period is there just in case. We can be
specific here and we should put that into the message.

> (I may forgot to submit the real deprecation patch for that release).

I document the feature deprecation and removal on the wiki changelog, so
if you forget, slipping one release causes no harm but I think somebody
will notice in time.
