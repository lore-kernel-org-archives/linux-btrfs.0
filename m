Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27E9C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 16:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BA4721738
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 16:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfBSQa0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:30:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:58042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728984AbfBSQa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 11:30:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE17DB12B;
        Tue, 19 Feb 2019 16:30:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3F5DADA83C; Tue, 19 Feb 2019 17:31:46 +0100 (CET)
Date:   Tue, 19 Feb 2019 17:31:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Robertson <dan@dlrobertson.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs: init csum_list before possible free
Message-ID: <20190219163144.GR9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Robertson <dan@dlrobertson.com>,
        linux-btrfs@vger.kernel.org
References: <20190219025643.20382-1-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219025643.20382-1-dan@dlrobertson.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 02:56:43AM +0000, Dan Robertson wrote:
> The scrub_ctx csum_list member must be initialized before
> scrub_free_ctx is called. If the csum_list is not initialized
> beforehand, the list_empty call in scrub_free_csums will result
> in a null deref.
> 
> Signed-off-by: Dan Robertson <dan@dlrobertson.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks, it's been there since the first merge of scrub, but hard to hit.
