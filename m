Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B5FECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872BA21476
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 872BA21476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbeJSVsu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 17:48:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:35558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbeJSVsu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 17:48:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58A44AEC2
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 13:42:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8D595DAF50; Fri, 19 Oct 2018 15:42:31 +0200 (CEST)
Date:   Fri, 19 Oct 2018 15:42:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
Message-ID: <20181019134230.GH16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018111729.11128-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 07:17:23PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
> 
> Which is still based on v4.19-rc1, but with previous submitted patches
> as dependency.

Please rebase this patchset on top of misc-4.20, this should not change
as it's going to be the 1st pull.

I tried to pull the git branch and rebase but there were several
conflicts and some of the paches appeared duplicated so the rebase did
not recognize the changes as identical.

Applying patches from mails causes other sort of conflicts and I can't
seem to get a compilable version.

This is not urgent as I want to put the patchset to a topic branch and
give it some testing before it goes to for-next. Thanks.
