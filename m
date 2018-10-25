Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF8EC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29C4A2084A
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:57:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29C4A2084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbeJZBbG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 21:31:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:47304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727775AbeJZBbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 21:31:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A75CAE29
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 16:57:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5EAD6DA781; Thu, 25 Oct 2018 18:57:18 +0200 (CEST)
Date:   Thu, 25 Oct 2018 18:57:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: Minor qgroup subcommand usage update
Message-ID: <20181025165717.GI16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180806060008.9556-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180806060008.9556-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 06, 2018 at 02:00:05PM +0800, Qu Wenruo wrote:
> It turns out even commit e5a6610c943b ("btrfs-progs: qgroup assign: add
> option to schedule rescan") introduced the ability to auto rescan, it's
> less known option and even some developer find it hard to understand.
> (Well, the whole quota thing is already a little hard to understand)
> 
> Thus it makes more sense to make --rescan as default behavior, and add
> more explanation on why quota rescan is needed, and under which case we
> can skip the rescan.
> 
> Qu Wenruo (3):
>   btrfs-progs: cmds-qgroup: Use bool to replace int for @rescan
>   btrfs-progs: qgroup: make --rescan as the default behavior for assign
>   btrfs-progs: Doc: Update btrfs-qgroup for the rescan condition

Applied, thanks. I reworded some parts, so don't be surprised that there
are changes.
