Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD85C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2456F2081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbfCGOBL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:01:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:33672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbfCGOBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 09:01:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9FACAC2C
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 14:01:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2D92EDA83C; Thu,  7 Mar 2019 15:02:24 +0100 (CET)
Date:   Thu, 7 Mar 2019 15:02:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
Message-ID: <20190307140223.GH31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306061907.29685-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 06, 2019 at 02:19:04PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/perf_tree_lock
> Which is based on v5.0-rc7 tag.
> 
> Although we have ftrace/perf to do various performance analyse, under most
> case the granularity is too small, resulting data flood for users.
> 
> This RFC patchset provides a btrfs specific performance profiler.
> It calculates certain function duration and account the duration.
> 
> The result is provided through RO sysfs interface,
> /sys/fs/btrfs/<FSID>/profiler.
> 
> The content of that file is genreated when read.
> Users can have full control on the sample resolution.
> 
> The example content can be found in the last patch.
> 
> One example using the interface to profile fsstress can be found here:
> https://docs.google.com/spreadsheets/d/1BVng8hqyyxFWPQF_1N0cpwiCA6R3SXtDTHmRqo8qyvo/edit?usp=sharing
> 
> The test script can be found here:
> https://gist.github.com/adam900710/ca47b9a8d4b8db7168b261b6fba71ff1
> 
> The interesting result from the graph is:
> - Concurrency on fs tree is only high for the initial 25 seconds
>   My initial expectation is, the hotness on fs tree should be more or
>   less stable. Which looks pretty interesting
> 
> - Then extent tree get more concurrency after 25 seconds
>   This again breaks my expectation. As write to extent tree should only
>   be triggered by delayed ref. So there is something interesting here
>   too.
> 
> - Root tree is pretty cold
>   Since the test is only happening on fs tree, it's expected to be less
>   racy.
>   
> - There is some minor load on other trees.
>   My guess is, that's from csum tree.
> 
> Although the patchset is relatively small, there are some design points
> need extra commends before the patchset get larger and larger.
> 
> - How should this profiler get enabled?
>   Should this feature get enabled by mount option or kernel config?
>   Or just let it run for all kernel build?
>   Currently the overhead should be pretty small, but the overhead should
>   be larger and larger with new telemetry.
> 
> - Design of the interface
>   Is this a valid usage of sysfs or an abuse?
>   And if the content can be improved for both human or program?

Well, most of that is answered by 'figure out how to use tracepoints and
perf for that'.

If there were not a whole substystem, actively maintained and
documented, implementing something like that might help, but that's not
the case.

I see what you were able to understand from the results, but it's more
like a custom analysis tool that should not merged as-is. It brings a
whole new interface and that's always hard to get right with all the
mistakes ahead that somebody has probably solved already.

It would be good to have list of the limitations of perf you see, and we
can find a solution ourselves or ask elsewhere.
