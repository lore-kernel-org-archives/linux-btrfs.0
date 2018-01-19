Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753054AbeASXey (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 18:34:54 -0500
Date: Sat, 20 Jan 2018 00:32:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH v2 09/10] Btrfs: add tracepoint for em's EEXIST case
Message-ID: <20180119233243.GC15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-10-bo.li.liu@oracle.com>
 <20180119181539.GA15713@twin.jikos.cz>
 <f263a361-1e58-0bb0-9be4-c6c362f78e73@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f263a361-1e58-0bb0-9be4-c6c362f78e73@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 19, 2018 at 08:22:36PM +0200, Nikolay Borisov wrote:
> 
> 
> On 19.01.2018 20:15, David Sterba wrote:
> > On Fri, Jan 05, 2018 at 12:51:16PM -0700, Liu Bo wrote:
> >> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
> >> subtle bugs around merge_extent_mapping.
> >>
> >> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Nikolay has some concernas about adding the tracepoint, so I'll leave
> > this patch out of the series for now as we should decide how to proceed.
> > 
> > Thacepoints are considered an ABI by some and not ABI by others. I think
> > it's a good addition to the debugging aids that also may turn out to be
> > useful for evaluating performance later.
> > 
> > At minimum we could add some prefix/suffix to the debugging tracepoint
> > name, so we can let developers add what they need right away.
> My concern specifically has to do with the fact that if tracepoints are
> considere ABI then whatever decision we make now will be cast in stone

Right, same as with the ioctls, we take a great care there and still do
mistakes that get discovered months after.

> and if we juggle the code around we will still have to retain the format
> of the tracepoint. If, OTOH we are able to remove and change the
> tracepoint as we see fit - then it's okay. Otherwise we risk polluting
> the code

Understood and agreed.

Jeff raised a question if there are namespaces in the tracepoints.
That's an interesting point and would be more systematic than inventing
our own naming scheme.
