Return-Path: <SRS0=ogea=DG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C28C4346E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Sep 2020 10:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB351208FE
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Sep 2020 10:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgI2Kjk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI2Kjj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Sep 2020 06:39:39 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B908C061755
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2020 03:39:39 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4C0wqq29ltzQlFr
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2020 12:39:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 7yFbDIBTdDwv for <linux-btrfs@vger.kernel.org>;
        Tue, 29 Sep 2020 12:39:32 +0200 (CEST)
Message-ID: <937038014748c11e7c951cef28e2f697570fbf22.camel@wittke-web.de>
Subject: Re: Recover from Extent Tree Corruption (maybe due to hardware
 failure)
From:   Marc Wittke <marc@wittke-web.de>
To:     linux-btrfs@vger.kernel.org
Date:   Tue, 29 Sep 2020 07:39:27 -0300
In-Reply-To: <5df695c82cd7f44da5e57d3a8c8549a01130d759.camel@wittke-web.de>
References: <5df695c82cd7f44da5e57d3a8c8549a01130d759.camel@wittke-web.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.46 / 15.00 / 15.00
X-Rspamd-Queue-Id: 51FFD170E
X-Rspamd-UID: 7594b6
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 2020-09-28 at 10:17 -0300, Marc Wittke wrote:
> 
> Disk type: intel 600p 2000GB nvme

Update: the disk seems to be fine. badblocks did two and a half passes over night without finding errors.

