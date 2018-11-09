Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A571C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B6DC20827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B6DC20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbeKJECi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:02:38 -0500
Received: from len.romanrm.net ([91.121.75.85]:43992 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbeKJECi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 23:02:38 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 3ECA320422;
        Fri,  9 Nov 2018 18:20:53 +0000 (UTC)
Date:   Fri, 9 Nov 2018 23:20:52 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount btrfs after upgrading from 4.16.1 to 4.19.1
Message-ID: <20181109232052.19233269@natsu>
In-Reply-To: <2442f641ad54ce98361cf40b70e4d18d@virtall.com>
References: <2442f641ad54ce98361cf40b70e4d18d@virtall.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 10 Nov 2018 03:08:01 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:

> After upgrading from kernel 4.16.1 to 4.19.1 and a clean restart, the fs 
> no longer mounts:

Did you try rebooting back to 4.16.1 to see if it still mounts there?

-- 
With respect,
Roman
