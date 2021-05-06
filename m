Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F01EC433ED
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 May 2021 14:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F242D610FC
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 May 2021 14:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhEFOYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 May 2021 10:24:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234485AbhEFOYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 May 2021 10:24:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35FACAC38;
        Thu,  6 May 2021 14:23:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 41297DA81B; Thu,  6 May 2021 16:21:21 +0200 (CEST)
Date:   Thu, 6 May 2021 16:21:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     20210419124541.148269-1-l@damenly.su
Cc:     linux-btrfs@vger.kernel.org, l@damenly.su, boris@bur.io,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH v3] btrfs-progs: fi resize: fix false 0.00B sized output
Message-ID: <20210506142121.GS7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, 20210419124541.148269-1-l@damenly.su,
        linux-btrfs@vger.kernel.org, l@damenly.su, boris@bur.io,
        Chris Murphy <lists@colorremedies.com>
References: <20210420045827.150881-1-l@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420045827.150881-1-l@damenly.su>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 20, 2021 at 12:58:27PM +0800, Su Yue wrote:
> Resize to nums without sign prefix makes false output:
>  btrfs fi resize 1:150g /srv/extra
> Resize device id 1 (/dev/sdb1) from 298.09GiB to 0.00B
> 
> The resize operation would take effect though.
> 
> check_resize_args() does not handle the mod 0 case and new_size is 0.
> Simply assigning @diff to @new_size to fix this.
> 
> Issue: #307
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Su Yue <l@damenly.su>
> ---
> Changelog:
> v3:
>   Just assign @diff to @new_size. (Boris Burkov)

Patch replaced in devel, thanks.
