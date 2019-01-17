Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D83C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 01:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DEB20651
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 01:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="R27mOXqd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfAQBDq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 20:03:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42883 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfAQBDq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 20:03:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so9075898wrx.9
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 17:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:references:cc:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KnPBU4z1tcBTVxZSzvuD53ngHvkdFZA3Gum2fC8nxTQ=;
        b=R27mOXqdH6W6M1dqMysEL5YbLfZ33yHyXkyJCUAFDezLOz+7mtTdEsVUSEZjTuFwSh
         A7bczGH7SSPDYgzShAz/hIX0FE2Jq7nl3PyfSVzU506CmSCCsHRl85FiDN9uTnRKlwU2
         BftNygJqH2cBDtajs+9C5RGhhRP5rpTVqb/OchUp/uWPAGTiEz/0dETtfW3pzU+wg1Hp
         YmOaegtCRqB56SjzAuM+oyxMtqZTgiI8qFjdv02p99QgF2OQN6WsckgvWYN39DraMxII
         bkLqV4cdWZrW2oM+pjaqgtwH9efV+4DpDKkWw6XZuA2QbpV1fa4nB+d29SM9RETncfEg
         z/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KnPBU4z1tcBTVxZSzvuD53ngHvkdFZA3Gum2fC8nxTQ=;
        b=PG1e9rwUmsW6waDi++MgyMSCiAgLM9J6/Tv8kFIl5iBvonNnuygYzQoBNXKr0Gl+Gq
         FJZOxy5bGY2ztvxXcC/Qd5PxIvVueUG2llA+q2pLZJj4xDyg3dgPWLmSJC2VOh96cRzp
         PwTLZMqcGWviQHK7P6UZ4PLNFtn99ECOFP0AMT2P+9NwrJOpjOv/VkXk55PjNTO23EMQ
         x8/MaWJB8PG7+jwCz4f9CZHw5DPbUPh5sPV3j8b59yrhl0Hg5IrGmCMrU0YiIlHw3GEy
         chrG9WC/De3wucTcsuJ2o+7B5vAStyU/YdCDrERs+az0Y6NadxV9qPdc38V92dk7bQzo
         B7zA==
X-Gm-Message-State: AJcUukeVbelGv0d6wbmxdAteunOps9SvogkalB5BVLIbejmrPljYDAjW
        fqKOJeK9aa8/UzvyrkAbJbA6tueR
X-Google-Smtp-Source: ALg8bN6vOe4A/3ZUYTKoCR5kCKMHUFWjlgXiwgHf6b7jGjalKtwPCrl94sNyz3mvoOsr+zjjoRnHMw==
X-Received: by 2002:a5d:6647:: with SMTP id f7mr9661953wrw.225.1547687023423;
        Wed, 16 Jan 2019 17:03:43 -0800 (PST)
Received: from ?IPv6:2a01:5c0:e088:2f20:c870:68ee:5563:780b? ([2a01:5c0:e088:2f20:c870:68ee:5563:780b])
        by smtp.googlemail.com with ESMTPSA id v1sm112318908wrw.90.2019.01.16.17.03.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 17:03:42 -0800 (PST)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Chris Murphy <lists@colorremedies.com>
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com>
 <45de3cc0-b8b5-9e33-fbba-d02505583d2b@googlemail.com>
 <45b6077b-11d2-2db9-ddc5-85743507ba4d@suse.com>
 <54453a7f-abb1-209a-63f1-b93599ba72e1@googlemail.com>
 <CAJCQCtQOfKko2n1SQO8mLHRCGN0zswCWNey9ykMFKE8tZgCSaQ@mail.gmail.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Oliver Freyermuth <o.freyermuth@googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=o.freyermuth@googlemail.com; prefer-encrypt=mutual; keydata=
 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
 KB7t2CoZv5xo0STm
Message-ID: <e3a89985-1e1f-351f-207b-b6c2424cdd23@googlemail.com>
Date:   Thu, 17 Jan 2019 02:03:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQOfKko2n1SQO8mLHRCGN0zswCWNey9ykMFKE8tZgCSaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 17.01.19 um 01:28 schrieb Chris Murphy:
> On Wed, Jan 16, 2019 at 12:40 PM Oliver Freyermuth
> <o.freyermuth@googlemail.com> wrote:
>> Since repair did already run (and did not really help, but segfaults after trying some things) I guess the volume is hosed now anyways.
>> It's still sad there is no clear explanation for the corruption - I still believe it *might* have been unmounted hard while btrfs-cleaner was running, though,
>> but I would hope that can not lead to a non-recoverable state (especially if "only" deleted / to-be-deleted subvolumes are affected).
> 
> Well in theory no, even cleaning is predicated on COW. So what should
> be true is the trees are pruned and written into a new location, and
> only once that succeeds is a new super written. Of course, a
> complicating factor is the tree walking is expensive, likely not all
> of it can fit in memory at one time, and the new pruned tree isn't all
> written out at once either; and then another complicating factor is if
> any new files are being created at the same time. You don't want all
> new writes to be held up until the cleaning is done.
> 
> But if there's no hardware fault or transient power problem or failure
> at the time, then all of this should eventually complete successful
> and in the proper order. That it didn't, suggests a bug. The problem
> is where. Btrfs bug? Some other kernel bug? Hardware, including
> firmware, bug?
> 

Thanks for the explanation, getting a better understanding of the expected
behaviour is really appreciated! 

I would even add the disk controller's firmware to the list of potential causes - it's an SMR disk 
(sadly, fully device managed) which does _a lot_ of data shuffling, 
sometimes slowing down to something like
300 kB/s especially when btrfs-clean runs and does a lot of random access. 
I have learnt my lesson never to do random writes on device-managed SMR again, 
but use them as write-once media. 

In case anybody thinks that providing metadata of the image or 
extracting more details from it helps to at least exclude / identify a btrfs bug, please tell me.
Otherwise I'll purge it in a few days, I have salvaged all data I wanted. 

Excluding everything else is complex. I know the pain, since I have already (almost) lost one
and corrupted another BTRFS volume due to the infamous r8169 bug which has affected
hundreds of thousands of machines (and still affects those with old kernels!):
https://github.com/torvalds/linux/commit/a78e93661c5fd30b9e1dee464b2f62f966883ef7
It took me years to finally invest enough time to identify the cause of that corruption,
since memtests could never show it and I had to actually trigger
it from user space by reading network statistics (and only then, a userspace memtest could see it). 

Cheers,
	Oliver
