Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB7DC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 557E9206DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfLCTcX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:32:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:38308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727349AbfLCTcX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 14:32:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CDCB6B2BA6;
        Tue,  3 Dec 2019 19:32:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D799DA7D9; Tue,  3 Dec 2019 20:32:15 +0100 (CET)
Date:   Tue, 3 Dec 2019 20:32:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     jeffm@suse.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
Message-ID: <20191203193214.GA2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        jeffm@suse.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <930692de-a07d-bae8-b09d-979fc2fd0427@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930692de-a07d-bae8-b09d-979fc2fd0427@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 28, 2019 at 11:28:58AM +0800, Qu Wenruo wrote:
> Any feedback and update on this patchset?
> 
> It looks like the first patch is going to fix a bug of btrfs unable to
> unmount the fs due to deadlock rescan.

The patchset was posted 1.5 year ago, it would be better to resend. I
think there were some changes in the quota rescan, there were also some
replies to the thread so fresh iteration can continue the discussion.
Thanks.
