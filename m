Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500C1C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2B6206B6
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE2B6206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbeK2D1Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:27:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:51834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728854AbeK2D1Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:27:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6265FACEF;
        Wed, 28 Nov 2018 16:25:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2520DAC7F; Wed, 28 Nov 2018 17:24:55 +0100 (CET)
Date:   Wed, 28 Nov 2018 17:24:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: cleanup the useless DEFINE_WAIT in
 cleanup_transaction
Message-ID: <20181128162455.GU2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
 <20181128032254.11625-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128032254.11625-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 11:22:54AM +0800, Lu Fengqi wrote:
> When it is introduced at commit f094ac32aba3 ("Btrfs: fix NULL pointer
> after aborting a transaction"), it's useless.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Added to misc-next, thanks.
