Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752586AbeDSNO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 09:14:59 -0400
Date: Thu, 19 Apr 2018 15:12:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: print-tree: output enhancement
Message-ID: <20180419131226.GD21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180411090813.19495-1-wqu@suse.com>
 <20180419124919.GB21272@twin.jikos.cz>
 <5946b8b7-b1d9-647b-e3c1-3238db716859@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5946b8b7-b1d9-647b-e3c1-3238db716859@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 08:57:30PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年04月19日 20:49, David Sterba wrote:
> > On Wed, Apr 11, 2018 at 05:08:12PM +0800, Qu Wenruo wrote:
> >> This patch enhance the following things:
> >>
> >> - tree block header
> >>   * add generation and owner output for node and leaf
> >> - node pointer generation output
> >> - allow btrfs_print_tree() to not follow nodes
> >>   * just like btrfs-progs
> >>
> >> Please note that, although function btrfs_print_tree() is not called by
> >> anyone right now, it's still a pretty useful function to debug kernel.
> >> So that function is still kept for later use.
> > 
> > It will stay of course, code deletionists have no chance removing useful
> > debugging stuff.
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > 
> > Some time ago I improved the progs output of print-tree, this would be
> > also good to port to kernel and we can then keep the files in 1:1.
> 
> Definitely!
> The current kernel print-tree is just better than no output, far from
> human readable output.
> I can't wait to port btrfs-progs print-tree to kernel, but that's over
> 1000 lines for debug facility.
> 
> If that's OK, I could start the port any time.

As print-tree is independent, you can do that incrementally, similar to
the progs patches that factor out the per-key cases into functions.
Anything you'd have we can merge rightaway, these are easy patches that
can serve as a "relaxation" and relief from the difficult ones.
