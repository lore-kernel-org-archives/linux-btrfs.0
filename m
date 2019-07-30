Return-Path: <SRS0=c8Io=V3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BF5C433FF
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 17:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941D22087F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 17:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfG3RiP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jul 2019 13:38:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:48514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbfG3RiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jul 2019 13:38:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E5BAAD45
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2019 17:38:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5C9B7DA808; Tue, 30 Jul 2019 19:38:49 +0200 (CEST)
Date:   Tue, 30 Jul 2019 19:38:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 09/17] progs: pass in a btrfs_mkfs_config to
 write_temp_extent_buffer
Message-ID: <20190730173849.GJ28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <cover.1564046812.git.jthumshirn@suse.de>
 <042f116c565320bc134a6bca5b5d91b0754a19a8.1564046972.git.jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <042f116c565320bc134a6bca5b5d91b0754a19a8.1564046972.git.jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 25, 2019 at 11:33:56AM +0200, Johannes Thumshirn wrote:
> Pass in a btrfs_mkfs_config to write_temp_extent_buffer(), this is needed
> so we can grab the checksum type for checksum buffer verification in later
> patches.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Added to devel.
