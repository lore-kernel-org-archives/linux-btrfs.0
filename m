Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA0ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 13:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A21D21526
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 13:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A21D21526
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbeJQVsW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:48:22 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:35920 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeJQVsW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 17:48:22 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1875687AbeJQNv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 15:51:28 +0200
Date:   Wed, 17 Oct 2018 15:51:28 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Message-ID: <20181017135128.GB25306@router-fw-old.i.net-space.pl>
References: <20181011185103.23146-1-kreijack@libero.it> <20181011185103.23146-5-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011185103.23146-5-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 08:50:58PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Currently read from missing device triggers rescan. However, it is never
> recorded that the device is missing. So, each read of a missing device
> triggers rescan again and again. This behavior causes a lot of unneeded
> rescans leading to huge slowdowns.
>
> This patch fixes above mentioned issue. Information about missing devices
> is stored in the data->devices_attached[] array as NULL value in dev
> member. Rescan is triggered only if no information is found for a given
> device. This means that only first time read triggers rescan.
>
> The patch drops premature return. This way data->devices_attached[] is
> filled even when a given device is missing.
>
> Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>

I changed commit message, so, you should add
  Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>

I simply forgot to tell you about that. Sorry.

And below you can add
  Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
