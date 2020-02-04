Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9D1C2D0B1
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 14:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71EFC20730
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 14:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBDO1Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 09:27:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:50678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgBDO1Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Feb 2020 09:27:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E4BAACF0;
        Tue,  4 Feb 2020 14:27:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0F0E4DA80D; Tue,  4 Feb 2020 15:27:10 +0100 (CET)
Date:   Tue, 4 Feb 2020 15:27:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     damenly.su@gmail.com
Cc:     linux-btrfs@vger.kernel.org, Su Yue <Damenly_Su@gmx.com>
Subject: Re: [PATCH] btrfs: update the comment of btrfs_control_ioctl()
Message-ID: <20200204142709.GE2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, damenly.su@gmail.com,
        linux-btrfs@vger.kernel.org, Su Yue <Damenly_Su@gmx.com>
References: <20200204045156.1662-1-Damenly_Su@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204045156.1662-1-Damenly_Su@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 04, 2020 at 12:51:56PM +0800, damenly.su@gmail.com wrote:
> From: Su Yue <Damenly_Su@gmx.com>
> 
> Btrfsctl was removed in 2012, now the function btrfs_control_ioctl()
> is only used for devices ioctls. So update the comment.
> 
> Signed-off-by: Su Yue <Damenly_Su@gmx.com>

Added to misc-next, thanks.
