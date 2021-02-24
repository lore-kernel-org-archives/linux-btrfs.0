Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B38AC433E6
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1077064F06
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhBXVkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:40:20 -0500
Received: from sandeen.net ([63.231.237.45]:40372 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235962AbhBXVkR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:40:17 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8459617264;
        Wed, 24 Feb 2021 15:39:20 -0600 (CST)
Subject: Re: xfstests seems broken on btrfs with multi-dev TEST_DEV
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-btrfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
References: <3e8f846d-e248-52a3-9863-d188f031401e@sandeen.net>
Message-ID: <5e133067-ec0c-f2c6-7fb6-84620e26881e@sandeen.net>
Date:   Wed, 24 Feb 2021 15:39:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3e8f846d-e248-52a3-9863-d188f031401e@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/24/21 10:12 AM, Eric Sandeen wrote:
> Last week I was curious to just see how btrfs is faring with RAID5 in
> xfstests, so I set it up for a quick run with devices configured as:

Whoops this was supposed to cc: fstests, not fsdevel, sorry.

-Eric

> TEST_DEV=/dev/sdb1 # <--- this was a 3-disk "-d raid5" filesystem
> SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4 /dev/sdb5 /dev/sdb6"
> 
> and fired off ./check -g auto
> 
> Every test after btrfs/124 fails, because that test btrfs/124 does this:
> 
> # un-scan the btrfs devices
> _btrfs_forget_or_module_reload
> 
> and nothing re-scans devices after that, so every attempt to mount TEST_DEV
> will fail:
> 
>> devid 2 uuid e42cd5b8-2de6-4c85-ae51-74b61172051e is missing"
> 
> Other btrfs tests seeme to have the same problem.
> 
> If xfstest coverage on multi-device btrfs volumes is desired, it might be
> a good idea for someone who understands the btrfs framework in xfstests
> to fix this.
> 
> Thanks,
> -Eric
> 
