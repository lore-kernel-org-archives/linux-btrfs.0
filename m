Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40CFC169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 14:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A9520857
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 14:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfBHOC5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:02:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:46110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727677AbfBHOC5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 09:02:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CB74AEF6
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2019 14:02:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D3BA4DA83D; Fri,  8 Feb 2019 15:02:17 +0100 (CET)
Date:   Fri, 8 Feb 2019 15:02:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [Patch v5 1/7] btrfs: qgroup: Move reserved data account from
 btrfs_delayed_ref_head to btrfs_qgroup_extent_record
Message-ID: <20190208140215.GO2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190123071518.2528-1-wqu@suse.com>
 <20190123071518.2528-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123071518.2528-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 03:15:12PM +0800, Qu Wenruo wrote:
> Fixes: f64d5ca86821 ("btrfs: delayed_ref: Add new function to record reserved space into delayed ref")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This patch was not part of the other qgroup changes, but I'll queue it
for 5.1 after it passes tests. Please let me know if there are any known
problems or updates to the patch I could have missed. Thanks.
