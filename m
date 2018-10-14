Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C40EC6787C
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 11:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F7B20644
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 11:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14F7B20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dirtcellar.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbeJNSt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 14:49:26 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:33631 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbeJNSt0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 14:49:26 -0400
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:17541 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gBeGJ-0004li-1P
        for linux-btrfs@vger.kernel.org; Sun, 14 Oct 2018 13:08:43 +0200
Reply-To: waxhead@dirtcellar.net
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   waxhead <waxhead@dirtcellar.net>
Subject: BTRFS bad block management. Does it exist?
Message-ID: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
Date:   Sun, 14 Oct 2018 13:08:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In case BTRFS fails to WRITE to a disk. What happens?
Does the bad area get mapped out somehow? Does it try again until it 
succeed or until it "times out" or reach a threshold counter?
Does it eventually try to write to a different disk (in case of using 
the raid1/10 profile?)
