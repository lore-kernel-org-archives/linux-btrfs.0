Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3AKPbi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 10:31:38 -0500
Date: Fri, 11 Jan 2013 16:31:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130111153136.GL20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
 <20130110020517.GA4456@liubo>
 <20130110115426.GF3763@twin.jikos.cz>
 <20130110131052.GA3616@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130110131052.GA3616@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 09:11:32PM +0800, Liu Bo wrote:
> On Thu, Jan 10, 2013 at 12:54:26PM +0100, David Sterba wrote:
> > On Thu, Jan 10, 2013 at 10:05:39AM +0800, Liu Bo wrote:
> > > On Tue, Jan 08, 2013 at 12:07:34PM -0800, Zach Brown wrote:
> > > > > This is for detecting extent map leak.
> > > > 
> > > > Hmm, I guess it's cool to get the allocation-specific decoding which you
> > > > don't get from the generic kernel leak tracking?
> > > 
> > > Thanks for the advice, but what allocation-specific decoding do you refer to?
> > > Could you please show me any examples?
> > 
> > IMHO that there's a leak check that is targeted to one exact problem in
> > one subsystem (extent_map in btrfs), does not need to be poked to do a
> > scan-for-leaks so the leak can be reported immediatelly and not after
> > some time. It makes sense for such a core structure like extent_map.
> > Other structures are allocated from a slab so we can at least check for
> > leaks upon module unload.
> 
> Sorry, I don't get your point, but extent map is allocated from its
> slab section as well.
> 
> The 'scan-for-leaks' is just for developers' debug purpose, which
> can tell us some information about the leaked ones, like refs, type, etc.

Yeah, and it's a good thing.

> I think I'm doing the same thing as leak debug for extent_state/extent_buffer.
> We can disable it as default.

We've now gathered several debugging helpers so I'll resend the patch to
add CONFIG_BTRFS_DEBUG and we can put such things under that. Zach
already explained his concerns, mine was a bit off-track sorry :)

david
