Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F23C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3702070B
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfBVPzq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:55:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:58036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfBVPzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 10:55:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C21E2AE5C;
        Fri, 22 Feb 2019 15:55:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8C1B3DAA56; Fri, 22 Feb 2019 16:57:03 +0100 (CET)
Date:   Fri, 22 Feb 2019 16:57:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Robertson <dan@dlrobertson.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs: init csum_list before possible free
Message-ID: <20190222155701.GI9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Robertson <dan@dlrobertson.com>,
        linux-btrfs@vger.kernel.org
References: <20190219025643.20382-1-dan@dlrobertson.com>
 <20190219163144.GR9874@twin.jikos.cz>
 <20190221145723.GA25507@nessie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221145723.GA25507@nessie>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 21, 2019 at 02:57:27PM +0000, Dan Robertson wrote:
> > Thanks, it's been there since the first merge of scrub, but hard to hit.
> 
> Yeah, very hard to hit. Debated submitting a patch, but the fix seemed
> simple enough, so figured I'd send one in.
> 
> Side note: I noticed most of the time ENOMEM is hit in fs/btrfs BUG or BUG_ON is
> called. Would it be better (more in line with the fs/btrfs style) to call BUG or
> BUG_ON e.g. BUG_ON(!sbio) instead of goto nomem at fs/btrfs/scrub.c:592?

No, we want to get rid of the BUG_ONs as a poor substitute for error
handling. The ENOMEM case is usually a hard one to fix so you still can
see a lot of them, but there are places where it's simple enough to
rollback and return ENOMEM up to the original caller. Scrub in this case
is restartable and if scrub_setup_ctx fails, it's at the time of start
and the user is properly notified.
