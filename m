Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3BDC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C8A1206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfCLNdI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 09:33:08 -0400
Received: from endor150-229.endor.pl ([91.194.229.150]:53653 "EHLO
        naboo.endor.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725774AbfCLNdI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 09:33:08 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by naboo.endor.pl (Postfix) with ESMTP id 0D9291A1683
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 14:33:03 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at 
Received: from naboo.endor.pl ([91.194.229.149])
        by localhost (naboo.endor.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PTNLVtYng9iy for <linux-btrfs@vger.kernel.org>;
        Tue, 12 Mar 2019 14:33:00 +0100 (CET)
Received: from orion.dubielvitrum.pl (91-231-23-50.studiowik.net.pl [91.231.23.50])
        (Authenticated sender: postmaster@dubielvitrum.pl)
        by naboo.endor.pl (Postfix) with ESMTPSA id 9B67A1A16EA
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 14:33:00 +0100 (CET)
Received: from [192.168.18.35]
        by orion.dubielvitrum.pl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <leszek.dubiel@dubielvitrum.pl>)
        id 1h3hWd-0003J4-Nw
        for linux-btrfs@vger.kernel.org; Tue, 12 Mar 2019 14:32:59 +0100
From:   Leszek Dubiel <leszek.dubiel@dubielvitrum.pl>
Subject: a bug on: v4.20.1 : check/main.c:4728: add_data_backref: BUG_ON
 `!back` triggered, value 1 items checked)
To:     linux-btrfs@vger.kernel.org
Message-ID: <fafadd0f-d246-dda1-e0e6-5563c74225e4@dubielvitrum.pl>
Date:   Tue, 12 Mar 2019 14:32:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: pl-PL
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


As suggested on irc channel:

http://logs.tvrrug.org.uk/logs/%23btrfs/2019-03-11.html#2019-03-11T23:28:40

I should file a bug on btrfs tools:

check/main.c:4728: add_data_backref: BUG_ON `!back` triggered, value 1 
items checked)

after doing

btrfs check

on a btrfs file system that shows 355 GB (giga) free space, but when 
trying to do anything on files dumps error "no space left on device".




