Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48F6C432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 11:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8774D20748
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 11:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRLLo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 06:11:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:34842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfKRLLo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 06:11:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 388F9B2DF;
        Mon, 18 Nov 2019 11:11:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1412DA823; Mon, 18 Nov 2019 12:11:43 +0100 (CET)
Date:   Mon, 18 Nov 2019 12:11:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liu Bo <bo.liu@linux.alibaba.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 028/237] Btrfs: fix alignment in declaration
 and prototype of btrfs_get_extent
Message-ID: <20191118111143.GE3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liu Bo <bo.liu@linux.alibaba.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116154113.7417-28-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Nov 16, 2019 at 10:37:43AM -0500, Sasha Levin wrote:
> From: Liu Bo <bo.liu@linux.alibaba.com>
> 
> [ Upstream commit de2c6615dcddf2af868c5cbd1db2e9e73b4beb58 ]
> 
> This fixes btrfs_get_extent to be consistent with our existing
> declaration style.

The patch is pure white space fix with no effects. I don't see that it
would be needed for a followup patch. What was the reason to add it to
autosel/stable ?
