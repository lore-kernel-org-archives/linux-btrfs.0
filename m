Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21733C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E415B20989
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E415B20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbeK2CqV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 21:46:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:44670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728217AbeK2CqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 21:46:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30170AE49
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 15:44:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B6A5FDAC7F; Wed, 28 Nov 2018 16:43:58 +0100 (CET)
Date:   Wed, 28 Nov 2018 16:43:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Misc cosmetic changes for
 map_private_extent_buffer
Message-ID: <20181128154357.GR2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181128085456.5702-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128085456.5702-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:54:53AM +0100, Johannes Thumshirn wrote:
> While trying to understand the checksum code I came across some oddities
> regarding map_private_extent_buffer() and it's interaction with
> csum_tree_block().
> 
> These patches address them but are either purely cosmetic or only add a
> comment documenting behaviour.
> 
> Changes to v1:
> * Add Reviewed-by tags
> * Change wording of commit message in patch 3/3
> 
> Johannes Thumshirn (3):
>   btrfs: don't initialize 'offset' in map_private_extent_buffer()
>   btrfs: use offset_in_page for start_offset in
>     map_private_extent_buffer()
>   btrfs: document extent mapping assumptions in checksum

1 and 3 applied, thanks.
