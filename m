Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0E2C433B4
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D5E61185
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhDIO5J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:57:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:53922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhDIO5J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Apr 2021 10:57:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 471B8B1AD;
        Fri,  9 Apr 2021 14:56:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 09281DA732; Fri,  9 Apr 2021 16:54:41 +0200 (CEST)
Date:   Fri, 9 Apr 2021 16:54:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 00/39] Cleanup error handling in relocation
Message-ID: <20210409145441.GS7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1615580595.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1615580595.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 12, 2021 at 03:24:55PM -0500, Josef Bacik wrote:
> v7->v8:
> - Reordered some of the patches, so that the callers of functions that added new
>   error cases were fixed first, and then added the new error handler.
> - Moved a few of the ASSERT(0) to where they made sense.  Left the others that
>   are in functions that can have multiple cases of the same error that indicates
>   a logic error.

With some updates in changelogs and comments moved from topic branch to
misc-next. I'm still not happy about the ASSERT(0), it should be a real
error or a real assert. We can't observe the same behaviour with asserts
enabled and disabled.
