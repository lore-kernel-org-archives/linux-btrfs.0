Return-Path: <SRS0=nEr2=X4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5176EC4360C
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F162D222C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="t5B8jB8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfJCBrG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 21:47:06 -0400
Received: from forward103o.mail.yandex.net ([37.140.190.177]:54493 "EHLO
        forward103o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbfJCBrG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Oct 2019 21:47:06 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id E80095F80316;
        Thu,  3 Oct 2019 04:47:01 +0300 (MSK)
Received: from mxback4q.mail.yandex.net (mxback4q.mail.yandex.net [IPv6:2a02:6b8:c0e:6d:0:640:ed15:d2bd])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id E3D4361E0004;
        Thu,  3 Oct 2019 04:47:01 +0300 (MSK)
Received: from vla1-5ff4bc6b92b2.qloud-c.yandex.net (vla1-5ff4bc6b92b2.qloud-c.yandex.net [2a02:6b8:c0d:4201:0:640:5ff4:bc6b])
        by mxback4q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id hXAC5DDetb-l1w8ENns;
        Thu, 03 Oct 2019 04:47:01 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1570067221;
        bh=3PZ/EUapuY12LgHO/gzsAZuxA1Lm/vcUDLQMKup6PQs=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID;
        b=t5B8jB8mZuHVN1ZONTGhfc0a7IFQXQt2ZJTO1V4yY7job+W3L4DU4NUIJzY2cOWUp
         ihm+cPkZF/julT5WQTnMqnXC8xn1H9WGEiaNsLZ5DK0GViBEtFDXMhDNu+Rqn28bT7
         Gtx4Gkui7hIJrT8K2GNFh+fUriFHYbTwnB4KoRWg=
Authentication-Results: mxback4q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-5ff4bc6b92b2.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id xeKgvxJyph-l1HuQtN6;
        Thu, 03 Oct 2019 04:47:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: Btrfs partition mount error
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <79466812-e999-32d8-ce20-0589fb64a433@yandex.ru>
 <85cb7aff-5fa4-c7f7-c277-04069954d7fe@gmx.com>
 <170d6f2f-65aa-3437-be21-61ac8499460b@yandex.ru>
 <4be73e38-c8b1-8220-1e5a-c0a1287df61d@gmx.com>
 <b0ec0862-e08c-677d-8bf4-8a87b74c1ec2@yandex.ru>
 <54a2e030-3b8f-6680-a1b6-826c2f5c0928@gmx.com>
From:   Andrey Ivanov <andrey-ivanov-ml@yandex.ru>
Message-ID: <d7a9650c-db8f-34db-fb7c-c1ba55159c93@yandex.ru>
Date:   Thu, 3 Oct 2019 04:47:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <54a2e030-3b8f-6680-a1b6-826c2f5c0928@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 01.10.2019 8:35, Qu Wenruo wrote:
>>> I recommend to do a "btrfs check" on all fses.
>>
>> I had done "btrfs check" on /dev/sda4:
>>
>> attached btrfs-check-sda4.output
>>
>> There are some errors. How to fix them?
> 
> It looks like "btrfs check --repair" can handle most of these bugs.
> 
> Please do a backup and try repair.

I ran "btrfs check --repair":

$ btrfs check -p --repair sda4.image.copy
enabling repair mode
Opening filesystem to check...
Checking filesystem on sda4.image.copy
UUID: a942b8da-e92d-4348-8de9-ded1e5e095ad
[1/7] checking root items                      (0:00:07 elapsed, 509893 items checked)
Fixed 0 roots.
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672

After 27 hours of work, I interrupted it:

backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
backref bytes do not match extent backref, bytenr=1985052672, ref bytes=20480, backref bytes=86016
backpointer mismatch on [1985052672 20480]
attempting to repair backref discrepency for bytenr 1985052672
checking extents                         (27:48:52 elapsed, 3363526296 items checked)

I think "btrfs check" is looped somewhere. Or not?
