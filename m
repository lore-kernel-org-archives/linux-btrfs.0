Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD385C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44DA02146D
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44DA02146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbeLFG0b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:26:31 -0500
Received: from len.romanrm.net ([91.121.75.85]:33476 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbeLFG0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:26:31 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id E0F5B20284;
        Thu,  6 Dec 2018 06:26:28 +0000 (UTC)
Date:   Thu, 6 Dec 2018 11:26:28 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Robert White <rwhite@pobox.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: What if TRIM issued a wipe on devices that don't TRIM?
Message-ID: <20181206112628.77a7ea58@natsu>
In-Reply-To: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
References: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 6 Dec 2018 06:11:46 +0000
Robert White <rwhite@pobox.com> wrote:

> So it would be dog-slow, but it would be neat if BTRFS had a mount 
> option to convert any TRIM command from above into the write of a zero, 
> 0xFF, or trash block to the device below if that device doesn't support 
> TRIM. Real TRIM support would override the block write.

There is such a project:

  "dm-linear like target which provides discard, but replaces it with write of
  random data to a discarded region. Thus, discarded data is securely deleted."

  https://github.com/vt-alt/dm-secdel

-- 
With respect,
Roman
