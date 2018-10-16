Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E174DC04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 09:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E8820869
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 09:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4E8820869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbeJPRWh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 13:22:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:47286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbeJPRWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 13:22:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B97BAE74;
        Tue, 16 Oct 2018 09:33:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D789BDAD56; Tue, 16 Oct 2018 11:32:58 +0200 (CEST)
Date:   Tue, 16 Oct 2018 11:32:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix null pointer dereference on compressed
 write path error
Message-ID: <20181016093258.GZ29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181012204544.27137-1-fdmanana@kernel.org>
 <20181012233725.27290-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012233725.27290-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 13, 2018 at 12:37:25AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At inode.c:compress_file_range(), under the "free_pages_out" label, we can
> end up dereferencing the "pages" pointer when it has a NULL value. This
> case happens when "start" has a value of 0 and we fail to allocate memory
> for the "pages" pointer. When that happens we jump to the "cont" label and
> then enter the "if (start == 0)" branch where we immediately call the
> cow_file_range_inline() function. If that function returns 0 (success
> creating an inline extent) or an error (like -ENOMEM for example) we jump
> to the "free_pages_out" label and then access "pages[i]" leading to a NULL
> pointer dereference, since "nr_pages" has a value greater than zero at
> that point.
> 
> Fix this by setting "nr_pages" to 0 when we fail to allocate memory for
> the "pages" pointer.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201119
> Fixes: 771ed689d2cd ("Btrfs: Optimize compressed writeback and reads")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
