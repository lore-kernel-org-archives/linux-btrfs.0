Return-Path: <SRS0=nnCd=2M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1165C2D0C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Dec 2019 09:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD01220665
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Dec 2019 09:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfLVJWQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Dec 2019 04:22:16 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34515 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfLVJWQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Dec 2019 04:22:16 -0500
X-Originating-IP: 88.191.131.7
Received: from [192.168.1.168] (unknown [88.191.131.7])
        (Authenticated sender: swami@petaramesh.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D5765E0002;
        Sun, 22 Dec 2019 09:22:14 +0000 (UTC)
Subject: Re: Kernel 5.4 - BTRFS FS shows full with about 600 GB Free ?
From:   =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
References: <8bd55f28-2176-89f7-bd53-4992ccd53f42@petaramesh.org>
 <81dec38b-ec8e-382e-7dfe-cb331f418ffa@gmx.com>
 <e743df15-4830-8d83-bc36-6ddd33c1e720@petaramesh.org>
 <dd37e99c-e087-2b6d-830a-96811b337ba2@gmx.com>
 <bd183df9-4742-301d-251c-443d99d170c7@petaramesh.org>
Message-ID: <3e4119ec-c8f5-4837-c608-59bb508a572d@petaramesh.org>
Date:   Sun, 22 Dec 2019 10:22:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bd183df9-4742-301d-251c-443d99d170c7@petaramesh.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 22/12/2019 à 10:00, Swâmi Petaramesh a écrit :
> Because in the one disk on which I observe this (and which passes a full 
> btrfs check with bells and whistles) it still shows 0% free after 2 days 
> and several unmounts / remounts...
> 
> Furthermore I've conected it to machines using 5.3 and even 4.15 
> kernels, and they *ALL* state that the free disk space is zero - even 
> though I can understand if « That check is from 2015 ».

For the record, a « btrfs balance start -m » apparently fixed it.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E
