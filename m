Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4259EC169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B81B2081B
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfBFPeE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:34:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:51602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729514AbfBFPeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 10:34:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC647B6DC;
        Wed,  6 Feb 2019 15:34:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 62F94DA823; Wed,  6 Feb 2019 16:33:26 +0100 (CET)
Date:   Wed, 6 Feb 2019 16:33:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
Message-ID: <20190206153326.GD2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
> Adds cli and ioctl to forget a scanned device or forget all stale
> devices in the kernel.
> 
> Anand Jain (2):
>   btrfs: refactor btrfs_free_stale_devices() to get return value
>   btrfs: introduce feature to forget a btrfs device

The 2nd patch has been added to misc-next too, I've updated the
changelog a bit. The usecase here is quite small so I don't think we've
missed something crucial on the kernel side. The userspace part can
provide some convenience shortcuts like --forget-all or specifying by
filesystem id where the translation would happen internally, but the
ioctl would cover that. Thanks.
