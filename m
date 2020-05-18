Return-Path: <SRS0=lV6b=7A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED6BC433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 May 2020 17:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E868D20758
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 May 2020 17:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgERRB6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:01:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:59254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgERRB6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 May 2020 13:01:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6C4DAC51;
        Mon, 18 May 2020 17:01:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 28B7EDA7AD; Mon, 18 May 2020 19:01:03 +0200 (CEST)
Date:   Mon, 18 May 2020 19:01:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: reduce lock contention when create snapshot
Message-ID: <20200518170102.GY18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <20200514091918.30294-1-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514091918.30294-1-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 14, 2020 at 05:19:18PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When creating a snapshot, it takes a long time because
> flush dirty data is required.
> 
> But we have taken two resources as shown below:
> 1. Destination directory inode lock
> 2. Global subvol semaphore
> 
> This will cause subvol destroy/create/setflag blocked,
> until the snapshot is created.
> 
> We fix by flush dirty data first to reduce the time of
> the critical section, and then lock the relevant resources.

A bit hard to follow what gets moved where but I got it in the end.
Flushing data before snapshotting does not depend on the directory lock
nor on the subvol semaphore so moving it out is fine.

This should also speed up creating new subvolumes as they don't need any
pre-flushing at all. Added to misc-next, thanks.
