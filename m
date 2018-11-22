Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAF5C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FC6D206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FC6D206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436912AbeKWAPi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 19:15:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:53640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391433AbeKWAPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 19:15:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B8EDAAAE
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 13:36:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E0D14DA871; Thu, 22 Nov 2018 14:35:55 +0100 (CET)
Date:   Thu, 22 Nov 2018 14:35:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: improve error handling of btrfs_add_link()
Message-ID: <20181122133555.GR24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181122131528.19421-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122131528.19421-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 02:15:28PM +0100, Johannes Thumshirn wrote:
> err holds the return value of either btrfs_del_root_ref() or
> btrfs_del_inode_ref() but it hasn't been checked since it's
> introduction with commit fe66a05a0679 (Btrfs: improve error handling
> for btrfs_insert_dir_item callers) in 2012.
> 
> The first attempt in removing the variable was rejected, so instead of
> removing 'err', start handling the errors of
> btrfs_del_root_ref()/btrfs_del_inode_ref() by aborting the transaction in
> btrfs_add_link() directly instead of the call-sites.

... which is an anti-pattern.

https://btrfs.wiki.kernel.org/index.php/Development_notes#Error_handling_and_transaction_abort

In case there are several conditons that can fail we want to see the
first one for later analysis and debugging.
