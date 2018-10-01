Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF46C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 17:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75653206B2
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 17:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75653206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbeJAXq6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:46:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:35488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbeJAXq6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 19:46:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4A4D9ACE7;
        Mon,  1 Oct 2018 17:08:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AB4DEDAD55; Mon,  1 Oct 2018 19:08:11 +0200 (CEST)
Date:   Mon, 1 Oct 2018 19:08:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/42] btrfs: dump block_rsv whe dumping space info
Message-ID: <20181001170811.GT3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-9-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-9-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:17:47AM -0400, Josef Bacik wrote:
> For enospc_debug having the block rsvs is super helpful to see if we've
> done something wrong.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
