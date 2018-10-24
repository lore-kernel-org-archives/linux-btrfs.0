Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6630ECDE44
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 17:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 890862082E
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 17:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 890862082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbeJYCOU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 22:14:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:37808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727407AbeJYCOU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 22:14:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9F97B083
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 17:45:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3A8E9DABAA; Wed, 24 Oct 2018 19:45:13 +0200 (CEST)
Date:   Wed, 24 Oct 2018 19:45:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Misc refactoring of check_file_extent
Message-ID: <20181024174513.GZ16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180913120507.18197-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180913120507.18197-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 13, 2018 at 03:05:04PM +0300, Nikolay Borisov wrote:
> While looking at check_file_extent I thought that the code might be a bit 
> cleaner than it actually is and cleaner as well. The first patch factors out 
> the code dealing with inline extents into a separate function aptly named 
> check_file_extent_inline. This allows to remove some inline-specific variable 
> from check_file_extent. Patch 2 just moves the final check in the new function 
> into the already existing branch handling the !compressed case. Finally 
> the check which detects unknown extent types is moved first in check_file_extent, 
> followed by the code to handle inline extents and finally the existing code to 
> handle regular/prealloc extents is left intact. 
> 
> This patchset brings no functional changes. 
> 
> Nikolay Borisov (3):
>   btrfs-progs: check: lowmem: Factor out inline extent checking code in
>     its own function
>   btrfs-progs: check: lowmem: Refactor extent len test in
>     check_file_extent_inline
>   btrfs-progs: check: lowmem: Refactor extent type checks in
>     check_file_extent

Applied, thanks.
