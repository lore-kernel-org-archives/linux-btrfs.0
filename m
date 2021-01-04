Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367C4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Jan 2021 16:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE8D22518
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Jan 2021 16:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbhADQAy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:00:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:55226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbhADQAo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7D0CACAF;
        Mon,  4 Jan 2021 16:00:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20BD4DA882; Mon,  4 Jan 2021 16:58:13 +0100 (CET)
Date:   Mon, 4 Jan 2021 16:58:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Su Yue <l@damenly.su>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: fix issues when mouting the poc image
Message-ID: <20210104155813.GH6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yue <l@damenly.su>,
        linux-btrfs@vger.kernel.org
References: <20210103092804.756-1-l@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103092804.756-1-l@damenly.su>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jan 03, 2021 at 05:28:02PM +0800, Su Yue wrote:
> The two patches fix issues found by the image which is provided by
> Insu Yun at SSLab@Gatech.
> 
> patch 1 fixes a NULL pointer dereference in error handling path.
> patch 2 enhances tree checker to detect chunk item end overflow.
> 
> Su Yue (2):
>   btrfs: prevent NULL pointer dereference in extent_io_tree_panic()
>   btrfs: tree-checker: check if chunk item end oveflows

Thanks, added to misc-next. I've slightly updated the error message in
patch 2, to say that it's the 'logical start' of the chunk.
