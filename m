Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554D6C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 215BF206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 215BF206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbeJMEeJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 00:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725743AbeJMEeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 00:34:09 -0400
Received: from localhost.localdomain (c-24-4-154-175.hsd1.ca.comcast.net [24.4.154.175])
        by mail.linuxfoundation.org (Postfix) with ESMTPSA id 99075DA2;
        Fri, 12 Oct 2018 20:59:50 +0000 (UTC)
Date:   Fri, 12 Oct 2018 13:59:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 2/6] mm: export add_swap_extent()
Message-Id: <20181012135949.321223ab4adfd6d34093fdaa@linux-foundation.org>
In-Reply-To: <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
References: <cover.1536704650.git.osandov@fb.com>
        <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 11 Sep 2018 15:34:45 -0700 Omar Sandoval <osandov@osandov.com> wrote:

> From: Omar Sandoval <osandov@fb.com>
> 
> Btrfs will need this for swap file support.
> 

Acked-by: Andrew Morton <akpm@linux-foundation.org>
