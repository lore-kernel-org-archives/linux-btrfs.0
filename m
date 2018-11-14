Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B22C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 17:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A412089F
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 17:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8A412089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbeKODSD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 22:18:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:37156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727830AbeKODSD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 22:18:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B060AD17;
        Wed, 14 Nov 2018 17:13:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E932CDACE4; Wed, 14 Nov 2018 18:13:43 +0100 (CET)
Date:   Wed, 14 Nov 2018 18:13:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: ensure path name is null terminated at
 btrfs_control_ioctl
Message-ID: <20181114171343.GI24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181114113524.7102-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114113524.7102-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 11:35:24AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were using the path name received from user space without checking that
> it is null terminated. While btrfs-progs is well behaved and does proper
> validation and null termination, someone could call the ioctl and pass
> a non-null terminated patch, leading to buffer overrun problems in the
> kernel.
> 
> So just set the last byte of the path to a null character, similar to what
> we do in other ioctls (add/remove/resize device, snapshot creation, etc).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Good catch, thanks

Reviewed-by: David Sterba <dsterba@suse.com>
