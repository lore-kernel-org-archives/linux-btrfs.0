Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D948FC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A92F62171F
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfABRJT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 12:09:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:49658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727424AbfABRJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 12:09:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1084FAE1D
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Jan 2019 17:09:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8F9EBDA781; Wed,  2 Jan 2019 18:08:49 +0100 (CET)
Date:   Wed, 2 Jan 2019 18:08:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Misc cleanups of btrfs_get_extent
Message-ID: <20190102170849.GB23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181217083602.10166-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217083602.10166-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 10:35:58AM +0200, Nikolay Borisov wrote:
> Here is a series that hopefully makes the code a bit more obvious. First patch 
> gives a variable a more appropraite name, since it's going to be used only for 
> holding an extent type and not the type of a found item. 
> 
> Patch 2 simply consolidated separate 'if' statements that check the retval of
> the same function into a single 'if() {} else if () {}' statement. IMO this is 
> cleaner.
> 
> Patch 3 massages the abhorrent code that deals with btrfs_lookup_file_extent
> retval. It groups everything in a coherent 'if() {} else if () {} else {}' 
> construct and now it's obvious under what conditions specific code is executed. 
> 
> Finally, Patch 4 removes the not_found_em labelin the same function.
> 
> Nikolay Borisov (4):
>   btrfs: Rename found_type to extent_type
>   btrfs: Consolidate retval checking of core btree functions
>   btrfs: Refactor retval handling of btrfs_lookup_file_extent in
>     btrfs_get_extent
>   btrfs: Remove not_found_em label from btrfs_get_extent

1, 2 and 4 now added to for-next, thanks.
