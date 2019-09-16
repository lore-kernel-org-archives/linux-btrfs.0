Return-Path: <SRS0=zKcM=XL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96C1C4CECD
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9453214D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbfIPMsk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:48:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:54346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732793AbfIPMsk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:48:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D04BAD12;
        Mon, 16 Sep 2019 12:48:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F35E5DA984; Mon, 16 Sep 2019 14:48:58 +0200 (CEST)
Date:   Mon, 16 Sep 2019 14:48:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 5.4
Message-ID: <20190916124858.GO2850@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1568631647.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1568631647.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 16, 2019 at 01:55:05PM +0200, David Sterba wrote:
> ----------------------------------------------------------------
> The following changes since commit f74c2bb98776e2de508f4d607cd519873065118e:
> 
>   Linux 5.3-rc8 (2019-09-08 13:33:15 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.4

Correction:

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.4-tag
