Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAD5C3F2D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D002469F
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgB1PqS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:46:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:46182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgB1PqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 10:46:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A3E9AD9A;
        Fri, 28 Feb 2020 15:46:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 21287DA79B; Fri, 28 Feb 2020 16:45:56 +0100 (CET)
Date:   Fri, 28 Feb 2020 16:45:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] btrfs: relocation: Refactor build_backref_tree()
Message-ID: <20200228154555.GN2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200226055652.24857-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226055652.24857-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 26, 2020 at 01:56:42PM +0800, Qu Wenruo wrote:
> This branch can be fetched from github:
> https://github.com/adam900710/linux/tree/backref_cache_new

This is based on v5.6-rc1, you should base on something more recent.
There are many non-trivial conflicts at patch 5 so I stopped there but
if you and I like to get the pathes merged, the branch needs to be in a
state where it's not that hard to apply the patches.

Minor conflicts are expected, like obvious differences in context or
renames, there are tools that can deal with that automatically (I use
wiggle).

The branch also contains unrelated patches to the backref code, some of
them either upstream or in misc-next. All of that makes it unnecessarily
hard to get the patches to for-next when the time comes (reviews, patch
backlog processed).
