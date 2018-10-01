Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0B3C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 17:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3DA2089A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 17:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB3DA2089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJAX4n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:56:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:36420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbeJAX4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 19:56:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6B98AF10;
        Mon,  1 Oct 2018 17:17:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82DCADAD55; Mon,  1 Oct 2018 19:17:54 +0200 (CEST)
Date:   Mon, 1 Oct 2018 19:17:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 36/42] btrfs: wait on caching when putting the bg cache
Message-ID: <20181001171754.GV3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-37-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-37-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:18:15AM -0400, Josef Bacik wrote:
> While testing my backport I noticed there was a panic if I ran
> generic/416 generic/417 generic/418 all in a row.  This just happened to
> uncover a race where we had outstanding IO after we destroy all of our
> workqueues, and then we'd go to queue the endio work on those free'd
> workqueues.  This is because we aren't waiting for the caching threads
> to be done before freeing everything up, so to fix this make sure we
> wait on any outstanding caching that's being done before we free up the
> block group, so we're sure to be done with all IO by the time we get to
> btrfs_stop_all_workers().  This fixes the panic I was seeing
> consistently in testing.

Can you please attach the stacktrace?

I was running the tests 416/417/418 in a loop for a few days and did not
reproduce the crash (in a VM) so this depends on the setup.
