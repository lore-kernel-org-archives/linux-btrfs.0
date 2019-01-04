Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EF5C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BDB82087F
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfADPBr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:01:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:51980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbfADPBr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:01:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB2E2AFAF
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 15:01:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9523DA7CE; Fri,  4 Jan 2019 16:01:16 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:01:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Cleanups around btrfs_get_extent_fiemap
Message-ID: <20190104150116.GN23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212074234.20613-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212074234.20613-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 09:42:31AM +0200, Nikolay Borisov wrote:
> Following a conversation with Johaness this is what fell out. Turns out the
> signature of btrfs_get_extent_fiemap is needlessly complext. So the first patch 
> fixes it by removing the unnecessary arguments. Patch 2 is a bit of a "catch-all"
> mainly renaming variables, thus helping recognise what the code does and
> refreshing comments and removing one extra if. Finally, patch 3 removes an
> assignment making it (at least to me) more clear what context a particular
> variable is used in.
> 
> This has survived multiple xfstest runs. 
> 
> Nikolay Borisov (3):
>   btrfs: Remove unused arguments from btrfs_get_extent_fiemap
>   btrfs: Refactor btrfs_get_extent_fiemap
>   btrfs: Remove redundant assignment

1-3 added to misc-next, thanks. I did a few more adjustments to comments
in patch 2/3.
