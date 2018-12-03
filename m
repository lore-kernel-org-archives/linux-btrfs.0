Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9407AC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 22:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4197120851
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 22:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4197120851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbeLCWKI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 17:10:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:45272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbeLCWKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 17:10:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B2C7AE88;
        Mon,  3 Dec 2018 22:10:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9F5D2DAF63; Mon,  3 Dec 2018 23:09:48 +0100 (CET)
Date:   Mon, 3 Dec 2018 23:09:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     damenly.su@gmail.com
Cc:     linux-btrfs@vger.kernel.org, suy.fnst@cn.fujitsu.com
Subject: Re: [PATCH] btrfs-progs: trivial fix about line breaker in
 repair_inode_nbytes_lowmem()
Message-ID: <20181203220948.GD17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, damenly.su@gmail.com,
        linux-btrfs@vger.kernel.org, suy.fnst@cn.fujitsu.com
References: <20181202150836.16625-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202150836.16625-1-suy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Dec 02, 2018 at 03:08:36PM +0000, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Move "\n" at end of the sentence to print.
> 
> Fixes: 281eec7a9ddf ("btrfs-progs: check: repair inode nbytes in lowmem mode")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
