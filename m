Return-Path: <SRS0=EXPL=BC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FD0C433F8
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Jul 2020 17:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBA72071A
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Jul 2020 17:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgGWRTQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 13:19:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:50074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbgGWRTQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Jul 2020 13:19:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 509C7AC50;
        Thu, 23 Jul 2020 17:19:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CB48DDA794; Thu, 23 Jul 2020 19:18:48 +0200 (CEST)
Date:   Thu, 23 Jul 2020 19:18:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: do not set the full sync flag on the inode
 during page release
Message-ID: <20200723171848.GE3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200722112901.15626-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722112901.15626-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 22, 2020 at 12:29:01PM +0100, fdmanana@kernel.org wrote:
> Before patchset:
> 
> WRITE: bw=98.8MiB/s (104MB/s), 98.8MiB/s-98.8MiB/s (104MB/s-104MB/s), io=64.0GiB (68.7GB), run=663126-663126msec
> 
> After patchset:
> 
> WRITE: bw=294MiB/s (308MB/s), 294MiB/s-294MiB/s (308MB/s-308MB/s), io=64.0GiB (68.7GB), run=222940-222940msec
> (+197.6% throughput, -66.4% run time)

That's really great, thank you very much!
