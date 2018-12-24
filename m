Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51186C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 02:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A131621783
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 02:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="LmxceuxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbeLXCAT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 21:00:19 -0500
Received: from mail.virtall.com ([46.4.129.203]:33086 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbeLXCAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 21:00:19 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 18B782BD547
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1545616816; bh=8jxOjIu5aDlN6iWe67wHvvtI7E2ESIdnsS43Sq6/hRk=;
        h=Date:From:To:Subject;
        b=LmxceuxZKRa6ED0ZEcoxkq2kFXCXSa1NIaGdt/GuDKCWRR3dufGYhxAaDyeempw9F
         USpaHHkNFBaQD9C3uic+WOnI/NH3pKlD7Y6xfNrotgS3x+x6zGJe9y90l9Bq1U3AyC
         EZyL0o7r/NxuDCBhQEsfhLNLeY9MoObrIFnn7rxWh27YPyzOHWwXNxr6S0bOCgvJr9
         8Tvdb0/m441mjmvlx3HdVKnpvxmgrh+t44JgYvOUqaU7LZsdPTblbl5+67pQfNbFx4
         DdXw47OedHWxVm5WHn9x3QPvAZBiTKqAj/RXrJrL0Q5QdPItVRQOte4xzUNwybic9u
         6ccnB61UQv+3A==
X-Fuglu-Suspect: d2305903d37347a6ad2027076d8e6c05
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 02:00:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 Dec 2018 11:00:12 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: compress-force not really forcing compression?
Message-ID: <642827686bbbde2e359683c7e60743f9@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>> > If a file has portions which are not easily compressible does that imply all
>> > future writes are also incompressible. IMO no, so I think what will be prudent
>> > is remove FORCE_COMPRESS altogether and make the code act as if it's
>> > always on.
>> >
>> > Any opinions?
>> 
>> 
>> That is a good idea.  If I turn on compression I would expect 
>> everything
>> to be compressed, except in cases where there is no size benefit.
> 
> I expect that the vast majority of files consist of blocks of similar
> compressibility.  Thus, finding a block that fails to compress strongly
> suggests other blocks are either incompressible as well or compress 
> only
> minimally.  Refusing to waste time, electricity and fragmentation in 
> such
> case is a good default, I think.

Please see this thread for an example where btrfs compression fails to 
detect that text files compress very well:

https://marc.info/?t=144905015000003&r=1&w=4


To put it short - with rsync server receiving text logs from remote 
servers, sometimes at slow speeds (due to how logfiles are appended):

- compress + zlib - some 20% compression ratio
- compress-force + zlib - some 80% compression ratio



Tomasz Chmielewski
https://lxadm.com
