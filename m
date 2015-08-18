Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36005 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbbHRRMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 13:12:07 -0400
Date: Tue, 18 Aug 2015 13:11:44 -0400
From: Chris Mason <clm@fb.com>
To: Michal Hocko <mhocko@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [RFC -v2 7/8] btrfs: Prevent from early transaction abort
Message-ID: <20150818171144.GA5206@ret.DHCP.TheFacebook.com>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-8-git-send-email-mhocko@kernel.org>
 <20150818104031.GF5033@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150818104031.GF5033@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2015 at 12:40:32PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> Btrfs relies on GFP_NOFS allocation when commiting the transaction but
> since "mm: page_alloc: do not lock up GFP_NOFS allocations upon OOM"
> those allocations are allowed to fail which can lead to a pre-mature
> transaction abort:

I can either put the btrfs nofail ones on my pull for Linus, or you can
add my sob and send as one unit.  Just let me know how you'd rather do
it.

-chris
