Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90DDC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 14:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9048B217D6
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 14:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfBEO6d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:58:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:55106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbfBEO6d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 09:58:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16948B65C;
        Tue,  5 Feb 2019 14:58:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CC74FDA7E3; Tue,  5 Feb 2019 15:57:54 +0100 (CET)
Date:   Tue, 5 Feb 2019 15:57:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190205145753.GR2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190204202008.51652-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> Hi everyone,
> 
> V2 had only a handful of changes outside of minor feedback.
> 0001:
> - use functions over macros
> 0003:
> - BTRFS_NR_WORKSPACE_MANAGERS is added instead of overriding
>   BTRFS_COMPRESS_TYPES
> 0011 (new):
> - address monotonic memory requirement for zstd workspaces
> 0012:
> - increase reclaim timer to 307s from 67s
> - move from keeping track of time in ns to jiffies
> - remove timer in cleanup code
> - use min_t() instead of if statements in .set_level()
> - add header text to describe how workspaces are managed
> - nofs_flag type -> unsigned long to unsigned int

Something is wrong, the patchset on top of 5.0-rc5 hangs in test
btrfs/007, without a stacktrace. V1 was fine and I double checked that
rc5 itself is fine.
