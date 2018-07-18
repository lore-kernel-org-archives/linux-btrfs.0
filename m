Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60782 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbeGRWgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 18:36:23 -0400
Date: Wed, 18 Jul 2018 14:56:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <Damenly_Su@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
Message-ID: <20180718215625.GJ10237@merlins.org>
References: <20180717203257.GA10237@merlins.org> <20180717205905.GB10237@merlins.org> <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com> <b3b67616-b00b-91e7-716b-dab147d9be88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b3b67616-b00b-91e7-716b-dab147d9be88@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 10:42:21PM +0300, Andrei Borzenkov wrote:
> > Any help from other experienced developers would definitely help to
> > solve why memory of 'btrfs check' is not swapped out or why OOM killer
> > is not triggered.
> 
> Almost all used memory is marked as "active" and active pages are not
> swapped. Page is active if it was accessed recently. Is it possible that
> btrfs logic does frequent scans across all allocated memory?
> >>
> >> Active:         30381404 kB
> >> Inactive:         585952 kB

That is a very good find.

Yes, the linux kernel VM may be smart enough not to swap pages that got used
recently and when btrfs slurps all the extents to cross check everything, I
think it does cross reference them all many times.
This is why it can run in a few hours when btrfs check lowmem requires days
to run in a similar situation.

I'm not sure if there is a good way around this, but it's good to know that
btrfs repair can effectively abuse the linux VM in a way that it'll take
everything down without OOM having a chance to trigger.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
