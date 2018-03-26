Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751748AbeCZOMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 10:12:36 -0400
Date: Mon, 26 Mar 2018 16:10:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        jeffm@suse.com
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
Message-ID: <20180326141008.GO6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
 <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 08:55:21AM +0800, Qu Wenruo wrote:
> On 2017年12月13日 05:12, David Sterba wrote:
> > On Tue, Dec 12, 2017 at 03:34:22PM +0800, Qu Wenruo wrote:
> >> The patch is consist of 2 main parts:
> >> 1) Type based qgroup reservation
> >>    The original patchset is sent several months ago.
> >>    Nothing is modified at all, just rebased. And not conflict at all.
> >>
> >>    It's from patch 1 to patch 6.
> >>
> >> 2) Split meta qgroup reservation into per-trans and prealloc sub types
> >>    The real work to address metadata underflow.
> >>    Due to the over-reserve problem, this part is still in RFC state.
> >>    But the framework should mostly be fine, only needs extra fine-tuning
> >>    to get more accurate qgroup rsv to avoid too early limit.
> >>
> >>    It's from patch 7 to 14.
> > 
> > I'm going to add the whole patchset to next, the first part has been
> > there for some time and no test failures were reported. I optimistically
> > expect that the second part will also be fine.
> 
> The type based reservation is completely fine, since it doesn't
> introduce anything new, just a preparation for the incoming meta rework.
> 
> However I prefer not to push the whole patchset to upstream until
> over-reserve behavior is solved.
> Since it breaks quite some test cases with small limit.

Merging plan for this patchset from last week was to postpone until
4.18 due to lack of final testing here. I've tried to run this with
quotas enabled an fstests that led to warnings in the power failure
simulation tests.

As there's going to be one more rc, this gives us one more week to
decide if its' ok-ish to merge this patch and fix the fallouts during
the normal cycle.

Given that this patchset has been in for-next for a long time, I'd do
the merge now and focus on testing for that patchset as the rest of
devel patches looks good.

Please let me know if you have objections.
