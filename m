Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AD2C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 21:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1F02246B
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 21:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgLWVUl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:20:41 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:40312 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgLWVUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Dec 2020 16:20:41 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ksBXv-0005iQ-Eq; Wed, 23 Dec 2020 22:19:47 +0100
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team <kernel-team@cloudflare.com>,
        Nobuto Murata <nobuto.murata@canonical.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
 <74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
 <CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: dm-crypt with no_read_workqueue and no_write_workqueue + btrfs
 scrub = BUG()
Message-ID: <fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
Date:   Wed, 23 Dec 2020 22:19:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 23.12.2020 22:09, Ignat Korchagin wrote:
(..)
> I've been looking into this for the last couple of days because of
> other reports [1].
> Just finished testing a possible solution. Will submit soon.

Thanks for looking into it.

By the way, on a bare metal I am actually hitting a different problem
(scheduling while atomic) when scrubbing a btrfs filesystem, just as one
of your users from that GitHub report had [1].

I've pasted that backtrace in my original Dec 14 message.

Thanks,
Maciej

[1]: https://github.com/cloudflare/linux/issues/1#issuecomment-736734243
