Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbbH0JOo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 05:14:44 -0400
Date: Thu, 27 Aug 2015 11:14:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
Message-ID: <20150827091407.GB11834@suse.cz>
Reply-To: dsterba@suse.cz
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz>
 <55BF15DF.9080805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55BF15DF.9080805@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 03, 2015 at 03:18:55PM +0800, Qu Wenruo wrote:
> >> Implement details includes the following:
> >> 1) LRU hash maps to limit the memory usage
> >>     The hash -> extent mapping is control by LRU (or unlimited), to
> >>     get a controllable memory usage (can be tuned by mount option)
> >>     alone with controllable read/write overhead used for hash searching.
> >
> > In Liu Bo's series, I rejected the mount options as an interface and
> > will do that here as well. His patches added a dedup ioctl to (at least)
> > enable/disable the dedup.
> BTW,　would you please give me some reason why that's not a good idea to 
> use mount option to trigger/change dedup options?

That's the wrong interface to use for such actions.
