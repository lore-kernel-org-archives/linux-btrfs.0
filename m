Return-Path: <SRS0=gyFW=6N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32771C83000
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F3521D91
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD2PpK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:45:10 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:57237 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD2PpK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Apr 2020 11:45:10 -0400
Received: from mxback21j.mail.yandex.net (mxback21j.mail.yandex.net [IPv6:2a02:6b8:0:1619::221])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 99134B2109D
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2020 18:45:07 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by mxback21j.mail.yandex.net (mxback/Yandex) with ESMTP id LiEqJBPMZb-j7oCHTJx;
        Wed, 29 Apr 2020 18:45:07 +0300
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id liQrDeyEwi-j6C4cJWp;
        Wed, 29 Apr 2020 18:45:07 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: many csum warning/errors on qemu guests using btrfs
From:   Michal Soltys <msoltyspl@yandex.pl>
To:     linux-btrfs@vger.kernel.org
References: <0ee3844d-830f-9f29-2cd5-61e3c9744979@yandex.pl>
Message-ID: <76ec883b-3e44-fcda-d981-93a9e120f56d@yandex.pl>
Date:   Wed, 29 Apr 2020 17:45:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0ee3844d-830f-9f29-2cd5-61e3c9744979@yandex.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Short update:

1) turned out to not be btrfs fault in any way or form, as we recreated 
the same issue with ext4 while manually checksumming the files; so if 
anything, btrfs told us we have actual issues somewhere =)

2) qemu/vm scenario is also not to be blamed, as we recreated the issue 
directly on the host as well

So as far as I can see, both of the above narrows the potential culprits 
to either faulty/buggy hardware/firmware somewhere - or - some subtle 
lvm/md/kernel issues. Though so far pinpointing the issue is proving 
rather frustrating.


Anyway, sorry for the noise.
