Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508DAC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131DD206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 131DD206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bouton.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbeLDPIx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:08:53 -0500
Received: from ns.bouton.name ([109.74.195.142]:39548 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbeLDPIw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 10:08:52 -0500
Received: from [192.168.30.46] (laubervilliers-657-1-19-239.w80-15.abo.wanadoo.fr [80.15.154.239])
        by mail.bouton.name (Postfix) with ESMTP id 430D0B849;
        Tue,  4 Dec 2018 16:08:51 +0100 (CET)
Subject: Re: BTRFS Mount Delay Time Graph
To:     Chris Murphy <lists@colorremedies.com>
Cc:     "Ellis H. Wilson III" <ellisw@panasas.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name>
 <56fe7298-af8b-05ac-bc0c-4531abd56476@bouton.name>
 <CAJCQCtSVdkfgr+X5DfhaBuMy-fWdWbT4UHJo8Vsuw4CtVBfN4g@mail.gmail.com>
From:   Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <2d4976bb-d78b-d6da-4a1e-31a2ef268597@bouton.name>
Date:   Tue, 4 Dec 2018 16:08:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSVdkfgr+X5DfhaBuMy-fWdWbT4UHJo8Vsuw4CtVBfN4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 04/12/2018 à 03:52, Chris Murphy a écrit :
> On Mon, Dec 3, 2018 at 1:04 PM Lionel Bouton
> <lionel-subscription@bouton.name> wrote:
>> Le 03/12/2018 à 20:56, Lionel Bouton a écrit :
>>> [...]
>>> Note : recently I tried upgrading from 4.9 to 4.14 kernels, various
>>> tuning of the io queue (switching between classic io-schedulers and
>>> blk-mq ones in the virtual machines) and BTRFS mount options
>>> (space_cache=v2,ssd_spread) but there wasn't any measurable improvement
>>> in mount time (I managed to reduce the mount of IO requests
>> Sent to quickly : I meant to write "managed to reduce by half the number
>> of IO write requests for the same amount of data writen"
>>
>>>  by half on
>>> one server in production though although more tests are needed to
>>> isolate the cause).
> Interesting. I wonder if it's ssd_spread or space_cache=v2 that
> reduces the writes by half, or by how much for each? That's a major
> reduction in writes, and suggests it might be possible for further
> optimization, to help mitigate the wandering trees impact.

Note, the other major changes were :
- 4.9 upgrade to 1.14,
- using multi-queue aware bfq instead of noop.

If BTRFS IO patterns in our case allow bfq to merge io-requests, this
could be another explanation.

Lionel

