Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5333C5518E
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E38520857
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgDVK16 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730966AbgDVK15 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:57 -0400
X-Greylist: delayed 1752 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 03:27:57 PDT
Received: from wp558.webpack.hosteurope.de (wp558.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8250::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C14C03C1A8
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2020 03:27:57 -0700 (PDT)
Received: from mail1.i-concept.de ([130.180.70.237] helo=[192.168.122.235]); authenticated
        by wp558.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jRC9S-0004dr-O5; Wed, 22 Apr 2020 11:58:42 +0200
To:     linux-btrfs@vger.kernel.org
From:   Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: RAID 1 | Newbie Question
Message-ID: <be4ee7ea-f032-ee63-2486-030b2f270baa@peter-speer.de>
Date:   Wed, 22 Apr 2020 11:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;stefanie.leisestreichler@peter-speer.de;1587551277;97b0a1e9;
X-HE-SMSGID: 1jRC9S-0004dr-O5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi.
I might be a first time user with btrfs for a new system I will set up.

Just want to make sure: As I read the docs, the note about RAID 1 and 
that there will be no redundant data is true only, if the RAID, which is 
possible, is set up to use only 1 physical device, right?

If RAID 1 using btrfs is defined to use two seperate disk, say /dev/sda2 
and /dev/sdb2, I will have the same redundancy like using md. Is this 
correct?

Thanks,
Steffi
