Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35822 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758729AbcLPWO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 17:14:29 -0500
Date: Fri, 16 Dec 2016 23:14:20 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Chris Mason <clm@fb.com>
Cc: Nils Holland <nholland@tisys.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on 4.9
Message-ID: <20161216221420.GF7645@dhcp22.suse.cz>
References: <20161215225702.GA27944@boerne.fritz.box>
 <20161216073941.GA26976@dhcp22.suse.cz>
 <1da4691d-d0da-a620-020c-c2e968c2a5ec@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1da4691d-d0da-a620-020c-c2e968c2a5ec@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 16-12-16 13:15:18, Chris Mason wrote:
> On 12/16/2016 02:39 AM, Michal Hocko wrote:
[...]
> > I believe the right way to go around this is to pursue what I've started
> > in [1]. I will try to prepare something for testing today for you. Stay
> > tuned. But I would be really happy if somebody from the btrfs camp could
> > check the NOFS aspect of this allocation. We have already seen
> > allocation stalls from this path quite recently
> 
> Just double checking, are you asking why we're using GFP_NOFS to avoid going
> into btrfs from the btrfs writepages call, or are you asking why we aren't
> allowing highmem?

I am more interested in the NOFS part. Why cannot this be a full
GFP_KERNEL context? What kind of locks we would lock up when recursing
to the fs via slab shrinkers?
-- 
Michal Hocko
SUSE Labs
