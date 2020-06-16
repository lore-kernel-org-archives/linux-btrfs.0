Return-Path: <SRS0=vfU5=75=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF2FC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EE220B80
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFPNMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 09:12:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:50524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgFPNMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jun 2020 09:12:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E39A2AD26;
        Tue, 16 Jun 2020 13:12:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0F98DA7C3; Tue, 16 Jun 2020 15:12:25 +0200 (CEST)
Date:   Tue, 16 Jun 2020 15:12:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: check if a log root exists before locking the
 log_mutex on unlink
Message-ID: <20200616131225.GB27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200615093844.287269-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615093844.287269-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 15, 2020 at 10:38:44AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This brings back an optimization that commit e678934cbe5f02 ("btrfs:
> Remove unnecessary check from join_running_log_trans") removed, but in
> a different form. So it's almost equivalent to a revert.

I very much prefer the bit to be the synchronization mechanism, the
logic is easy to follow instead of the cryptic barrier.

The original patch came with numbers to support the 'not needed and no
perf impact
(https://lore.kernel.org/linux-btrfs/20190523115126.10532-1-nborisov@suse.com/)
but it probably wasn't triggering the right load.

[...]
> The test robots from intel reported a -30.7% performance regression for
> a REAIM test after commit e678934cbe5f02 ("btrfs: Remove unnecessary check
> from join_running_log_trans").

Thanks for fixing the perf regression and points for the test robot too.
