Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39545 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdK3S1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:27:32 -0500
Date: Thu, 30 Nov 2017 19:25:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
Subject: Re: [PATCH 1/5] btrfs-progs: Add location check when process
 share_data_ref item
Message-ID: <20171130182533.GQ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
 <20171128190239.GC3553@twin.jikos.cz>
 <552db79a-ccd1-3dcb-05fb-a5e2cc26f73f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <552db79a-ccd1-3dcb-05fb-a5e2cc26f73f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 30, 2017 at 02:55:49PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年11月29日 03:02, David Sterba wrote:
> > On Fri, Nov 24, 2017 at 06:41:28PM +0800, Gu Jinxiang wrote:
> >> The following test failed becasuse share_data_ref be added into
> >> extent_cache when deal with root tree node.
> > 
> > The whole function run_next_block would need to be revisited with
> > respect to error handling and sanity checks. Adding them only when a
> > fuzzed image hits the particular code path is not IMHO the best
> > approach.
> 
> As suggested before, backporting tree-checker from kernel may be a good
> solution for all later possible fuzzed problem.
> (And can make btrfs-progs become a good testbed for tree-checker related
> patches before merging into kernel)

Agreed, that would be great.

> For this particular case, planned key->type check against root should
> handle it quite well.

Good, so I'd rather take the tree-checker route.
