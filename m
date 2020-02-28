Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EEAC3F2D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51154246AE
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgB1NuJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:50:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:38254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgB1NuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 08:50:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E39F6B203;
        Fri, 28 Feb 2020 13:50:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9682DDA7FF; Fri, 28 Feb 2020 14:49:47 +0100 (CET)
Date:   Fri, 28 Feb 2020 14:49:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Add full support for cloning inline extents
Message-ID: <20200228134947.GJ2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200228130419.16719-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228130419.16719-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 28, 2020 at 01:04:16PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This patchset adds support for currently unsupported cases of reflink
> operations that cover a file range that has inline extents, more details
> on why/how in patch 3/3.
> 
> It also starts by moving all the reflink code out of ioctl.c into a new
> file named reflink.c (like xfs does) since this code is quite significant
> in size and has grown over the years.
> 
> V4: Updated patch 3 to fix a deadlock due to allocating space while holding
>     a transaction open. No changes to the first two patches.

V4 replaced in for-next, thanks.
