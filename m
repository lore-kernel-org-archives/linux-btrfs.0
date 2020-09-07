Return-Path: <SRS0=pkqV=CQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E562C43461
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Sep 2020 23:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB31820714
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Sep 2020 23:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgIGX6L convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 19:58:11 -0400
Received: from lists.nic.cz ([217.31.204.67]:50470 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgIGX6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Sep 2020 19:58:06 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5A79614004F;
        Tue,  8 Sep 2020 01:58:02 +0200 (CEST)
Date:   Tue, 8 Sep 2020 01:58:01 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Tom Rini <trini@konsulko.com>
Cc:     u-boot@lists.denx.de,
        Alberto =?UTF-8?B?U8OhbmNoZXo=?= Molero <alsamolero@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Pierre Bourdon <delroth@gmail.com>,
        Simon Glass <sjg@chromium.org>,
        Yevgeny Popovych <yevgenyp@pointgrab.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH U-BOOT v3 03/30] fs: btrfs: Crossport
 btrfs_read_dev_super() from btrfs-progs
Message-ID: <20200908015801.3b72869a@nic.cz>
In-Reply-To: <20200907222604.GA706@bill-the-cat>
References: <20200624160316.5001-1-marek.behun@nic.cz>
        <20200624160316.5001-4-marek.behun@nic.cz>
        <20200907222604.GA706@bill-the-cat>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 7 Sep 2020 18:26:04 -0400
Tom Rini <trini@konsulko.com> wrote:

> On Wed, Jun 24, 2020 at 06:02:49PM +0200, Marek Behún wrote:
> 
> > From: Qu Wenruo <wqu@suse.com>
> > 
> > This patch uses generic code from btrfs-progs to read one super block
> > from block device.  
> [snip]
> > +/* Provide a compatibility layer to make code syncing easier */
> > +
> > +/* A simple wraper to for error() used in btrfs-progs */
> > +__attribute__((format (__printf__, 1, 2)))
> > +static inline void error(const char *fmt, ...)
> > +{
> > +	printf("BTRFS: ");
> > +	printf(fmt, __builtin_va_arg_pack());
> > +	printf("\n");
> > +}  
> 
> Note that this does not work with LLVM (no __builtin_va_arg_pack()).
> I'm reworking this call pr_err(...) under the hood instead, with "BTRFS: " 
> included in the message.
> 

:( clang does not support it? Even the newest version? That is a pity.

Marek
