Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34834 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbbHFOev (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 10:34:51 -0400
Date: Thu, 6 Aug 2015 16:34:48 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/8] Allow GFP_NOFS allocation to fail
Message-ID: <20150806143447.GD12827@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <A9B287B0-1CDA-4E55-A1D7-46D4BAE16C7F@dilger.ca>

On Wed 05-08-15 20:58:25, Andreas Dilger wrote:
> On Aug 5, 2015, at 3:51 AM, mhocko@kernel.org wrote:
[...]
> > The rest are the FS specific patches to fortify allocations
> > requests which are really needed to finish transactions without RO
> > remounts. There might be more needed but my test case survives with
> > these in place.
> 
> Wouldn't it make more sense to order the fs-specific patches _before_
> the "GFP_NOFS can fail" patch (#3), so that once that patch is applied
> all known failures have already been fixed?  Otherwise it could show
> test failures during bisection that would be confusing.

As I write below. If maintainers consider them useful even when GFP_NOFS
doesn't fail I will reword them and resend. But you cannot fix the world
without breaking it first in this case ;)
 
> > They would obviously need some rewording if they are going to be
> > applied even without Patch3 and I will do that if respective
> > maintainers will take them. Ext3 and JBD are going away soon so they
> > might be dropped but they have been in the tree while I was testing
> > so I've kept them.

-- 
Michal Hocko
SUSE Labs
