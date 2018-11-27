Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC97C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 09:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6162C20817
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 09:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6162C20817
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbeK0Upk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 15:45:40 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57055 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeK0Upk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 15:45:40 -0500
Authentication-Results: auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 55331401078;
        Tue, 27 Nov 2018 10:48:19 +0100 (CET)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of "subvolume list/show"
Date:   Tue, 27 Nov 2018 10:48:18 +0100
Message-ID: <1924429.dG6BgaDeF9@merkaba>
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Misono Tomohiro - 27.11.18, 06:24:
> Importantly, in order to make output consistent for both root and
> non-privileged user, this changes the behavior of "subvolume list":
>  - (default) Only list in subvolume under the specified path.
>    Path needs to be a subvolume.

Does that work recursively?

I wound find it quite unexpected if I did btrfs subvol list in or on the 
root directory of a BTRFS filesystem would not display any subvolumes on 
that filesystem no matter where they are.

Thanks,
-- 
Martin


