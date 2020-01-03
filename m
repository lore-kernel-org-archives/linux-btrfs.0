Return-Path: <SRS0=sbT/=2Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED175C2D0C2
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 14:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88E5222C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 14:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgACOm6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 09:42:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:35442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbgACOm6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Jan 2020 09:42:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0BAB6AD79;
        Fri,  3 Jan 2020 14:42:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8C92DA795; Fri,  3 Jan 2020 15:42:48 +0100 (CET)
Date:   Fri, 3 Jan 2020 15:42:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/12] btrfs: add correction to handle -1 edge case in
 async discard
Message-ID: <20200103144248.GV3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <cover.1577999991.git.dennis@kernel.org>
 <f00ffdb40462c1dd9b611ee06cf19b2d495e398b.1577999991.git.dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f00ffdb40462c1dd9b611ee06cf19b2d495e398b.1577999991.git.dennis@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 02, 2020 at 04:26:46PM -0500, Dennis Zhou wrote:
> >From Dave's testing, it's possible to drive a file system to have -1
> discardable_extents and a corresponding negative discardable_bytes. As
> btrfs_discard_calc_delay() is the only user of discardable_extents, we
> can correct here for any negative discardable_extents/discardable_bytes.

Changelog updated with the rough description of the workload.
