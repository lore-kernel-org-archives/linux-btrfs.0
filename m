Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E14DC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 20:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D4520858
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 20:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3D4520858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbeKPG2N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 01:28:13 -0500
Received: from len.romanrm.net ([91.121.75.85]:58374 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbeKPG2N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 01:28:13 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 69D0C20243;
        Thu, 15 Nov 2018 20:18:54 +0000 (UTC)
Date:   Fri, 16 Nov 2018 01:18:54 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Juan Alberto Cirez <jacirez@rdcsafety.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: BTRFS on production: NVR 16+ IP Cameras
Message-ID: <20181116011854.0f1d1c9a@natsu>
In-Reply-To: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
References: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 15 Nov 2018 11:39:58 -0700
Juan Alberto Cirez <jacirez@rdcsafety.com> wrote:

> Is BTRFS mature enough to be deployed on a production system to underpin 
> the storage layer of a 16+ ipcameras-based NVR (or VMS if you prefer)?

What are you looking to gain from using Btrfs on an NVR system? It doesn't
sound like any of its prime-time features -- such as snapshots, checksumming,
compression or reflink copying -- are a must for a bulk video recording
scenario.

And even if you don't need or use those features, you still pay the price for
having them, Btrfs can be 2x to 10x slower than its simpler competitors:
https://www.phoronix.com/scan.php?page=article&item=linux418-nvme-raid&num=2

If you just meant to use its multi-device support instead of a separate RAID
layer, IMO that can't be considered prime-time or depended upon in production
(yes, not even RAID 1 or 10).

-- 
With respect,
Roman
