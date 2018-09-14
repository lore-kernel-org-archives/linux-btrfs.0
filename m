Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726908AbeINTjs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:39:48 -0400
Date: Fri, 14 Sep 2018 16:25:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
Message-ID: <20180914142501.GJ5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180803055022.9816-1-wqu@suse.com>
 <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
 <20180911163851.GG2154@twin.jikos.cz>
 <ef65752f-c68a-778e-0334-9dc65d1f840c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ef65752f-c68a-778e-0334-9dc65d1f840c@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 07:59:34AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/9/12 上午12:38, David Sterba wrote:
> > On Wed, Aug 29, 2018 at 01:27:39PM +0800, Qu Wenruo wrote:
> >> Gentle ping.
> >>
> >> These fixes are pretty small, I'd like to see them merged before I need
> >> to rebase them again and again.
> > 
> > I've merged them now, thanks. I had to edit all changelogs and remove
> > the ----- lines, shortened the paths in the test logs and fixed typos.
> 
> Thanks for the editing.
> 
> I'll keep the log format as default for all later patches.
> 
> BTW, is there any difference between 2 spaces indent and 1 space indent
> for log?

No, it's for some visual separation so on first glance is obvious what's
the changelog text and what are logs or commands to reproduce. One space
is ok too so the log is not drifting away.
