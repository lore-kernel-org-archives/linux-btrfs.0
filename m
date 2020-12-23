Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B649C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 15:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36E3322202
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 15:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgLWPia (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 10:38:30 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:34618 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgLWPi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Dec 2020 10:38:29 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ks6Cp-0004Hq-UK; Wed, 23 Dec 2020 16:37:39 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        ebiggers@kernel.org, Damien.LeMoal@wdc.com, mpatocka@redhat.com,
        herbert@gondor.apana.org.au, kernel-team@cloudflare.com,
        nobuto.murata@canonical.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
Subject: Re: dm-crypt with no_read_workqueue and no_write_workqueue + btrfs
 scrub = BUG()
Message-ID: <74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
Date:   Wed, 23 Dec 2020 16:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 14.12.2020 19:11, Maciej S. Szmigiero wrote:
> Hi,
> 
> I hit a reproducible BUG() when scrubbing a btrfs fs on top of
> a dm-crypt device with no_read_workqueue and no_write_workqueue
> flags enabled.

Still happens on the current torvalds/master.

Due to this bug it is not possible to use btrfs on top of
a dm-crypt device with no_read_workqueue and no_write_workqueue
flags enabled.

@Ignat:
Can you have a look at this as the person who added these flags?

It looks like to me that the skcipher API might not be safe to
call from a softirq context, after all.

Maciej
