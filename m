Return-Path: <SRS0=sbT/=2Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470FBC2D0C2
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 14:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2417121835
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 14:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgACOkc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 09:40:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:34620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbgACOkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Jan 2020 09:40:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A34FEACB1;
        Fri,  3 Jan 2020 14:40:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5E507DA795; Fri,  3 Jan 2020 15:40:22 +0100 (CET)
Date:   Fri, 3 Jan 2020 15:40:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/12] btrfs: add bps discard rate limit for async discard
Message-ID: <20200103144022.GT3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <cover.1577999991.git.dennis@kernel.org>
 <8929cde12ad0237ab8a4e2bbdff7b713886eff56.1577999991.git.dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8929cde12ad0237ab8a4e2bbdff7b713886eff56.1577999991.git.dennis@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 02, 2020 at 04:26:36PM -0500, Dennis Zhou wrote:
> +		 */
> +		if (kbps_limit && discard_ctl->prev_discard) {
> +			u64 bps_limit = ((u64)kbps_limit) * SZ_1K;
> +			u64 bps_delay = div64_u64(discard_ctl->prev_discard *
> +						  MSEC_PER_SEC, bps_limit);

I hoped we can get rid of the 64bit division when the kbps is u32 but I
don't think it's necessary, bytes as units of the calculation are fine.

> +
> +			delay = max(delay, msecs_to_jiffies(bps_delay));
> +		}
