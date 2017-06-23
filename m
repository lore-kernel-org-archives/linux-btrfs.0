Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754365AbdFWQv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:51:29 -0400
Date: Fri, 23 Jun 2017 18:14:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Nikolay Borisov <nborisov@suse.com>, tj@kernel.org, jbacik@fb.com,
        jack@suse.cz, jeffm@suse.com, chandan@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/4] Support for metadata specific accounting
Message-ID: <20170623161424.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1498141404-18807-1-git-send-email-nborisov@suse.com>
 <20170622150848.GA932@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622150848.GA932@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 11:08:49AM -0400, Josef Bacik wrote:
> On Thu, Jun 22, 2017 at 05:23:20PM +0300, Nikolay Borisov wrote:
> > This series is a report of Josef's original posting [1]. I've included 
> > fine-grained changelog in each patch with my changes. Basically, I've forward
> > ported it to 4.12-rc6 and tried incorporating the feedback which was given to 
> > every individual patch (I've included link with that information in each 
> > individual patch). 
> > 
> > The main rationale of pushing this is to enable btrfs' subpage-blocksizes
> > patches to eventually be merged.
> > 
> > This patchset depends on patches (in listed order) which have already
> > been submitted [2] [3] [4]. But overall they don't hamper review. 
> 
> I haven't reposted these patches because they depend on the other work I'm
> doing wrt slab shrinking.  We can't do the sub page blocksize stuff until those
> patches are in, and then I have to re-evaluate this stuff to make sure it still
> makes sense.  Thanks,

What's the rough ETA for all the subpage-blocksize prerequisities? We've
agreed at LSF to postpone any major refactoring and cleanups until the
patchset lands but with more dependencies I think the current subpage
patches would need to be rewritten from scratch anyway.

Delaying for one or two more major releases still sounds doable, but
with current pace of changes I'm afraid that's unrealistic and will just
block other work.
