Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F57AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DACF420851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfCGQKv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:10:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:58566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfCGQKv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 11:10:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04D65AC69;
        Thu,  7 Mar 2019 16:10:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5F620DA83C; Thu,  7 Mar 2019 17:12:06 +0100 (CET)
Date:   Thu, 7 Mar 2019 17:12:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
Message-ID: <20190307161203.GJ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-perf-users@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
 <20190307140223.GH31119@twin.jikos.cz>
 <ccf67c41-752a-6812-0de7-34f39c37ecac@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccf67c41-752a-6812-0de7-34f39c37ecac@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 07, 2019 at 10:18:49PM +0800, Qu Wenruo wrote:
> > Well, most of that is answered by 'figure out how to use tracepoints and
> > perf for that'.
> > 
> > If there were not a whole substystem, actively maintained and
> > documented, implementing something like that might help, but that's not
> > the case.
> > 
> > I see what you were able to understand from the results, but it's more
> > like a custom analysis tool that should not merged as-is. It brings a
> > whole new interface and that's always hard to get right with all the
> > mistakes ahead that somebody has probably solved already.
> > 
> > It would be good to have list of the limitations of perf you see, and we
> > can find a solution ourselves or ask elsewhere.
> 
> Add linux-perf-users mail list.
> 
> I should mention the problem of ftrace (or my perf skill) in cover letter.
> 
> The biggest problem is the conflicts between detailed function execution
> duration and classification.
> 
> For tree lock case, indeed we can use function graph to get execution
> duration of btrfs_tree_read_lock() and btrfs_tree_lock().
> But that's all. We can't really do much classification.
> 
> If just use trace event, with trace event added, then we can't get the
> execution duration.

I think you can save the start and end times and put the delta to the
tracepoint output.
