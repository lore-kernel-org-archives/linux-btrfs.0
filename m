Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34054C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 09:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3A520659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 09:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfANJfe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:35:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:58006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfANJfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 04:35:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D56E9ABD4;
        Mon, 14 Jan 2019 09:35:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 72CF5DA80F; Mon, 14 Jan 2019 10:35:04 +0100 (CET)
Date:   Mon, 14 Jan 2019 10:35:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
Message-ID: <20190114093504.GA2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 01:39:46PM +0800, Qu Wenruo wrote:
> Hi,
> 
> When rebasing my qgroup + balance optimization patches, I found one very
> obvious performance regression for balance.
> 
> For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
> only takes 3s to relocate a metadata block group, while for v5.0-rc1, I
> don't really know how it will take as it hasn't finished yet.

This looks like a lockup, unbounded waiting or missed wakeup.

> And the most important part is, this happens when quota is *DISABLED*!!!
> 
> I'm bisecting for this regression, but if there are some users trying
> latest rc kernel, please be aware of this regression.

The rc1 can go pretty wild and issues could be caused by other
subsystems, so I'd try to test the merged (32ee34eddad13cd4) and
non-merged (52042d8e82ff50d) branches, this should tell you if it's a
genuine btrfs bug or not.
