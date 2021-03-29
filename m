Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257C5C433C1
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDBC6044F
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhC2S4L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:56:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:47338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhC2Szr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:55:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 400EFB000;
        Mon, 29 Mar 2021 18:55:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 502B5DA842; Mon, 29 Mar 2021 20:53:38 +0200 (CEST)
Date:   Mon, 29 Mar 2021 20:53:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/13] btrfs: support read-write for subpage metadata
Message-ID: <20210329185338.GV7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210325071445.90896-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325071445.90896-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 25, 2021 at 03:14:32PM +0800, Qu Wenruo wrote:
> v3:
> - Rename the sysfs to supported_sectorsizes
> 
> - Rebased to latest misc-next branch
>   This removes 2 cleanup patches.
> 
> - Add new overview comment for subpage metadata

V3 is now in for-next, targeting merge for 5.13. Please post any fixups
as replies to the individual patches, I'll fold them in, rather a full
series resend. Thanks.
