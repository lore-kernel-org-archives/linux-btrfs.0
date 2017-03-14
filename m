Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbdCNNSO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 09:18:14 -0400
Date: Tue, 14 Mar 2017 14:17:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
Message-ID: <20170314131730.GZ14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
 <fd92287d-c048-0950-4769-9f06ba2a843e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fd92287d-c048-0950-4769-9f06ba2a843e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 09:24:05AM -0500, Jeff Mahoney wrote:
> On 3/6/17 3:08 AM, Qu Wenruo wrote:
> > Any response?
> > 
> > These patches are already here for at least 2 kernel releases.
> > And are all bug fixes, and fix bugs that are already reported.
> > 
> > I didn't see any reason why it should be delayed for so long time.
> 
> I'll work my way through as I can.  I posted some review earlier today.
> 
> Man, I wish we could just get rid of the hierarchical part of qgroups. :)

It does complicate things, no doubt about that, but it gives a nice
usecase, where we can account space of a subvolume and all of its
snapshots. The subvolumes can be freely grouped and accounted further,
the particular example are user home directories with snapshots. There
is a usecase for containers, where each root could replicate the same
subvolume structure and the the accounting can be done per container
and/or per group of containers.

IMHO there's not much difference code-wise if we allow more than one
level of the hierarchy, so it's basically flat vs hierarchical.
