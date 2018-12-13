Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5697AC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C182080F
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23C182080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbeLMQdX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:33:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:38756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727942AbeLMQdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 11:33:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 60DF5AF3F
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 16:33:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AD8A3DA7EE; Thu, 13 Dec 2018 17:32:59 +0100 (CET)
Date:   Thu, 13 Dec 2018 17:32:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs: improve error handling of btrfs_add_link()
Message-ID: <20181213163259.GF23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181212141417.17417-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212141417.17417-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 03:14:17PM +0100, Johannes Thumshirn wrote:
> err holds the return value of either btrfs_del_root_ref() or
> btrfs_del_inode_ref() but it hasn't been checked since it's
> introduction with commit fe66a05a0679 (Btrfs: improve error handling
> for btrfs_insert_dir_item callers) in 2012.
> 
> To quote David:
> 
> "If the error handling in the error handling fails, there's not much left to do
> and the abort either happened earlier in the callees or is necessary here."
> 
> So if one of btrfs_del_root_ref() or btrfs_del_inode_ref() failed, abort the
> transaction.
> 
> Link: https://lore.kernel.org/linux-btrfs/20181126183759.GJ2842@twin.jikos.cz/
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks. I've updated the changelog a bit follwing the discussion we had
under the previous iterations.

Reviewed-by: David Sterba <dsterba@suse.com>
