Return-Path: <SRS0=27je=WP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9B9C3A5A0
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Aug 2019 17:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE6E22CEA
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Aug 2019 17:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfHSR2A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 13:28:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:39414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbfHSR2A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Aug 2019 13:28:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4712BABAE;
        Mon, 19 Aug 2019 17:27:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F333FDA7DA; Mon, 19 Aug 2019 19:28:25 +0200 (CEST)
Date:   Mon, 19 Aug 2019 19:28:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/2] Btrfs: workqueue cleanups
Message-ID: <20190819172825.GM24086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1565717247.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1565717247.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 13, 2019 at 10:33:42AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This does some cleanups to the Btrfs workqueue code following my
> previous fix [1]. Changed since v1 [2]:
> 
> - Removed errant Fixes: tag in patch 1
> - Fixed a comment typo in patch 2
> - Added NB: to comments in patch 2
> - Added Nikolay and Filipe's reviewed-by tags

Added to misc-next, thanks.
