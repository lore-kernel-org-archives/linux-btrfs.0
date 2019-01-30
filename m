Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE053C282D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8510020989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbfA3Q6J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:58:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:36108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732159AbfA3Q6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:58:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 48E5FAD3F
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 16:58:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F30E6DA78C; Wed, 30 Jan 2019 17:57:28 +0100 (CET)
Date:   Wed, 30 Jan 2019 17:57:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Remove duplicated trace points for
 qgroup_rsv_add/release()
Message-ID: <20190130165726.GW2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181113070508.3463-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113070508.3463-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 03:05:08PM +0800, Qu Wenruo wrote:
> Inside qgroup_rsv_add/release(), we have trace events
> trace_qgroup_update_reserve() to catch reserved space update.
> 
> However we still have two manual trace_qgroup_update_reserve() calls
> just outside these functions.
> 
> Remove these duplicated calls.
> 
> Fixes: 64ee4e751a1c ("btrfs: qgroup: Update trace events to use new separate rsv types")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
