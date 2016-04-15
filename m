Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbcDOJj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 05:39:26 -0400
Date: Fri, 15 Apr 2016 11:39:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fdmanana@gmail.com, Duncan <1i5t5.duncan@cox.net>,
        Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
Message-ID: <20160415093922.GC28775@suse.cz>
Reply-To: dsterba@suse.cz
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
 <pan$91701$3af360aa$c931211b$9c451328@cox.net>
 <CAL3q7H7zawdrwbnnwr4nRg5PTj3BqRjDpZJo+idxCANMs185LA@mail.gmail.com>
 <570F2BF0.2060409@cn.fujitsu.com>
 <CAL3q7H53zyb2QGE6__9eHmaah31ikZvUO9L78cK1eJ2bfD4nyQ@mail.gmail.com>
 <5710413D.6030505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5710413D.6030505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 09:17:49AM +0800, Qu Wenruo wrote:
> 
> 
> Filipe Manana wrote on 2016/04/14 10:21 +0100:
> > On Thu, Apr 14, 2016 at 6:34 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >> Ping?
> >>
> >> Cc: Chris and David
> >>
> >> It seems that this fix is missing in 4.6 merge window.
> >> Or did I miss something?
> >
> > 4.5-rc7:  https://lkml.org/lkml/2016/3/4/695
> 
> Strangely, not in integration-4.6.
> 
> This makes me wonder which branch I should use now...

for-linus-4.6
