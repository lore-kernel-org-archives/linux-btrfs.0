Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030282AbeEXLJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 07:09:30 -0400
Date: Thu, 24 May 2018 13:06:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180524110646.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d181fa0f3fc581208a0258132c8dc3305b01be1a.1527007575.git.osandov@fb.com>
 <20180522171748.GY6649@twin.jikos.cz>
 <20180522173714.GB9536@vader>
 <20180522174111.GC9536@vader>
 <20180522174838.GD9536@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522174838.GD9536@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 10:48:38AM -0700, Omar Sandoval wrote:
> On Tue, May 22, 2018 at 10:41:11AM -0700, Omar Sandoval wrote:
> > On Tue, May 22, 2018 at 10:37:14AM -0700, Omar Sandoval wrote:
> > > On Tue, May 22, 2018 at 07:17:48PM +0200, David Sterba wrote:
> > > > On Tue, May 22, 2018 at 09:47:58AM -0700, Omar Sandoval wrote:
> > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > 
> > > > > Jun Wu at Facebook reported that an internal service was seeing a return
> > > > > value of 1 from ftruncate() on Btrfs in some cases.
> > > > 
> > > > Do you have a reproducer? To estimate how likely is to hit the problem
> > > > in practice.
> 
> Okay last one, I promise, we just need the extent items to be on disk:

[...]

Thanks, I'll add it to the changelog and send the pull request about today.
