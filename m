Return-Path: <SRS0=mf0I=A7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619ADC433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jul 2020 14:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4652F20B1F
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jul 2020 14:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgGTOQP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 10:16:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:38402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgGTOQP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Jul 2020 10:16:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3C9F9B6D1;
        Mon, 20 Jul 2020 14:16:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1BFA0DA7CF; Mon, 20 Jul 2020 16:15:49 +0200 (CEST)
Date:   Mon, 20 Jul 2020 16:15:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: reduce contention on log trees when logging
 checksums
Message-ID: <20200720141548.GE3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200715113043.3192206-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715113043.3192206-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 15, 2020 at 12:30:43PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>     **** 16 jobs, file size 1G, fsync frequency 1 ****
> (+40.1% throughput, -28.5% runtime)

>     **** 32 jobs, file size 1G, fsync frequency 1 ****
> (+29.4% throughput, -22.7% runtime)

>     **** 64 jobs, file size 512M, fsync frequency 1 ****
> (+29.3% throughput, -22.7% runtime)

>     **** 128 jobs, file size 256M, fsync frequency 1 ****
> (+121.2% throughput, -54.6% runtime)

>     **** 256 jobs, file size 256M, fsync frequency 1 ****
> (+74.9% throughput, -42.8% runtime)

>     **** 512 jobs, file size 128M, fsync frequency 1 ****
> (+65.1% throughput, -39.3% runtime)

>     **** 1024 jobs, file size 128M, fsync frequency 1 ****
> (+48.7% throughput, -33.1% runtime)
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Some nice numbers to mention in the merge log, thanks.
