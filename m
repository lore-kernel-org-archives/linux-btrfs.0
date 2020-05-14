Return-Path: <SRS0=4Cb5=64=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A13FC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 May 2020 16:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF002065D
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 May 2020 16:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgENQF1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:05:27 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:39678 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgENQF0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 May 2020 12:05:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id E26F56224FD8;
        Thu, 14 May 2020 18:05:24 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iM0G5GJMg53f; Thu, 14 May 2020 18:05:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C13216224FC5;
        Thu, 14 May 2020 18:05:23 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ee4XeyBIMuBh; Thu, 14 May 2020 18:05:23 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 99FC66224FD8;
        Thu, 14 May 2020 18:05:23 +0200 (CEST)
Date:   Thu, 14 May 2020 18:05:23 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Message-ID: <1536293942.220013.1589472323477.JavaMail.zimbra@nod.at>
In-Reply-To: <20200514100018.1809465c@lwn.net>
References: <20200514092415.5389-1-jth@kernel.org> <20200514092415.5389-4-jth@kernel.org> <20200514062611.563ec1ea@lwn.net> <SN4PR0401MB3598FFE2AC30EA4E7B85533C9BBC0@SN4PR0401MB3598.namprd04.prod.outlook.com> <1363039146.219999.1589469276242.JavaMail.zimbra@nod.at> <20200514100018.1809465c@lwn.net>
Subject: Re: [PATCH v3 3/3] btrfs: document btrfs authentication
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: btrfs: document btrfs authentication
Thread-Index: gyZzhnsO+uH9PYLSiErl0f0A7VuQRA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Jonathan Corbet" <corbet@lwn.net>
> An: "richard" <richard@nod.at>
> CC: "Johannes Thumshirn" <Johannes.Thumshirn@wdc.com>, "Johannes Thumshirn" <jth@kernel.org>, "David Sterba"
> <dsterba@suse.cz>, "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, "linux-btrfs" <linux-btrfs@vger.kernel.org>, "Eric
> Biggers" <ebiggers@google.com>
> Gesendet: Donnerstag, 14. Mai 2020 18:00:18
> Betreff: Re: [PATCH v3 3/3] btrfs: document btrfs authentication

> On Thu, 14 May 2020 17:14:36 +0200 (CEST)
> Richard Weinberger <richard@nod.at> wrote:
> 
>> But I have no idea what this orphan thingy is.
> 
> It suppresses a warning from Sphinx that the file is not included in the
> docs build.  Mauro did that with a lot of his conversions just to make his
> life easier at the time, but it's not really something we want going
> forward.

Ahh, thanks for explaining. :-)

Thanks,
//richard
