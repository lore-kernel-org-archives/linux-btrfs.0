Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F504C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D8A20684
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2D8A20684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395315AbeKWAmk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 19:42:40 -0500
Received: from len.romanrm.net ([91.121.75.85]:50462 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388851AbeKWAmk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 19:42:40 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 05658203AD;
        Thu, 22 Nov 2018 14:03:06 +0000 (UTC)
Date:   Thu, 22 Nov 2018 19:03:07 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
Message-ID: <20181122190307.45b10248@natsu>
In-Reply-To: <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
References: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
 <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
 <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 22 Nov 2018 22:07:25 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:

> Spot on!
> 
> Removed "discard" from fstab and added "ssd", rebooted - no more 
> btrfs-cleaner running.

Recently there has been a bugfix for TRIM in Btrfs:
  
  btrfs: Ensure btrfs_trim_fs can trim the whole fs
  https://patchwork.kernel.org/patch/10579539/

Perhaps your upgraded kernel is the first one to contain it, and for the first
time you're seeing TRIM to actually *work*, with the actual performance impact
of it on a large fragmented FS, instead of a few contiguous unallocated areas.

-- 
With respect,
Roman
