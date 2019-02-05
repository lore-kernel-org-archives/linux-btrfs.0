Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8244CC282CC
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 17:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C232175B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 17:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mPDDPXfL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfBERkt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 12:40:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49636 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfBERks (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 12:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZHgX6S6qitlSMvB4nbnOD/KOedjMr+Z/UNhlFWQV/FM=; b=mPDDPXfLuDKaJBOOZ7icmTW/GW
        ZUTfMQMLRvzNXMNj8AmASxH/G4dAnsqZZH9sJqRpw6flP3LnEfRimfQfJ8H4GxIGmqfMObZPylx7S
        Sp9inmirLZW4iMLNqagXHtW1G5qBbpSl3UMAeMgnRKdHdTKoULhW5bHo9D7u4ABS2dBVt3HXHqrnk
        7DqKnSw6lyl7a08f7BWIOIW2TQeU/Q1X6I4r8na/QaprovLNqgdF5YPohQQJQ15Np6gFVbKu/aUrt
        fDgPMZ+Cp6Us5o1HA/OgSEYofAWjFhISjDSnZhl4tVg8bco2rL5GMzLZ6PkqfPcnIIu2vavrCuMlp
        jdLIGhRg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gr4iE-0005eO-Em; Tue, 05 Feb 2019 17:40:46 +0000
Subject: Re: linux-next: Tree for Feb 5 (btrfs/zstd)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <20190205171228.41a9f771@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <26ce21e5-0e3c-d847-c895-6cb166507441@infradead.org>
Date:   Tue, 5 Feb 2019 09:40:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190205171228.41a9f771@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/4/19 10:12 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190204:
> 

on i386:

../fs/btrfs/zstd.c: In function ‘zstd_reclaim_timer_fn’:
../fs/btrfs/zstd.c:27:35: warning: integer overflow in expression [-Woverflow]
 #define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
                                   ^
../fs/btrfs/zstd.c:96:33: note: in expansion of macro ‘ZSTD_BTRFS_RECLAIM_NS’
   if (now < victim->last_used + ZSTD_BTRFS_RECLAIM_NS)
                                 ^


-- 
~Randy
