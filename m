Return-Path: <SRS0=bDrN=52=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AB2C2BA2B
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E5B72078E
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDJQIF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 12:08:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:48936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgDJQIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Apr 2020 12:08:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 80E6CAB64;
        Fri, 10 Apr 2020 16:08:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 31C88DA72D; Fri, 10 Apr 2020 18:07:27 +0200 (CEST)
Date:   Fri, 10 Apr 2020 18:07:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: fix improper generation setting in parent node
Message-ID: <20200410160726.GL5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200406145905.112078-1-josef@toxicpanda.com>
 <38f17c0c-1c63-b654-c2c2-88dc37c87cf6@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38f17c0c-1c63-b654-c2c2-88dc37c87cf6@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 10, 2020 at 11:44:43AM -0400, Josef Bacik wrote:
> On 4/6/20 10:59 AM, Josef Bacik wrote:
> > With the delayed ref throttling patches I started getting a lot of
> > "parent transid mismatch" messages when running my snapshot+balance
> > torture test.  This turned out to be because we will unconditionally set
> > the generation of a relocated tree block to the current transaction.
> > 
> > This is generally true, but especially for mid-tree nodes we could have
> > cow'ed the block in a previous transaction, and only actually update
> > it's parents in a completely different transaction.  Thus we end up with
> > a parent transid that is in the future of the actual block.  Fix this by
> > using the generation for the extent buffer we're pointing to.
> > 
> > Fixes: 5d4f98a28c7d ("Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)")
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Dave hold off on this, there's something odd happening that I need to figure 
> out.  Thanks,

Understood. The patch hasn't been in any of the development branches so
far.
