Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38093 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751478AbdEaOIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 10:08:14 -0400
Date: Wed, 31 May 2017 16:07:02 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
Subject: Re: [PATCH v4 00/20] Btrfs-progs offline scrub
Message-ID: <20170531140702.GF14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <20170530185432.GZ14523@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170530185432.GZ14523@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 08:54:32PM +0200, David Sterba wrote:
> On Thu, May 25, 2017 at 02:21:45PM +0800, Qu Wenruo wrote:
> > For any one who wants to try it, it can be get from my repo:
> > https://github.com/adam900710/btrfs-progs/tree/offline_scrub
> > Qu Wenruo (20):
> >   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
> >   btrfs-progs: raid56: Introduce tables for RAID6 recovery
> >   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
> >   btrfs-progs: raid56: Allow raid6 to recover data and p

Patches 1-5 applied, with small fixups here and there, that took me more
time than I wanted. Yet I'm not sure if I should bother you with the
coding style things and grammar fixes. Maybe I should, it becomes too
distracting namely in the rest of the patch series.

> >   btrfs-progs: Introduce wrapper to recover raid56 data
> >   btrfs-progs: Introduce new btrfs_map_block function which returns more
> >     unified result.
> >   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
> >   btrfs-progs: csum: Introduce function to read out data csums
> 
> I'm about to start merging this patches, in parts. First the patches 1-8
> as they're independent and not intrusive.
> 
> >   btrfs-progs: scrub: Introduce structures to support offline scrub for
> >     RAID56
> >   btrfs-progs: scrub: Introduce functions to scrub mirror based tree
> >     block
> >   btrfs-progs: scrub: Introduce functions to scrub mirror based data
> >     blocks
> >   btrfs-progs: scrub: Introduce function to scrub one mirror-based
> >     extent
> >   btrfs-progs: scrub: Introduce function to scrub one data stripe
> >   btrfs-progs: scrub: Introduce function to verify parities
> >   btrfs-progs: extent-tree: Introduce function to check if there is any
> >     extent in given range.
> >   btrfs-progs: scrub: Introduce function to recover data parity
> >   btrfs-progs: scrub: Introduce helper to write a full stripe
> >   btrfs-progs: scrub: Introduce a function to scrub one full stripe
> >   btrfs-progs: scrub: Introduce function to check a whole block group
> >   btrfs-progs: scrub: Introduce offline scrub function
