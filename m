Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55456 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757190AbcAOJq4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:46:56 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com> <20160114141710.GW4227@twin.jikos.cz>
In-Reply-To: <20160114141710.GW4227@twin.jikos.cz>
Subject: RE: [GIT PULL] Fujitsu for 4.5
Date: Fri, 15 Jan 2016 17:46:42 +0800
Message-ID: <01e901d14f79$a4adb660$ee092320$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Thursday, January 14, 2016 10:17 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: 'Chris Mason' <clm@fb.com>; 'btrfs' <linux-btrfs@vger.kernel.org>
> Subject: Re: [GIT PULL] Fujitsu for 4.5
> 
> On Wed, Jan 13, 2016 at 05:28:12PM +0800, Zhao Lei wrote:
> > This is collection of some bug fix, enhance and cleanup from fujitsu
> > against btrfs for v4.5, mainly for reada, plus some small fix and
> > cleanup for scrub and raid56.
> >
> > All patchs are in btrfs-maillist, rebased on top of integration-4.5.
> >
> > Would you please consider merging the following fixes to integration-4.5
> branch?
> 
> > Zhao Lei (26):
> ...
> >   btrfs: reada: Avoid many times of empty loop
> >   btrfs: reada: Move is_need_to_readahead contition earlier
> >   btrfs: reada: add all reachable mirrors into reada device list
> >   btrfs: reada: bypass adding extent when all zone failed
> >   btrfs: reada: Remove level argument in severial functions
> >   btrfs: reada: move reada_extent_put to place after __readahead_hook()
> >   btrfs: reada: Pass reada_extent into __readahead_hook directly
> >   btrfs: reada: Use fs_info instead of root in __readahead_hook's
> >     argument
> >   btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
> >   btrfs: reada: Fix a debug code typo
> ...
> >   btrfs: reada: limit max works count
> >   btrfs: reada: simplify dev->reada_in_flight processing
> 
> I have reviewed the readahead patches and ack them for 4.5.

Great thanks for reviewing these patchs.

And following 3 patchs in this branch are also for readahead, but sorry that
I forgot adding "reada" prefix in subject.
  btrfs: Fix in-segment calculation for reada
  btrfs: reduce additional fs_info->reada_lock in reada_find_zone
  btrfs: Add missed segment checking in reada_find_zone

Would you please consider helping me to review them?

Thanks
Zhaolei




