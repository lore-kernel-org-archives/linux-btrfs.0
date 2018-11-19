Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A08DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1191920851
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1191920851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbeKTCNB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 21:13:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:49304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729669AbeKTCNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 21:13:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A430B008
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 15:49:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4D3E0DAF89; Mon, 19 Nov 2018 16:48:43 +0100 (CET)
Date:   Mon, 19 Nov 2018 16:48:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, jeffm@suse.com
Subject: Re: [PATCH] btrfs: Add sysfs support for metadata_uuid feature
Message-ID: <20181119154842.GF24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, jeffm@suse.com
References: <20181119153745.7248-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119153745.7248-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 05:37:45PM +0200, Nikolay Borisov wrote:
> Since the metadata_uuid is a new incompat feature it requires the
> respective sysfs hooks. This patch adds the 'metdata_uuid' feature to
> be shown if it supported by the kernel. Additionally it adds
> /sys/fs/btrfs/UUID/metadata_uuid attribute which allows one to read
> the current metadata_uuid.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> I completely forgot sysfs also needs to be hooked so here it is. 

Thanks,

Reviewed-by: David Sterba <dsterba@suse.com>

I'll add it right after the commit that introduces the METADATA_UUID
bit.
