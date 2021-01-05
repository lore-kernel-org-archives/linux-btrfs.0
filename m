Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2085CC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Jan 2021 15:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E46F32229C
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Jan 2021 15:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbhAEPt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:49:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:47458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbhAEPt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jan 2021 10:49:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2BDC8ACAF;
        Tue,  5 Jan 2021 15:48:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 46511DA7C6; Tue,  5 Jan 2021 16:46:56 +0100 (CET)
Date:   Tue, 5 Jan 2021 16:46:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix unterminated long opts for send
Message-ID: <20210105154656.GO6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20201225191530.25000-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225191530.25000-1-kilobyte@angband.pl>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 25, 2020 at 08:15:30PM +0100, Adam Borowski wrote:
> Any use of a long option would crash.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Omar sent this fix within another series, I've added it to devel some
time ago.

https://lore.kernel.org/linux-btrfs/e0aff7fddf35f0f18ff21d1e2e50a5d127254392.1605723745.git.osandov@osandov.com/
