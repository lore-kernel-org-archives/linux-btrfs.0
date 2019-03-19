Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721AFC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C87C2082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfCSSVx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:21:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbfCSSVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 14:21:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93976B040
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 18:21:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 51993DAC36; Tue, 19 Mar 2019 19:23:08 +0100 (CET)
Date:   Tue, 19 Mar 2019 19:23:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
Message-ID: <20190319182308.GP3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319060418.29575-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 02:04:18PM +0800, Qu Wenruo wrote:
> This new tree block flag is to indicate the tree block belongs to a log
> tree.
> 
> For btrfs on-disk format, there are several different trees could use
> the same owner number:
> - ordinary subvolume tree
> - log tree for ordinary subvolume
> - reloc tree for ordinary subvolume
> 
> It's possible to do the backref walk or use the content to determine the
> real owner of the tree block.
> But backref walk is too expensive, content detection is not reliable.
> 
> So adding a new flag to explicitly show the owner of log tree.
> 
> Thankfully, tree-checker hasn't checked header flags yet, and there is
> no real user for this flag yet.
> So we don't need to introduce any compatibility flag for this
> modification.

I think we can't simply skip the backward compatibility here, this is a
change of on-disk format and at least we have to understand what can go
wrong when the combinations of new/old kernel/fs are used.

> The introduction of this new flag makes tree block owner easier to
> distinguish, making life easier for:
> - tree checker on log tree
>   Log tree could contain some items impossible for regular trees
> - performance profiler
>   Now it's much easier to distinguish log tree.

So is this for enhanced correctness or performance helper? I'd tend to
skip the performance part for now, it's not convincing argument for the
on-disk change.

And for the correctness I'd like more details, but the idea sounds good
in general.
