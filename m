Return-Path: <SRS0=Wt7H=T4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FF2C072B1
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 16:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD7021734
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 16:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfE1QJb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 May 2019 12:09:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:56756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbfE1QJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 May 2019 12:09:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F7E5AF7C;
        Tue, 28 May 2019 16:09:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00278DA85E; Tue, 28 May 2019 18:10:23 +0200 (CEST)
Date:   Tue, 28 May 2019 18:10:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190528161023.GR15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
References: <20190528101552.14798-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528101552.14798-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 28, 2019 at 06:15:52PM +0800, Qu Wenruo wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> CC: stable@vger.kernel.org # 4.14

This applies to 4.14 stable tree.
