Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF5BC433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E4764EB3
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBUJoL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 04:44:11 -0500
Received: from smtp-out-4.tiscali.co.uk ([62.24.135.132]:47508 "EHLO
        smtp-out-4.tiscali.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBUJoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Feb 2021 04:44:00 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2021 04:43:59 EST
Received: from [192.168.1.96] ([31.51.156.132])
        by smtp.talktalk.net with SMTP
        id DlAYl7qfakzENDlAYlTftT; Sun, 21 Feb 2021 09:36:50 +0000
X-Originating-IP: [31.51.156.132]
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
Reply-To: tai63@dial.pipex.com
References: <173bc320-4d67-6752-86cb-119dc9fb9a69@dial.pipex.com>
To:     linux-btrfs@vger.kernel.org
From:   tai63 <tai63@dial.pipex.com>
X-Forwarded-Message-Id: <173bc320-4d67-6752-86cb-119dc9fb9a69@dial.pipex.com>
Message-ID: <4a793b28-8814-7898-e72c-0cb2c7f29054@dial.pipex.com>
Date:   Sun, 21 Feb 2021 09:36:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <173bc320-4d67-6752-86cb-119dc9fb9a69@dial.pipex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 210221-0, 21/02/2021), Outbound message
X-Antivirus-Status: Clean
X-CMAE-Envelope: MS4wfFc9J9MYRaSXLaf9IRoR/k5mUhbIj5I4TuOvp1nzSRFPmD2jM57DVn7X4EC6F3Yv5W5N7jcRsBEbMCwDKucXUYOa5Uivlj72Q9VV0PhD6Gmfx7g8WB0I
 g7n+zll0ECAsolDfPgrEQ3KxZiFIVanu033ad0KL3DcEb+HFx4XSbs3fb2ffvpT5m0O335pamaoDNA==
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear Qu Wenruo/all


Did this patch ever get accepted?

This is the one which allowed a degraded disk to be RW if it was safe to 
do so.

For my use case (2 disk NAS RAID1) this is the one patch I'm waiting for 
before upgrading to BTRFS, I suspect I'm not alone.

It would help avoid being locked into a Read Only situation on disk failure


FYI the original RFC was submitted on Mon, 11 Feb 2019 23:04:25


Thanks

Tai

