Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC82C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D6D920657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="miRQAq5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfAPBPT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:15:19 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45205 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfAPBPS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:15:18 -0500
Received: by mail-ed1-f67.google.com with SMTP id d39so4075412edb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:references:cc:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJKzNU9GJQS6ActxhoEV1fsCqgJcxAYZh2VqzIK/SVU=;
        b=miRQAq5XQR0DkQEfOltJfcPH8z3tzZYmcShLC8ecXnUOsJOdGVm/iBFoRH0sEOvxnB
         w3c09HOdsEIuAeJt4oL8him+w3gLe7rDFp9jxm7KUky4ml2boUoZwxcafPQhvVdyTgsH
         QcyGTcUEcnvIAFqmNVwdxPR4hf5fOIVLYfKw/b9KxASJPI9o4r4GyKulNhqNwlTKM1u0
         /4LhaiABUP91Ih6kWct8/1/al8s3TDPfQ0QjfaK0Uf45FOisfDQKBjmILqpBgJNFAVbl
         2eSTywz9dwn6fN4JOhyH9I3osH7eyTYJcOicKJB3SozBDRjHRLSWJS+umj8HYT1AfzHp
         nJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AJKzNU9GJQS6ActxhoEV1fsCqgJcxAYZh2VqzIK/SVU=;
        b=OiOfT+/a/lOjlHU5X8qxRiUSGzBofW9Fw7NX/n12pLREiAljPPHaXp8uWducPmQOkQ
         8BhcXPS0mz5LrZa94vo9GiHx5tsf2bM6lXenJbW1cTFNKLl2L4kFTLm7hPnNA9xe7/0o
         geE1ZgRZ5xIJoaUyQS7U2SxHl3dVbSahH01MGJ5zgkpAtrGd5jmGLyBCNQn7z5NUuUrP
         pXceKWPMhBrO6nUn06V+JwsA3trRv3M3a9Ii8O3XOeUV1qBDq5zoG7liTO+NC83RwOsi
         vXYAEq91cIlcmnZJRcIilsou7fLycWQOO8trlzrF4r2UnJt2A5E8Z/tIYxor6OhvDaHA
         9ZEg==
X-Gm-Message-State: AJcUukdraJT6FG04seFyfEmEYYVVJ7KUCVpqaPtEBQlhaj8ag2jJyH66
        1rVWU+v9U2lrNDhrA7P37jX5lny+
X-Google-Smtp-Source: ALg8bN47QCxBQhCYQr/OUEIoTY6vbUV1MVm2St2Vc9V1S1txVIFXLARUalFt8E5EY2LBaYcSx9wmFQ==
X-Received: by 2002:a50:ccdd:: with SMTP id b29mr5437856edj.102.1547601316027;
        Tue, 15 Jan 2019 17:15:16 -0800 (PST)
Received: from ?IPv6:2a01:5c0:e088:2f20:fa16:54ff:fe84:9770? ([2a01:5c0:e088:2f20:fa16:54ff:fe84:9770])
        by smtp.googlemail.com with ESMTPSA id p7-v6sm3027292ejx.27.2019.01.15.17.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 17:15:15 -0800 (PST)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Chris Murphy <lists@colorremedies.com>
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
 <CAJCQCtTzUHw5COdsEjskAHWJhAiiyOBtAxT0f7cf6oeziQ=1gg@mail.gmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Oliver Freyermuth <o.freyermuth@googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=o.freyermuth@googlemail.com; prefer-encrypt=mutual; keydata=
 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
 KB7t2CoZv5xo0STm
Message-ID: <f642447b-ef93-4763-6539-7b53d8bfa350@googlemail.com>
Date:   Wed, 16 Jan 2019 02:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTzUHw5COdsEjskAHWJhAiiyOBtAxT0f7cf6oeziQ=1gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 16.01.19 um 02:11 schrieb Chris Murphy:
> On Tue, Jan 15, 2019 at 5:41 PM Chris Murphy <lists@colorremedies.com> wrote:
>>
>> The relevant error messages are:
>>
>> unable to find ref byte
>> errno=-2 No such entry
>>
>> Somehow a reference byte has been corrupted and inserted into multiple
>> locations in the tree and it's not repairable: i.e. neither a correct
>> value can be inferred from other available information, nor do the
>> tools have a good way to just trim out the item that contains bad key
>> pointers - part of the problem with just cutting out the bad parts is
>> it's not clear the problem is made even worse or how far the
>> corruption extends.
>>
>> What's further troubling though is the idea that this corruption might
>> have propagated to a separate volume via snapshot send receive. Either
>> of the file systems might still be useful for a developer, it seems to
>> me important to have some kind of check to make sure it's not possible
>> for corruption to propagate in this manner.
>>
>> In the meantime, I think it's a good idea to do a memory test. There's
>> some information in the archives about how to do this in a more
>> reliable way than just memtest86 type tests, but if you can run even a
>> memtest86 over a weekend it might confirm there's a memory problem.
>> Unfortunately a pass doesn't necessarily mean there aren't rare
>> transient problems.
> 
> Also, this could be related...
> 
> [ 4368.361487] CPU: 0 PID: 23915 Comm: kworker/u16:11 Tainted: P
>  W  O      4.20.1-gentoo #1
> 
> Do you know why it's tainted? Looks like an out of tree proprietary
> module. And also there has been a previous kernel warning but that
> part of the dmesg isn't included. It's not possible to absolutely
> exclude an out of tree kernel from being a source of memory
> corruption, but it makes it a possible suspect and therefore it makes
> tracking down the source of the problem harder.
> 

nvidia-drivers, sadly. Nouveau fails with the hardware I have, and it's rare enough
nobody with enough experience has stepped up to make it work well :-(. 
