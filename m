Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9C4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB920213F2
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfCSNG5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:06:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727262AbfCSNG5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 09:06:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87610ACCF
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 13:06:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C16B1DA829; Tue, 19 Mar 2019 14:08:09 +0100 (CET)
Date:   Tue, 19 Mar 2019 14:08:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Avoid possible qgroup_rsv_size overflow in
 btrfs_calculate_inode_block_rsv_size
Message-ID: <20190319130807.GJ3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190318154520.4086-1-nborisov@suse.com>
 <20190318154520.4086-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318154520.4086-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 18, 2019 at 05:45:20PM +0200, Nikolay Borisov wrote:
> qgroup_rsv_size is calculated as the product of
> outstanding_extent * fs_info->nodesize. The product is calculated with
> 32 bith precision since both variables are defined as u32. Yet
> qgroup_rsv_size expects a 64 bit result.
> 
> Avoid possible multiplication overflow by casting outstanding_extent to
> u64.
> 
> Fixes-coverity-id: 1435101
> ff6bc37eb7f6 ("btrfs: qgroup: Use independent and accurate per inode qgroup rsv")

Fixes: hash ("subject")

I've added a note about the worst case when the overflow would happen,
which is 65536 outstanding extents with 64K nodesize. Unlikely to
happen.
