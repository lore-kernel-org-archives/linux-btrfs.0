Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7375C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0AC20656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfAORiU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:38:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:55564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729052AbfAORiU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:38:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B06E2ADC2;
        Tue, 15 Jan 2019 17:38:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D90BDA83D; Tue, 15 Jan 2019 18:37:49 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:37:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: image: Only enlarge result image if it's
 regular file
Message-ID: <20190115173749.GK2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181218075740.23723-1-wqu@suse.com>
 <5e9bf391-8b4e-8d0f-c8f9-83cfc9904093@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9bf391-8b4e-8d0f-c8f9-83cfc9904093@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:58:41PM +0800, Qu Wenruo wrote:
> This patch can also be folded into the original commit a7a44164c84e
> ("btrfs-progs: image: Use correct device size when restoring") in devel
> branch.

I've applied this patch right after that one, as it's fixing a bit
different problem. The temporary test failure is not a big deal, given
that it was failing anyway. Thanks.
