Return-Path: <SRS0=42cL=CM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5566CC433E9
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 11:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2238D206A5
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 11:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgICLem (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 07:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:40652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgICLdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Sep 2020 07:33:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A36A9ABAD;
        Thu,  3 Sep 2020 11:18:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F3357DA6E0; Thu,  3 Sep 2020 13:17:43 +0200 (CEST)
Date:   Thu, 3 Sep 2020 13:17:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/4] btrfs: fix lockdep splat in add_missing_dev
Message-ID: <20200903111743.GQ28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1598996236.git.josef@toxicpanda.com>
 <8cad21a9f0bcc2bd29a2b0e89e475687c44b3a59.1598996236.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cad21a9f0bcc2bd29a2b0e89e475687c44b3a59.1598996236.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:40:35PM -0400, Josef Bacik wrote:
> 
> References: https://github.com/btrfs/fstests/issues/6
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
