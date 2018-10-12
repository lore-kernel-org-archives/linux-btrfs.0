Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E074AC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A822098A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82A822098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbeJMEdz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 00:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725743AbeJMEdz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 00:33:55 -0400
Received: from localhost.localdomain (c-24-4-154-175.hsd1.ca.comcast.net [24.4.154.175])
        by mail.linuxfoundation.org (Postfix) with ESMTPSA id E0976DA2;
        Fri, 12 Oct 2018 20:59:35 +0000 (UTC)
Date:   Fri, 12 Oct 2018 13:59:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 1/6] mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
Message-Id: <20181012135934.b8dbbaaf8a01011ec21b5aba@linux-foundation.org>
In-Reply-To: <6d63d8668c4287a4f6d203d65696e96f80abdfc7.1536704650.git.osandov@fb.com>
References: <cover.1536704650.git.osandov@fb.com>
        <6d63d8668c4287a4f6d203d65696e96f80abdfc7.1536704650.git.osandov@fb.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 11 Sep 2018 15:34:44 -0700 Omar Sandoval <osandov@osandov.com> wrote:

> From: Omar Sandoval <osandov@fb.com>
> 
> The SWP_FILE flag serves two purposes: to make swap_{read,write}page()
> go through the filesystem, and to make swapoff() call
> ->swap_deactivate(). For Btrfs, we want the latter but not the former,
> so split this flag into two. This makes us always call
> ->swap_deactivate() if ->swap_activate() succeeded, not just if it
> didn't add any swap extents itself.
> 
> This also resolves the issue of the very misleading name of SWP_FILE,
> which is only used for swap files over NFS.
> 

Acked-by: Andrew Morton <akpm@linux-foundation.org>
