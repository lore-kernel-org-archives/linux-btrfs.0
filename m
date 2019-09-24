Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0501C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 19:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8E0214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 19:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441943AbfIXTng (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 15:43:36 -0400
Received: from know-smtprelay-omd-9.server.virginmedia.net ([81.104.62.41]:55059
        "EHLO know-smtprelay-omd-9.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395538AbfIXTnf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 15:43:35 -0400
Received: from [172.16.100.1] ([86.12.75.74])
        by cmsmtp with ESMTPA
        id CqijilCnPVaV8Cqijitkj2; Tue, 24 Sep 2019 20:43:34 +0100
X-Originating-IP: [86.12.75.74]
X-Authenticated-User: peter.chant@ntlworld.com
X-Spam: 0
X-Authority: v=2.3 cv=PcnReBpd c=1 sm=1 tr=0 a=RxXffCTTaIU9mOmmEQ6aGA==:117
 a=RxXffCTTaIU9mOmmEQ6aGA==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=IkcTkHD0fZMA:10 a=HVY2WQRU2fakJUJiFY4A:9 a=QEXdDO2ut3YA:10
Subject: Re: Balance ENOSPC during balance despite additional storage added
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <94ebf95b-c8c2-e2d5-8db6-77a74c19644a@petezilla.co.uk>
 <20190924132217.44jhtgrk7f7bwysb@macbook-pro-91.dhcp.thefacebook.com>
From:   Pete <pete@petezilla.co.uk>
Message-ID: <636c0807-a3e7-e601-58c6-1f0d98ecfbeb@petezilla.co.uk>
Date:   Tue, 24 Sep 2019 20:42:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190924132217.44jhtgrk7f7bwysb@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBIHXdlTbw0ix4+ReQWKmCflp4S+8mf39iWa+O90+HiF6jIiJyXuZha0D1GY/QbegP+RkHjZklqGJRgCoMTGm5cIKZ0Nqavb1XPonk629+ljmfXTI8Vf
 PVK9I/00vfKu+XfG9K8fBWteDpE35pW7CpY092HiccsWtScmWTbVk2CLHAc8Qwk39npWLt8S5PsUFzwMzAkUaWuQN3h67ymaE60=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/24/19 2:22 PM, Josef Bacik wrote:

> 
> Just popping in to let you know I've been seeing this internally as well, I plan
> to dig into it after we've run down the panic we're chasing currently.  Thanks,

No problem.  The only issue it seems to be causing is balance to fail.

Pete
