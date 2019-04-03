Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE23C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F882084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfDCOMQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:12:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:44780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727019AbfDCOMN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:12:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15F61AFE9
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:12:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D92C2DA8D8; Wed,  3 Apr 2019 16:13:21 +0200 (CEST)
Date:   Wed, 3 Apr 2019 16:13:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Make write time tree checker
 verify the content of leaves
Message-ID: <20190403141321.GN29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403115919.17049-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 03, 2019 at 07:59:18PM +0800, Qu Wenruo wrote:
> Commit "btrfs: Do mandatory tree block check before submitting bio" is
> designed to check leaves contents, just as read time check.
> 
> However due to the confusing parameter list, "false" is passed to where
> it is supposed to be "true".

And this seems to invalidate all testing since false->true will do
additional expensive checks. I thought I'd fold the fix to the original
patch but in this case it'd be the wrong thing to do due to the visible
effects of the change.
