Return-Path: <SRS0=/JOF=4C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC73C2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 17:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF86320637
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 17:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392200AbgBNRMi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:12:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:40574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392098AbgBNRMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Feb 2020 12:12:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0BE81B1AE;
        Fri, 14 Feb 2020 17:12:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6A473DA703; Fri, 14 Feb 2020 18:12:21 +0100 (CET)
Date:   Fri, 14 Feb 2020 18:12:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] btrfs: Make balance cancelling response faster
Message-ID: <20200214171221.GF2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200211053729.20807-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211053729.20807-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 11, 2020 at 01:37:25PM +0800, Qu Wenruo wrote:
> For the canceled balance during relocate_block_group(), we are re-using
> the existing error handling path.
> It will mark all existing reloc_roots as orphan in prepare_to_merge(),
> then queue all of them for cleanup in merge_reloc_roots().
> Thus it shouldn't cause any problem.
> 
> Changelog:
> v2:
> - Rebased to v5.6-rc1
>   There is a small conflicts caused by extra finished stage output.
>   Other than that, everything is pretty straightforward
> 
> - Add explanation for the error handling path in cover letter.

Ah so the text is here, but we want it in the changelog and perhaps in
the code too as it's breaking out of a loop that does a lot of things.

As further changes are not in code I'll add the patches (without 4th) to
for-next for more testing. Thanks.
