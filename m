Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93789C43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 10:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1B32464D
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 10:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLEKnN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:43:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:41290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729018AbfLEKnN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 05:43:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BAB5ADAA;
        Thu,  5 Dec 2019 10:43:12 +0000 (UTC)
Date:   Thu, 5 Dec 2019 11:43:10 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     pk <pkoroau@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: ping for null pointer dereference (cppcheck)
Message-ID: <20191205104310.GB11438@Johanness-MacBook-Pro.local>
References: <CAMNwjE+xs55e6qQLuG-YiwHb3dyq915hRqsnm_c5j9fcvwT5uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMNwjE+xs55e6qQLuG-YiwHb3dyq915hRqsnm_c5j9fcvwT5uA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2019 at 06:42:50PM +0100, pk wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=205003

I'll have a look.

Thanks,
	Johannes
