Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20EDC67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F30205F4
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73F30205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbeJYAZc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 20:25:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:49098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbeJYAZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 20:25:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9C70AFFA;
        Wed, 24 Oct 2018 15:56:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4B1FBDABAA; Wed, 24 Oct 2018 17:55:02 +0200 (CEST)
Date:   Wed, 24 Oct 2018 17:55:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix compile warning when using gcc8 to
 compile btrfs-progs
Message-ID: <20181024155502.GY16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181012074153.3844-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012074153.3844-1-suyj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 03:41:53PM +0800, Su Yanjun wrote:
> When using gcc8 to compile btrfs-progs, it complains as below:
> 
> ctree.c: In function 'btrfs_search_slot_for_read':
>     ctree.c:1249:45: warning: passing argument 3 of 'btrfs_search_slot'
>     discards 'const' qualifier from pointer target type
>     [-Wdiscarded-qualifiers]
>              ret = btrfs_search_slot(NULL, root, key, p, 0, 0);
> 
> Change btrfs_search_slot prototype with 'const' qualifier for argument 3.
> Also fix similar problems as above change.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Applied with subject line changed, thanks.
