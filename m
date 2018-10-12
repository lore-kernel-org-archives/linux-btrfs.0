Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7545C67877
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 18:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895352087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 18:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 895352087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbeJMBf4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 21:35:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbeJMBf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 21:35:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69F03AE41;
        Fri, 12 Oct 2018 18:02:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EA098DA862; Fri, 12 Oct 2018 20:02:10 +0200 (CEST)
Date:   Fri, 12 Oct 2018 20:02:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 33/42] btrfs: fix insert_reserved error handling
Message-ID: <20181012180210.GX29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20181011195431.3441-1-josef@toxicpanda.com>
 <20181011195431.3441-34-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011195431.3441-34-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 03:54:22PM -0400, Josef Bacik wrote:
> We were not handling the reserved byte accounting properly for data
> references.  Metadata was fine, if it errored out the error paths would
> free the bytes_reserved count and pin the extent, but it even missed one
> of the error cases.  So instead move this handling up into
> run_one_delayed_ref so we are sure that both cases are properly cleaned
> up in case of a transaction abort.
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: David Sterba <dsterba@suse.com>
