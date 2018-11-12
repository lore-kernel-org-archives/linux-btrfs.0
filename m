Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882C8C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49B42224E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49B42224E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbeKMEpb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:45:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:51654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbeKMEpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:45:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 226D8AFE2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 18:51:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E932BDAFAE; Mon, 12 Nov 2018 19:50:45 +0100 (CET)
Date:   Mon, 12 Nov 2018 19:50:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Check for missing device before bio submission in
 btrfs_map_bio
Message-ID: <20181112185045.GN24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108141638.31681-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108141638.31681-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 04:16:38PM +0200, Nikolay Borisov wrote:
> Before btrfs_map_bio submits all stripe bio it does a number of checks
> to ensure the device for every stripe is present. However, it doesn't
> do a DEV_STATE_MISSING check, instead this is relegated to the lower
> level btrfs_schedule_bio (in the async submission case, sync submission
> doesn't check DEV_STATE_MISSING at all). Additionally
> btrfs_schedule_bios does the duplicate device->bdev check which has
> already been performed in btrfs_map_bio.
> 
> This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
> removes the duplicate device->bdev check. Doing so ensures that no bio
> cloning/submission happens for both async/sync requests in the face of
> missing device. This makes the async io submission path slightly shorter
> in terms of instruction count. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
