Return-Path: <SRS0=TQMp=4F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E801C34022
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E5F02072C
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgBQNtg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:49:36 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:35641 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgBQNtg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Feb 2020 08:49:36 -0500
Received: from [10.137.0.38] (unknown [88.191.131.7])
        (Authenticated sender: swami@petaramesh.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2269E240007;
        Mon, 17 Feb 2020 13:49:34 +0000 (UTC)
Subject: Re: btrfs: convert metadata from raid5 to raid1
To:     Menion <menion@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJVZm6ewSViEzKRV4bwZFEYXYLhtx2QFvGiQJOD1sNdizL4HjA@mail.gmail.com>
From:   =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Message-ID: <641d8ba2-89c1-83ac-155f-f661f511218a@petaramesh.org>
Date:   Mon, 17 Feb 2020 14:49:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAJVZm6ewSViEzKRV4bwZFEYXYLhtx2QFvGiQJOD1sNdizL4HjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On 2020-02-17 14:43, Menion wrote:
> What is the correct procedure to convert metadata from raid5 to proper
> raid scheme (raid1 or)?

# btrfs balance start -mconvert=raid1 /array/mount/point should do the trick

ॐ

-- 

Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E

