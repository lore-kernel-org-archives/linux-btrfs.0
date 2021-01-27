Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B334C433DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 15:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D2B207B0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 15:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343687AbhA0PNK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:13:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:49308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235250AbhA0PGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jan 2021 10:06:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 568E3ABDA;
        Wed, 27 Jan 2021 15:05:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EBB20DA84C; Wed, 27 Jan 2021 16:03:49 +0100 (CET)
Date:   Wed, 27 Jan 2021 16:03:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 00/12] Improve preemptive ENOSPC flushing
Message-ID: <20210127150349.GB1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1611695838.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1611695838.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 26, 2021 at 04:24:24PM -0500, Josef Bacik wrote:
> v3->v4:
> - Added some comments.
> - Updated the tracepoint for the preemptive flushing to take a bool instead of
>   an int.
> - Removed 'inline' from need_preemptive_flushing.

Thanks, I'll add it to misc-next.
