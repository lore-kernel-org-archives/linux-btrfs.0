Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24E9C43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 19:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6CC206A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 19:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfD1Tfb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 15:35:31 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:48166 "EHLO
        smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfD1Tfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 15:35:31 -0400
Received: from [94.217.144.7] (helo=[192.168.177.20])
        by smtprelay01.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hendrik@friedels.name>)
        id 1hKpaC-0006PD-IE
        for linux-btrfs@vger.kernel.org; Sun, 28 Apr 2019 21:35:28 +0200
From:   "Hendrik Friedel" <hendrik@friedels.name>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Migration to BTRFS
Date:   Sun, 28 Apr 2019 19:35:28 +0000
Message-Id: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
User-Agent: eM_Client/7.2.34062.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Df-Sender: aGVuZHJpa0BmcmllZGVscy5uYW1l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I intend to move to BTRFS and of course I have some data already.
I currently have several single 4TB drives and I would like to move the 
Data onto new drives (2*8TB). I need no raid, as I prefer a backup. 
Nevertheless, having raid nice for availability. So why not in the end. 
I currently use ~6TB, so it may work, but I would be able to remove the 
redundancy later.

So, if I understand correctly, today I want
-m raid1 -d raid1

whereas later, I want
-m raid1 -d single

What is very important to me is, that with one failing drive, I have no 
risk of losing the whole filesystem, but only losing the affected drive. 
Is that possible with both of these variants?

Is it possible to move between the two (doing a balance, of course?
Any other thoughts/recommendations?

Greetings,
Hendrik


