Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B71C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E5ED20818
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfDKSTJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:19:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:36610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbfDKSTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 14:19:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0ECC3AD3E;
        Thu, 11 Apr 2019 18:19:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9D44DA85B; Thu, 11 Apr 2019 20:20:15 +0200 (CEST)
Date:   Thu, 11 Apr 2019 20:20:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove redundant inode argument from
 btrfs_add_ordered_sum
Message-ID: <20190411182014.GD3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190410131611.18149-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410131611.18149-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 04:16:11PM +0300, Nikolay Borisov wrote:
> Ordered csums are keyed off of a btrfs_ordered_extent, which already
> has a reference to the inode. This implies that an explicit inode
> argument is redundant. So remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
