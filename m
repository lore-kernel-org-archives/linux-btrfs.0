Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbHEQcS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 12:32:18 -0400
Date: Wed, 5 Aug 2015 18:31:54 +0200
From: David Sterba <dsterba@suse.com>
To: mhocko@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC 7/8] btrfs: Prevent from early transaction abort
Message-ID: <20150805163154.GA31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-8-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438768284-30927-8-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 11:51:23AM +0200, mhocko@kernel.org wrote:
> From: Michal Hocko <mhocko@suse.com>
... 
> Fix this by reintroducing the no-fail behavior of this allocation path
> with the explicit __GFP_NOFAIL.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
