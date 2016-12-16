Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:33185 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761841AbcLPP6V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 10:58:21 -0500
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Date: Fri, 16 Dec 2016 16:58:06 +0100
Message-Id: <20161216155808.12809-1-mhocko@kernel.org>
In-Reply-To: <20161216073941.GA26976@dhcp22.suse.cz>
References: <20161216073941.GA26976@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 16-12-16 08:39:41, Michal Hocko wrote:
[...]
> That being said, the OOM killer invocation is clearly pointless and
> pre-mature. We normally do not invoke it normally for GFP_NOFS requests
> exactly for these reasons. But this is GFP_NOFS|__GFP_NOFAIL which
> behaves differently. I am about to change that but my last attempt [1]
> has to be rethought.
> 
> Now another thing is that the __GFP_NOFAIL which has this nasty side
> effect has been introduced by me d1b5c5671d01 ("btrfs: Prevent from
> early transaction abort") in 4.3 so I am quite surprised that this has
> shown up only in 4.8. Anyway there might be some other changes in the
> btrfs which could make it more subtle.
> 
> I believe the right way to go around this is to pursue what I've started
> in [1]. I will try to prepare something for testing today for you. Stay
> tuned. But I would be really happy if somebody from the btrfs camp could
> check the NOFS aspect of this allocation. We have already seen
> allocation stalls from this path quite recently

Could you try to run with the two following patches?
