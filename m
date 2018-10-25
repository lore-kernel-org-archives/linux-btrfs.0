Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474FBC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72C62083E
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E72C62083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbeJZAhM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 20:37:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:37830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727400AbeJZAhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 20:37:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6995FAEE3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 16:03:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B8788DA781; Thu, 25 Oct 2018 18:03:38 +0200 (CEST)
Date:   Thu, 25 Oct 2018 18:03:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH v2 0/6] btrfs-progs: print-tree: Minor enhancement along
 with --bfs/--dfs options
Message-ID: <20181025160337.GG16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, nborisov@suse.com
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 10:04:40AM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/dump_tree_enhance
> 
> The main point of this patchset is to allow "btrfs ins dump-tree" to
> print tree blocks in breadth-first order when level is higher than 2.
> 
> The 1st patch is just a minor cleanup, to remove some unused and
> meaningless output.
> 
> The 2nd patch does a root<->fs_info cleanup, provides the basis for
> later btrfs_next_sibling_tree_block().
> 
> The 3rd patch implements a new function, btrfs_next_sibling_tree_block()
> to find next sibling tree block, other than leaf.
> 
> The 4th patch implements BFS as bfs_print_children().
> 
> The BFS search itself is implemented using path along with
>  path::lowest_level and btrfs_next_sibling_tree_block() to iterate all
> sibling tree blocks in a level.
> 
> The 5th patch adds --bfs/--dfs options for dump-tree.
> 
> The final patch changes @follow type from int to bool.
> 
> Changelog:
> v2:
>   Make bfs/dfs selectable by adding --bfs and --dfs options.
>   Still keep dfs as default (although I really don't see any
>   compatibility problem)

Let's do it in two steps: first introduce the bfs/dfs modes and switch
the default eventually if it proves more useful over time.

I'm going to apply the patches, with Nikolay's reviewed-by for patches
1-5 as the code is equivalent to what he acked in v1.
