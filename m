Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192B6C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D922B20672
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D922B20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409874AbeKWXZS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 18:25:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:37786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405500AbeKWXZS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 18:25:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1E21AD6B
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 12:41:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6AE33DA858; Fri, 23 Nov 2018 13:40:57 +0100 (CET)
Date:   Fri, 23 Nov 2018 13:40:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove btrfs_bio_end_io_t
Message-ID: <20181123124057.GA2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181123084227.25840-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181123084227.25840-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 23, 2018 at 09:42:27AM +0100, Johannes Thumshirn wrote:
> The btrfs_bio_end_io_t typedef was introduced with commit
> a1d3c4786a4b ("btrfs: btrfs_multi_bio replaced with btrfs_bio")
> but never used anywhere. This commit also introduced a forward declaration
> of 'struct btrfs_bio' which is only needed for btrfs_bio_end_io_t.
> 
> Remove both as they're not needed anywhere.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Added to misc-next, thanks.
