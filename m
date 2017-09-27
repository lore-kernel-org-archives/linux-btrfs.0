Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37023 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdI0SCK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 14:02:10 -0400
Date: Wed, 27 Sep 2017 11:01:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Message-ID: <20170927180126.3lyospiyn56bweld@merlins.org>
References: <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
 <20170903202036.b7j6fcknfiisrnsl@merlins.org>
 <D509EEE0-1430-40C2-8AD4-117729CFADDD@fb.com>
 <20170909183918.guot5vuphgabevxi@merlins.org>
 <63F04FB0-47AD-4732-ACD6-B493C51F9ED4@fb.com>
 <20170910023658.4y7u77tku3c6wj2t@merlins.org>
 <5E342E49-3C3A-4A77-A2CB-46508684AD8D@fb.com>
 <20170910131437.y2wxt65ps7go42av@merlins.org>
 <BA7507E1-FBFF-461D-9724-39FC784EE485@fb.com>
 <20170911002214.m2iaktwzc7ezuyxm@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170911002214.m2iaktwzc7ezuyxm@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 10, 2017 at 05:22:14PM -0700, Marc MERLIN wrote:
> On Sun, Sep 10, 2017 at 01:16:26PM +0000, Josef Bacik wrote:
> > Great, if the free space cache is fucked again after the next go
> > around then I need to expand the verifier to watch entries being added
> > to the cache as well.  Thanks,
> 
> Well, I copied about 1TB of data, and nothing happened.
> So it seems clearing it and fsck may have fixed this fault I had been
> carrying for quite a while.
> If so, yeah!
> 
> I'm not sure if this needs a kernel fix to not get triggered and if
> btrfs check should also be improved to catch this, but hopefully you
> know what makes sense there.

Just to report back, it's now been another 2 weeks, and no problem.
Seems that forcing the clear cache was actually the issue. Not sure if
the kernel should have found/detected/auto fixed the problem or if btrfs
check should have.

Either way, thanks for your help.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
