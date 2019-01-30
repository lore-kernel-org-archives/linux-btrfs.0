Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E577C282D5
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 08:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9CAC21473
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 08:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfA3IuS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 03:50:18 -0500
Received: from len.romanrm.net ([91.121.75.85]:47248 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbfA3IuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 03:50:18 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2019 03:50:17 EST
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id E209E2038B;
        Wed, 30 Jan 2019 08:42:19 +0000 (UTC)
Date:   Wed, 30 Jan 2019 13:42:19 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
Message-ID: <20190130134219.13a4b558@natsu>
In-Reply-To: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 29 Jan 2019 23:15:18 +0000
Hans van Kranenburg <Hans.van.Kranenburg@mendix.com> wrote:

> So, what I was thinking of is:
> 
> * Use dm-integrity on partitions on the individual disks
> * Use mdadm RAID10 on top (which is then able to repair bitrot)
> * Use LVM on top
> * Etc...

You never explicitly say what's the whole idea, what are you protecting
against. By mentions of bitrot and of dm-integrity, you seem to think that
when hardware is "starting to fall apart" the disks will eventually start
returning wrong/corrupt data.

Thing is, they do not. What you will get on disks going bad is uncorrectable
read errors (UNC), not a silent corruption. The latter is still possible, but
more likely to be caused by the SATA controller issues (or its
driver/firmware), not disks. And those are hardly related to whether it's
"new" or "old".

-- 
With respect,
Roman
