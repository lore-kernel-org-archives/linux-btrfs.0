Return-Path: <SRS0=psRg=A2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26C3C433E6
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D879A206D5
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgGOOzz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:55:55 -0400
Received: from bang.steev.me.uk ([81.2.120.65]:39457 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgGOOzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jul 2020 10:55:54 -0400
Received: from smtp.steev.me.uk ([2001:8b0:162c:10::25] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.93.0.4)
        id 1jvip7-00Eg69-MD
        for linux-btrfs@vger.kernel.org; Wed, 15 Jul 2020 15:55:53 +0100
MIME-Version: 1.0
Date:   Wed, 15 Jul 2020 15:55:53 +0100
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     linux-btrfs@vger.kernel.org
Subject: Wiki updates - source location
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <2fd9b9626b55cf738dbe81ca45552950@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Could someone with the relevant access update the btrfs wiki main 
page[1] to point at the kdave repository rather than mason? I think a 
pointer to where to find the misc-next branch could be useful too.

[1] 
https://btrfs.wiki.kernel.org/index.php/Main_Page#Source_code_download

-- 
Steven Davies
