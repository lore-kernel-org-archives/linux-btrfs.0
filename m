Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdK1RmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 12:42:13 -0500
Date: Tue, 28 Nov 2017 18:40:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: About 'key type for persistent [...] items'
Message-ID: <20171128174014.GA3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
 <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 25, 2017 at 09:12:35AM +0800, Qu Wenruo wrote:
> On 2017年11月25日 03:16, Hans van Kranenburg wrote:
> > Last week, when implementing the automatic classifier to dynamically
> > create tree item data objects by key type in python-btrfs, I ran into
> > the following commits in btrfs-progs:
> > 
> >   commit 8609c8bad68528f668d9ce564b868aa4828107a0
> >   btrfs-progs: print-tree: factor out temporary_item dump
> > and
> >   commit a4b65f00d53deb1b495728dd58253af44fcf70df
> >   btrfs-progs: print-tree: factor out persistent_item dump
> > 
> > ...which are related to kernel...
> > 
> >   commit 50c2d5abe64c1726b48d292a2ab04f60e8238933
> >   btrfs: introduce key type for persistent permanent items
> > and
> >   commit 0bbbccb17fea86818e1a058faf5903aefd20b31a
> >   btrfs: introduce key type for persistent temporary items
> > 
> > Afaics the goal is to overload types because there can be only 256 in
> > total.
> 
> Personally speaking, to overload types, we can easily make different
> meanings of type based on tree owner.

Key type tied to a tree would cause some ambiguity, while now we always
know what's in the type item if we eg. read a random metadata block.

We're now at ~40 key types, scattered in the 256 range so further
extensions are possible should we need a particular number due to the
ordering.
