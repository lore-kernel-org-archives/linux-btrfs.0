Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DF4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C2520656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbfAORkZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:40:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:55838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729035AbfAORkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:40:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B318AAD56
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:40:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 294AEDA83D; Tue, 15 Jan 2019 18:39:55 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:39:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     jeffm@suse.com
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix stray error message in check
Message-ID: <20190115173955.GL2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, jeffm@suse.com,
        linux-btrfs@vger.kernel.org
References: <20190111220749.30053-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111220749.30053-1-jeffm@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 11, 2019 at 05:07:49PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit e578b59bf61 (btrfs-progs: convert strerror to implicit %m) missed
> adding braces after a conditional so we will see the following message
> whenever a tree block needs repair, regardless of whether repair was
> successful: "Failed to repair btree: Success"
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Applied, thanks.
