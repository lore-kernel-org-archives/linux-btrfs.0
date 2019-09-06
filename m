Return-Path: <SRS0=G5oB=XB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928B5C43331
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Sep 2019 15:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76496207FC
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Sep 2019 15:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfIFPuy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:50:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:60642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726654AbfIFPuy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Sep 2019 11:50:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 432B5B0E2;
        Fri,  6 Sep 2019 15:50:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D58D2DA8F3; Fri,  6 Sep 2019 17:51:15 +0200 (CEST)
Date:   Fri, 6 Sep 2019 17:51:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nborisov@suse.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        chandan <chandan@linux.vnet.ibm.com>, josef@toxicpanda.com,
        mpe <mpe@ellerman.id.au>, sachinp <sachinp@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [mainline][BUG][PPC][btrfs][bisected 00801a] kernel BUG at
 fs/btrfs/locking.c:71!
Message-ID: <20190906155115.GD2850@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nborisov@suse.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        chandan <chandan@linux.vnet.ibm.com>, josef@toxicpanda.com,
        mpe <mpe@ellerman.id.au>, sachinp <sachinp@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
References: <1567500907.5082.12.camel@abdul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567500907.5082.12.camel@abdul>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 03, 2019 at 02:25:07PM +0530, Abdul Haleem wrote:
> Greeting's
> 
> Mainline kernel panics with LTP/fs_fill-dir tests for btrfs file
> system on my P9 box running mainline kernel 5.3.0-rc5

Is the issue reproducible? And if yes, how reliably? Thanks.
