Return-Path: <SRS0=EJVa=44=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B34C10DCE
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9B1222C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCKA37 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:29:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:46718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbgCKA36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 20:29:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F048B049;
        Wed, 11 Mar 2020 00:29:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 51E86DA7A7; Wed, 11 Mar 2020 01:29:32 +0100 (CET)
Date:   Wed, 11 Mar 2020 01:29:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove __ prefix from btrfs_block_rsv_release
Message-ID: <20200311002932.GA12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200310085931.16478-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310085931.16478-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 10, 2020 at 10:59:31AM +0200, Nikolay Borisov wrote:
> Currently the non-prefixed version is a simple wrapper used to hide
> the 4th argument of the prefixed version. This doesn't bring much value
> in practice and only makes the code harder to follow by adding another
> level of indirection. Rectify this by removing the __ prefix and
> have only one public function to release bytes from a block reservation.
> No semantic changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Makes sense, added to misc-next, thanks.
