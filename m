Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBB2C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 16:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB706218B0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 16:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfDXQdO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 12:33:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:57268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730794AbfDXQdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 12:33:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1683DAF56
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 16:33:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 55348DA85E; Wed, 24 Apr 2019 18:34:16 +0200 (CEST)
Date:   Wed, 24 Apr 2019 18:34:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Make btrfs_finish_extent_commit() return void
Message-ID: <20190424163413.GA20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190416051637.18548-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416051637.18548-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 01:16:37PM +0800, Qu Wenruo wrote:
> This function always return 0, and the only use case of @ret is to
> output warning message for discard failure, which doesn't cause anything
> wrong to the fs even discarding failed.
> 
> There is no need to make it return int.

Same comment as https://patchwork.kernel.org/patch/10901977/ , check the
whole callgraph of the function before making it return void.
