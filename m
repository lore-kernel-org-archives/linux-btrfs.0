Return-Path: <SRS0=Px4L=ZL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE0DC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 16:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B33A2082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 16:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfKSQYk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:24:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:55392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727646AbfKSQYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Nov 2019 11:24:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D14FB355;
        Tue, 19 Nov 2019 16:24:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7876CDA783; Tue, 19 Nov 2019 17:24:39 +0100 (CET)
Date:   Tue, 19 Nov 2019 17:24:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix error messages in qgroup_rescan_init
Message-ID: <20191119162438.GV3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191118121644.15289-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118121644.15289-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 18, 2019 at 02:16:44PM +0200, Nikolay Borisov wrote:
> The branch of qgroup_rescan_init which is executed from the mount
> path prints wrong errors messages. The textual print out in case
> BTRFS_QGROUP_STATUS_FLAG_RESCAN/BTRFS_QGROUP_STATUS_FLAG_ON are not
> set are transposed. Fix it by exchanging their place.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I'll apply the patch now as it's a clear fix, dropping the messages can
go separately.
