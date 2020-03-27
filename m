Return-Path: <SRS0=8QuJ=5M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC5BC43331
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2745B20748
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgC0P5T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:57:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:44474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgC0P5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Mar 2020 11:57:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12B49ACE3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2020 15:57:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4E381DA72D; Fri, 27 Mar 2020 16:56:46 +0100 (CET)
Date:   Fri, 27 Mar 2020 16:56:46 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9 v7] btrfs direct-io using iomap
Message-ID: <20200327155646.GP5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <20200326210254.17647-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326210254.17647-1-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 26, 2020 at 04:02:45PM -0500, Goldwyn Rodrigues wrote:
> Changes since v6
> - Fixed hangs due to underlying device failures
> - Removed the patch to wait while releasing pages

There were no hangs and all tests finished, but there were some failures
that seem to be caused by the patchset. I'll send you the logs.
