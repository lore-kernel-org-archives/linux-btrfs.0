Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CF9C433DB
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 12:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46552311D
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 12:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbhAFMTH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 07:19:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:60868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbhAFMTG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jan 2021 07:19:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6BE0FAA35;
        Wed,  6 Jan 2021 12:18:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15B6EDA6E9; Wed,  6 Jan 2021 13:16:36 +0100 (CET)
Date:   Wed, 6 Jan 2021 13:16:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     shngmao@gmail.com
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: align btrfs receive buffer to enable fast
 CRC
Message-ID: <20210106121635.GR6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, shngmao@gmail.com,
        linux-btrfs@vger.kernel.org
References: <20201226214606.49241-1-shngmao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201226214606.49241-1-shngmao@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Dec 26, 2020 at 02:46:06PM -0700, shngmao@gmail.com wrote:
> From: Sheng Mao <shngmao@gmail.com>
> 
> To use optimized CRC implemention, the input buffer must be
> unsigned long aligned. btrfs receive calculates checksum based on
> read_buf, including btrfs_cmd_header (with zero-ed CRC field)
> and command content. GCC attribute is added to both struct
> btrfs_send_stream and read_buf to make sure read_buf is allocated
> with proper alignment.
> 
> Issue: #324

The issue has a lot of interesting debugging and performance information
so I'd put something to the changelog as well.

The alignment fixup sounds correct, though I'd push it a bit further and
move read_buf to the beginning of the structure and align the whole
structure to 64 bytes, as this is the common cache line size. This could
potentially help too with memcpy.
