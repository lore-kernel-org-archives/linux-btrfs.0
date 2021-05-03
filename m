Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248C0C433ED
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 May 2021 23:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F101461165
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 May 2021 23:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhECXqY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 May 2021 19:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhECXqY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 May 2021 19:46:24 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1577C061574
        for <linux-btrfs@vger.kernel.org>; Mon,  3 May 2021 16:45:30 -0700 (PDT)
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 141C0140570;
        Tue,  4 May 2021 01:45:28 +0200 (CEST)
Date:   Tue, 4 May 2021 01:45:27 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Simon Glass <sjg@chromium.org>
Cc:     U-Boot Mailing List <u-boot@lists.denx.de>,
        Tom Rini <trini@konsulko.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Bin Meng <bmeng.cn@gmail.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Andre Przywara <andre.przywara@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/49] btrfs: Use U-Boot API for decompression
Message-ID: <20210504014527.20fcda60@thinkpad>
In-Reply-To: <20210503171001.4.I7327e42043265556e3988928849ff2ebdc7b21e6@changeid>
References: <20210503231136.744283-1-sjg@chromium.org>
        <20210503171001.4.I7327e42043265556e3988928849ff2ebdc7b21e6@changeid>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon,  3 May 2021 17:10:51 -0600
Simon Glass <sjg@chromium.org> wrote:

> Use the common function to avoid code duplication.
> 
> Signed-off-by: Simon Glass <sjg@chromium.org>

Is this tested? Why only zstd?

marek
