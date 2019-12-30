Return-Path: <SRS0=x8Sa=2U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3EEC2D0C2
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Dec 2019 15:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D683A206DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Dec 2019 15:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfL3PNN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 30 Dec 2019 10:13:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:38012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbfL3PNM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Dec 2019 10:13:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7366ADF0;
        Mon, 30 Dec 2019 15:13:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3B18ADA790; Mon, 30 Dec 2019 16:13:05 +0100 (CET)
Date:   Mon, 30 Dec 2019 16:13:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix infinite loop during nocow writeback due to
 race
Message-ID: <20191230151305.GU3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20191211090140.27607-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211090140.27607-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:01:40AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>

> Fixes: 80ff385665b7fc ("Btrfs: update nodatacow code v2")
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks, added to 5.5-rc queue.
