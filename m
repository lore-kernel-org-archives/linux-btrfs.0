Return-Path: <SRS0=4Cb5=64=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA38EC433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 May 2020 15:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F96206A5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 May 2020 15:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgENPOk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 May 2020 11:14:40 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:38946 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgENPOj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 May 2020 11:14:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id DF8166071A6F;
        Thu, 14 May 2020 17:14:36 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SyhtsM6CPx8Z; Thu, 14 May 2020 17:14:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 82BF46071A7C;
        Thu, 14 May 2020 17:14:36 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ahyWRP0IqOKq; Thu, 14 May 2020 17:14:36 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5E8D56071A6F;
        Thu, 14 May 2020 17:14:36 +0200 (CEST)
Date:   Thu, 14 May 2020 17:14:36 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Message-ID: <1363039146.219999.1589469276242.JavaMail.zimbra@nod.at>
In-Reply-To: <SN4PR0401MB3598FFE2AC30EA4E7B85533C9BBC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200514092415.5389-1-jth@kernel.org> <20200514092415.5389-4-jth@kernel.org> <20200514062611.563ec1ea@lwn.net> <SN4PR0401MB3598FFE2AC30EA4E7B85533C9BBC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Subject: Re: [PATCH v3 3/3] btrfs: document btrfs authentication
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: btrfs: document btrfs authentication
Thread-Index: AQHWKdGHpFk4qUNYxkaDbw38lHwpUkjAs1EV
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

----- Ursprüngliche Mail -----
>> Why mark this "orphan" rather than just adding it to index.rst so it gets
>> built with the rest of the docs?
>>
> I've no idea of rst and the ubifs-authentication.rst which I had open at the
> time did have this as well, so I blindly copied it. Thanks for spotting, will
> remove in the next iteration.

Well, the original ubifs-authentication documentation was written in in markdown
(which is IMHO muss less pain to write), later it was converted to rst by:

commit 09f4c750a8c7d1fc0b7bb3a7aa1de55de897a375
Author: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Fri Jul 26 09:51:14 2019 -0300

    docs: ubifs-authentication.md: convert to ReST
    
    The documentation standard is ReST and not markdown.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    Acked-by: Rob Herring <robh@kernel.org>
    Signed-off-by: Jonathan Corbet <corbet@lwn.net>

But I have no idea what this orphan thingy is.

Thanks,
//richard
