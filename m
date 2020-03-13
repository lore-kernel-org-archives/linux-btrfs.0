Return-Path: <SRS0=6pDE=46=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B50AC2BB1D
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D873D206E9
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCMOgP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:36:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:45532 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgCMOgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Mar 2020 10:36:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C074BAC86;
        Fri, 13 Mar 2020 14:36:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B6D16DA7A7; Fri, 13 Mar 2020 15:35:47 +0100 (CET)
Date:   Fri, 13 Mar 2020 15:35:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/8][v2] relocation error handling fixes
Message-ID: <20200313143547.GM12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200304161830.2360-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304161830.2360-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 04, 2020 at 11:18:22AM -0500, Josef Bacik wrote:
> v1->v2:
> - Incorporated the various feedback, tweaked some things, adjusted commit
>   messages, added some more comments.  Hopefully I got everything.
> - Added "btrfs: do not init a reloc root if we aren't relocating", this is to
>   oddress the weird handling of DEAD_ROOT and the use-after-free that Qu had
>   originally attempted to fix.
> - Reworked "btrfs: splice rc->reloc_roots onto reloc roots in recover" to simply
>   handle cleaning up any remaining bigs on the reloc_control, since errors can
>   mean we'll have some things left pending on the reloc_control.

I've merged the reviewed patches to misc-next, but there are still
comments to 4 and 6, while 7, 8 could be fine as-is, at least 7 depends
on 6 so it might need changes too.

This the last batch of fixes I want to get in before merging the root
refs part 2. Both are in for-next so we have some testing coverage, but
the changelog for patch 6 is really insufficient.
