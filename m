Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F56C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7869E2075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfDOOfo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:35:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:57282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbfDOOfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 10:35:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17487AE0E;
        Mon, 15 Apr 2019 14:35:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4F987DA9C7; Mon, 15 Apr 2019 16:36:50 +0200 (CEST)
Date:   Mon, 15 Apr 2019 16:36:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove no longer used member num_dirty_bgs from
 transaction
Message-ID: <20190415143649.GJ3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190415082919.2123-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415082919.2123-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 09:29:19AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The member num_dirty_bgs of struct btrfs_transaction is not used anymore,
> it is set and incremented but nothing reads its value anymore. Its last
> read use was removed by commit 64403612b73a94 ("btrfs: rework
> btrfs_check_space_for_delayed_refs"). So just remove that member.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
