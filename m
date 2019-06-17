Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1B4C31E57
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 10:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8423C2086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 10:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfFQKyM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 06:54:12 -0400
Received: from gardel.0pointer.net ([85.214.157.71]:56452 "EHLO
        gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfFQKyM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 06:54:12 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2019 06:54:12 EDT
Received: from gardel-login.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by gardel.0pointer.net (Postfix) with ESMTP id B7998E80B34;
        Mon, 17 Jun 2019 12:45:40 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
        id 2515D160849; Mon, 17 Jun 2019 12:45:39 +0200 (CEST)
Date:   Mon, 17 Jun 2019 12:45:39 +0200
From:   Lennart Poettering <mzerqung@0pointer.de>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] 5.2rc2, circular lock warning systemd-journal
 and btrfs_page_mkwrite
Message-ID: <20190617104539.GF24827@gardel-login>
References: <CAJCQCtS4PRWU=QUY87FRd4uGE_wA+KSSLW+2e_9XDs5m+RYzsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtS4PRWU=QUY87FRd4uGE_wA+KSSLW+2e_9XDs5m+RYzsQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Di, 04.06.19 12:24, Chris Murphy (lists@colorremedies.com) wrote:

> This is on Fedora Rawhide
> systemd-242-3.git7a6d834.fc31.x86_64
> kernel 5.2.0-0.rc2.git1.2.fc31.x86_64

Please report to the kernel btrfs maintainers, this is not a userspace
problem.

Thanks,

Lennart

--
Lennart Poettering, Berlin
