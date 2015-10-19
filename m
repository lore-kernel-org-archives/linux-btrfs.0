Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbbJSJPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 05:15:31 -0400
Date: Mon, 19 Oct 2015 11:14:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: extend balance filter limit to take minimum
 and maximum
Message-ID: <20151019091416.GS27761@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1445013000.git.dsterba@suse.com>
 <35832c0abf72cfd1e118d484f6a9ebdd689f8757.1445013000.git.dsterba@suse.com>
 <20151016230837.GD4400@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151016230837.GD4400@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 16, 2015 at 07:08:37PM -0400, Zygo Blaxell wrote:
> On Fri, Oct 16, 2015 at 06:50:08PM +0200, David Sterba wrote:
> > The 'limit' filter is underdesigned, it should have been a range for
> > [min,max], with some relaxed semantics when one of the bounds is
> > missing. Besides that, using a full u64 for a single value is a waste of
> > bytes.
> 
> What is min for?
> 
> If we have more than 'max' matching chunks, we'd process 'max' and stop.

Right.

> If we have fewer than 'min' chunks, we'd process what we have and run out.

If we have fewer than min, we'll do nothing.

> If we have more than 'min' chunks but fewer than 'max' chunks, why would
> we stop before we reach 'max' chunks?

I must be missing something here. If there are less than 'max' chunks
(with all filters applied), how are we supposed to reach 'max'?

The 'limit' filter is applied after all the other filters. It can be
used standalone, or with eg. usage. The usecase where I find it useful:

* we want to make metadata chunks more compact
* let's set usage=30
* avoid unnecessary work (which is a bigger performance hit in case
  of metadata chunks), ie. if there's a single chunk with usage < 30%,
  let's skip it

The command:

 $ btrfs balance start -musage=30,limit=2.. /path

So in case there's only one such chunk, balance would just move it
without any gain. Avoiding the unnecessary work here is IMO a win,
though it might seem limited. But I'm going to utilize this in the
btrfsmaintenance package that among others does periodic balancing
on the background, I believe the effects will be noticeable.
