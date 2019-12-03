Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BTC_ID,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C194C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15E1020640
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfLCT0B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:26:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:36774 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726932AbfLCT0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 14:26:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0ECDCB2BAC;
        Tue,  3 Dec 2019 19:26:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CEE8DDA7D9; Tue,  3 Dec 2019 20:25:54 +0100 (CET)
Date:   Tue, 3 Dec 2019 20:25:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Opencode ordered_data_tree_panic
Message-ID: <20191203192553.GZ2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191129093813.574-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129093813.574-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 29, 2019 at 11:38:13AM +0200, Nikolay Borisov wrote:
> It's a simple wrapper over btrfs_panic and is called only once. Just
> open code it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next with 1st hunk dropped and fixed coding style, thanks.
