Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9F3C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E9320666
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20E9320666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbeIZUjZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:39:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:53934 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726994AbeIZUjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 16:39:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0FE4AD1A;
        Wed, 26 Sep 2018 14:26:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9362DAE2F; Wed, 26 Sep 2018 16:26:09 +0200 (CEST)
Date:   Wed, 26 Sep 2018 16:26:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Reduce dirty extents for metadata
Message-ID: <20180926142609.GJ3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180926140611.GH3255@twin.jikos.cz>
 <826bce7c-fec1-9315-0362-f67b53d55673@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <826bce7c-fec1-9315-0362-f67b53d55673@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 10:17:13PM +0800, Qu Wenruo wrote:
> >> Before this patch, quota will mark the whole subtree from its parent
> >> down to the leaves as dirty.
> >> So btrfs quota need to trace all tree block from (a) to (g).
> > 
> > I find the use of 'trace' a bit confusing as there are the trace events,
> > but as it's already used in the qgroup code I think it can stay as is.
> 
> I'm pretty open to rename the word "trace".
> 
> Any recommendation for a newer name?

No, we can rename the functions later if needed.

> >> However tree blocks (d) (e) (f) are shared between both trees, thus
> >> there is no need to trace those 3 tree blocks.
> >>
> >> This patchset will change how this work by only tracing modified tree
> >> blocks in reloc tree, and their counter parts in file tree.
> >>
> >> With this patch, we could skip tree blocks OO(d)~OO(f) in above example,
> >> thus reduce some some overhead caused by qgroup.
> >>
> >> The improvement is mostly related to metadata relocation.
> >>
> >> Also, for metadata relocation, we don't really need to trace data
> >> extents as they're not modified at all.
> >>
> >>
> >> [[Benchmark]]
> > [...]
> > 
> > Thanks for the benchmarks, it would be good to add the information to
> > the patch that's bringing the performance improvement.
> 
> Could do that.
> 
> However the current improved (from around 10 * nr_relocated to 6~7 *
> nr_relocated) is the final result of the last 4 patches.
> 
> I'm not pretty sure if any single patch could bring obvious improvement.

Patch 5 would be a good candidate, noting that further patches bring
more performance improvements.
