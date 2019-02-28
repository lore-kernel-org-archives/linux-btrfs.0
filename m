Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265D3C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30E02083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfB1Nui (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:50:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:41234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbfB1Nui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 08:50:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A29D1ACAD
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 13:50:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 325C3DA944; Thu, 28 Feb 2019 14:51:58 +0100 (CET)
Date:   Thu, 28 Feb 2019 14:51:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: trace: Add trace events for extent_io_tree
Message-ID: <20190228135157.GE31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228100255.10953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228100255.10953-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 06:02:53PM +0800, Qu Wenruo wrote:
> 2) No way to distinguish between different btrfs filesystems
>    Due to the fact that we can't get fs_info easily from extent_io_tree,
>    there is no way to distinguish events from different fses.
>    To avoid extra noise, please ensure there is only one btrfs in your
>    test environment.

The id of the filesystem is IMO important for tracepoints, I think we
can live with the 8 bytes of fs_info pointer in extent_io_tree.
