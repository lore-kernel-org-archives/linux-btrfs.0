Return-Path: <SRS0=ZmOe=WQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5499C3A589
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EDDF20673
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfHTOZ7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:25:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729137AbfHTOZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Aug 2019 10:25:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C8BFAAB0;
        Tue, 20 Aug 2019 14:25:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6D66CDA7DA; Tue, 20 Aug 2019 16:26:24 +0200 (CEST)
Date:   Tue, 20 Aug 2019 16:26:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Vladimir Panteleev <git@panteleev.md>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: fix cli-tests/003-fi-resize-args
Message-ID: <20190820142624.GR24086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Vladimir Panteleev <git@panteleev.md>,
        linux-btrfs@vger.kernel.org
References: <20190817231849.18675-1-git@vladimir.panteleev.md>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817231849.18675-1-git@vladimir.panteleev.md>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 17, 2019 at 11:18:49PM +0000, Vladimir Panteleev wrote:
> grep's exit code was never checked (and -o errexit is not in effect),
> thus the test was ineffectual and regressed.
> 
> Add the missing exit code check, and update the error messages to
> make the test pass again.
> 
> Signed-off-by: Vladimir Panteleev <git@vladimir.panteleev.md>

Applied, thanks.
