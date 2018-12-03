Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9F5C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 20:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284A72145D
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 20:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 284A72145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bouton.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbeLCUEq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 15:04:46 -0500
Received: from ns.bouton.name ([109.74.195.142]:43600 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbeLCUEp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 15:04:45 -0500
Received: from [192.168.0.47] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id 8FD2AB849;
        Mon,  3 Dec 2018 21:04:42 +0100 (CET)
Subject: Re: BTRFS Mount Delay Time Graph
From:   Lionel Bouton <lionel-subscription@bouton.name>
To:     "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name>
Message-ID: <56fe7298-af8b-05ac-bc0c-4531abd56476@bouton.name>
Date:   Mon, 3 Dec 2018 21:04:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 03/12/2018 à 20:56, Lionel Bouton a écrit :
> [...]
> Note : recently I tried upgrading from 4.9 to 4.14 kernels, various
> tuning of the io queue (switching between classic io-schedulers and
> blk-mq ones in the virtual machines) and BTRFS mount options
> (space_cache=v2,ssd_spread) but there wasn't any measurable improvement
> in mount time (I managed to reduce the mount of IO requests

Sent to quickly : I meant to write "managed to reduce by half the number
of IO write requests for the same amount of data writen"

>  by half on
> one server in production though although more tests are needed to
> isolate the cause).


