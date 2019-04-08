Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F7AC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 23:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5139820883
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 23:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfDHXhI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:37:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:60188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbfDHXhH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 19:37:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5EA9AD6D
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Apr 2019 23:37:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 51391DA88B; Tue,  9 Apr 2019 01:38:14 +0200 (CEST)
Date:   Tue, 9 Apr 2019 01:38:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
Message-ID: <20190408233814.GF29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190402094554.8353-1-wqu@suse.com>
 <20190403154354.GR29086@twin.jikos.cz>
 <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 08:56:15AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/3 下午11:43, David Sterba wrote:
> > On Tue, Apr 02, 2019 at 05:45:54PM +0800, Qu Wenruo wrote:
> >> There are two tree lock events which can sleep:
> >> - btrfs_tree_read_lock()
> >> - btrfs_tree_lock()
> >>
> >> Sometimes we may need to look into the concurrency picture of the fs.
> >> For that case, we need the execution time of above two functions and the
> >> owner of @eb.
> >>
> >> Here we introduce a trace events for user space tools like bcc, to get
> >> the execution time of above two functions, and get detailed owner info
> >> where eBPF code can't.
> >>
> >> All the overhead is hidden behind the trace events, so if events are not
> >> enabled, there is no overhead.
> >>
> >> Also, since this patch and later user space tool only cares about the
> >> execution time and owner, other info like bytenr is ignored in this
> >> events.
> > 
> > The time is definetelly the interesting part here, I'm thinking if the
> > block number could also provide some useful hints. The gathered trace
> > data can be used to group by blocks to compare the times, or see the
> > histogram of times.
> > 
> > The block at minimum would be useful and I don't want to add more
> > information there, like level or nritems. In case we do want that
> > information, a heavier tracepoint version should be added with all the
> > other data.
> 
> The block number is not that useful in current form.
> As a block number can be the same while contains data for different
> trees between different transactions.

Right, so the generation would have to be printed too, that's more than
I'd thought.

> That's the reason why owner makes more sense in this situation.
> 
> To make block number makes sense, we need to pair
> trace_btrfs_tree_lock() with trace_btrfs_tree_unlock().
> 
> 
> > 
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> [snip]
> >> +	),
> >> +
> >> +	TP_printk_btrfs("start_ns=%llu end_ns=%llu owner=%llu is_log_tree=%d",
> >> +		__entry->start_ns, __entry->end_ns, __entry->owner,
> >> +		__entry->is_log_tree)
> > 
> > I think the delta between start_ns and end_ns should be printed too, so
> > it's obvious without further processing:
> 
> My idea is to put that processing part into user space.
> So we can reduce the space usage of the event buffer.
> 
> But it will do no harm anyway, so I'll add the output.

Postprocessing is always an option, but the calculated value is more for
a quick glance or simply is suitable for copy&paste of the trace log.
