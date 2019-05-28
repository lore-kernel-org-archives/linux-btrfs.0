Return-Path: <SRS0=Wt7H=T4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0249EC04E84
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 12:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D2420883
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 12:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfE1Mnc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 May 2019 08:43:32 -0400
Received: from voltaic.bi-co.net ([134.119.3.22]:59951 "EHLO voltaic.bi-co.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfE1Mnc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 May 2019 08:43:32 -0400
Received: from mila.uni-paderborn.de (mila.uni-paderborn.de [131.234.92.203])
        by voltaic.bi-co.net (Postfix) with ESMTPSA id 0719F20839;
        Tue, 28 May 2019 14:43:30 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Massive filesystem corruption after balance + fstrim on Linux
 5.1.2
From:   =?utf-8?Q?Michael_La=C3=9F?= <bevan@bi-co.net>
In-Reply-To: <6e9c176d0b9389b2ff04cf38556471360725146e.camel@scientia.net>
Date:   Tue, 28 May 2019 14:43:30 +0200
Cc:     linux-btrfs@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6B22E3F5-9095-4533-92F2-0A6D9041D493@bi-co.net>
References: <297da4cbe20235080205719805b08810@bi-co.net>
 <6e9c176d0b9389b2ff04cf38556471360725146e.camel@scientia.net>
To:     Christoph Anton Mitterer <calestyo@scientia.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> Am 28.05.2019 um 14:36 schrieb Christoph Anton Mitterer <calestyo@scientia.net>:
> 
> Hey.
> 
> Just to be on the safe side...
> 
> AFAIU this issue only occured in 5.1.2 and later, right?

No. The issue was already introduced in v5.1-rc1 (commit 61697a6abd24).

> Starting with which 5.1.x and 5.2.x versions has the fix been merged?

It's fixed in v5.2-rc2 (commit 51b86f9a8d1c) and v5.1.5 (commit 871e122d55e8).

Cheers,
Michael
