Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9C9C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 475992087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbfA3Qly (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:41:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:32900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731991AbfA3Qlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:41:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C902BAC91;
        Wed, 30 Jan 2019 16:41:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6C89FDA78C; Wed, 30 Jan 2019 17:41:18 +0100 (CET)
Date:   Wed, 30 Jan 2019 17:41:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 6/8] btrfs: loop in inode_rsv_refill
Message-ID: <20190130164118.GV2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181203152459.21630-7-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203152459.21630-7-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 10:24:57AM -0500, Josef Bacik wrote:
> With severe fragmentation we can end up with our inode rsv size being
> huge during writeout, which would cause us to need to make very large
> metadata reservations.  However we may not actually need that much once
> writeout is complete.  So instead try to make our reservation, and if we
> couldn't make it re-calculate our new reservation size and try again.
> If our reservation size doesn't change between tries then we know we are
> actually out of space and can error out.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

This patch still has some non-trivial feedback without a response, the
other patches are ready for merge.
