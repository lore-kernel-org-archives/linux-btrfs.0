Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52187 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3AJLyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:54:32 -0500
Date: Thu, 10 Jan 2013 12:54:26 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130110115426.GF3763@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
 <20130110020517.GA4456@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130110020517.GA4456@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 10:05:39AM +0800, Liu Bo wrote:
> On Tue, Jan 08, 2013 at 12:07:34PM -0800, Zach Brown wrote:
> > > This is for detecting extent map leak.
> > 
> > Hmm, I guess it's cool to get the allocation-specific decoding which you
> > don't get from the generic kernel leak tracking?
> 
> Thanks for the advice, but what allocation-specific decoding do you refer to?
> Could you please show me any examples?

IMHO that there's a leak check that is targeted to one exact problem in
one subsystem (extent_map in btrfs), does not need to be poked to do a
scan-for-leaks so the leak can be reported immediatelly and not after
some time. It makes sense for such a core structure like extent_map.
Other structures are allocated from a slab so we can at least check for
leaks upon module unload.

david
