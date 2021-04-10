Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189BBC43470
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Apr 2021 14:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7F2610CD
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Apr 2021 14:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhDJOtE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 10:49:04 -0400
Received: from rin.romanrm.net ([51.158.148.128]:59038 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234698AbhDJOtD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Apr 2021 10:49:03 -0400
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 763B2720;
        Sat, 10 Apr 2021 14:48:43 +0000 (UTC)
Date:   Sat, 10 Apr 2021 19:48:42 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Paul Leiber <paul@onlineschubla.de>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Parent transid verify failed (and more): BTRFS for data storage
 in Xen VM setup
Message-ID: <20210410194842.71f49059@natsu>
In-Reply-To: <FRYP281MB058285E8F1BD4B521817F6CFB0729@FRYP281MB0582.DEUP281.PROD.OUTLOOK.COM>
References: <FRYP281MB058285E8F1BD4B521817F6CFB0729@FRYP281MB0582.DEUP281.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 10 Apr 2021 13:38:57 +0000
Paul Leiber <paul@onlineschubla.de> wrote:

> d) Perhaps the complete BTRFS setup (Xen, VMs, pass through the partition, Samba share) is flawed?

I kept reading and reading to find where you say you unmounted in on the host,
and then... :)

> e) Perhaps it is wrong to mount the BTRFS root first in the Dom0 and then accessing the subvolumes in the DomU?

Absolutely O.o

Subvolumes are very much like directories, not any kind of subpartitions.

Imagine you'd try to use the same ext4 from the host and from a VM guest,
saying "but they both store their data in separate folders!"

-- 
With respect,
Roman
