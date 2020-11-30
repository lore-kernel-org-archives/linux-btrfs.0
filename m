Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D704EC64E8A
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Nov 2020 14:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714332076E
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Nov 2020 14:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgK3OIr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 09:08:47 -0500
Received: from rin.romanrm.net ([51.158.148.128]:46068 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgK3OIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Nov 2020 09:08:47 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id BFEF686E;
        Mon, 30 Nov 2020 14:08:05 +0000 (UTC)
Date:   Mon, 30 Nov 2020 19:08:05 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: do not allow -o compress-force to override
 per-inode settings
Message-ID: <20201130190805.48779810@natsu>
In-Reply-To: <a3cd057e747862eb7027ac6318bd26c6c36e0c49.1606743972.git.josef@toxicpanda.com>
References: <a3cd057e747862eb7027ac6318bd26c6c36e0c49.1606743972.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 30 Nov 2020 08:46:21 -0500
Josef Bacik <josef@toxicpanda.com> wrote:

> However some time later we got chattr -c, which is a user way of
> indicating that the file shouldn't be compressed.  This is at odds with
> -o compress-force.  We should be honoring what the user wants, which is
> to disable compression.

But chattr -c only removes the previously set chattr +c. There's no
"negative-c" to be forced by user in attributes. And +c is already unset on all
files by default. Unless I'm missing something? Thanks

-- 
With respect,
Roman
