Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4568FC46464
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B0C22B54
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="1pL4/+hk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85B0C22B54
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbeKFDed (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 22:34:33 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36942 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387561AbeKFDec (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 22:34:32 -0500
Received: by mail-lj1-f181.google.com with SMTP id e5-v6so4806712lja.4
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=7/WSEIYHody6/3yZCV9i+6cNKtKniovqcJ05WOdouBk=;
        b=1pL4/+hkigPskMZGZH1aPP+B2gXyB5U0B3uVJ3GVhlclcVAuDxX5WMP5kh+gmP+3AV
         yndH9/znYTZiMzRy14QgoFWVNy7H6UQ7GfyYrF8Uk81OKu1nvGYe2L4n2a/JXuxBZUU0
         48YfUahANxBI3Gj7Tb1rqAeaP2x7UAQHM2PgkIvhRzJI8DwmOa+PJjha+jJimKZPIJUe
         ZQUYspesv/VRbjmAyWhTFVmwSs2zo/eSY3k8GVn4ClT7AMz2bY7Rodp2gyfURhiJbROO
         icOJ9FpbEsi+fcJsFHdR12eEjmLp+q2WaiiZsXaLH+mYu9upnSJmF/5aOaIgVj+XIGqj
         DQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=7/WSEIYHody6/3yZCV9i+6cNKtKniovqcJ05WOdouBk=;
        b=U8NAWXvfSt9uaD4+qTIvcSHcmB83kio1sn5ikOtDKRUoz6svFHRGSgh3QGgqfuepMs
         Qj7yIKqZUPVmNIH85KVOd+6MdZRfjoDJA6hH4wYnE2JNKM782GJrFtuEtqEjpyUuwox+
         7w61N8BR858zKY1JMX0+DR7tzNBEsE+FGT2/aappUwl+QGCIKTLM7uikdV3TdLIiWVIf
         nhctBSH/ccOX0hT2w45KaVpkHxXRA7hp0RB7eP5eZnJaMfwyo+0+2uPJO5LR2pF/wZ0A
         0Vlrf1RhW8bcH3d39wWwpl0tdmil2aadghCqn/L6kgGdMlm+7hEB6pQRyS/zqmjET6mJ
         fgJA==
X-Gm-Message-State: AGRZ1gK0F/AKm2Sgnvi4x11NjFHFtZvkklf5zzidbSSRVhs/dK566e86
        Jm/c0tGttfQpqAsh0VtV9TrPh5HDydRYHjMo3CWAFA==
X-Google-Smtp-Source: AJdET5duWbwDTBULlwwbFbW5kwgvBhYUpzqMb+N6fv2Zur6dfxJ6UJMfSrSrKZHTdkdyyE+RJcApmsgsY6zVZX4uK5U=
X-Received: by 2002:a2e:8099:: with SMTP id i25-v6mr6598236ljg.174.1541441617909;
 Mon, 05 Nov 2018 10:13:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:4f0d:0:0:0:0:0 with HTTP; Mon, 5 Nov 2018 10:13:37 -0800 (PST)
X-Originating-IP: [67.162.155.105]
In-Reply-To: <8a70013d-6d7c-b91d-56e5-a2ce0d0bdc0f@gmail.com>
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
 <CAMOu_z0879AZEKHPDFOFeGL8H4E2Uj+CzFYV6tSdqHoHF5NyNg@mail.gmail.com>
 <5c8bbcac-65e2-1787-d836-bcf4722ed0a6@dirtcellar.net> <8a70013d-6d7c-b91d-56e5-a2ce0d0bdc0f@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 5 Nov 2018 11:13:37 -0700
X-Google-Sender-Auth: Y54rVWIS4yCLF7ZDa8HacOvEB5I
Message-ID: <CAJCQCtTbgLH5mMkKdUx9EOrCt9rE5WwFQJ8unncWLt4t+WsubQ@mail.gmail.com>
Subject: Re: BTRFS did it's job nicely (thanks!)
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     waxhead <waxhead@dirtcellar.net>,
        Sterling Windmill <swindmill@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 5, 2018 at 6:27 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 11/4/2018 11:44 AM, waxhead wrote:
>>
>> Sterling Windmill wrote:
>>>
>>> Out of curiosity, what led to you choosing RAID1 for data but RAID10
>>> for metadata?
>>>
>>> I've flip flipped between these two modes myself after finding out
>>> that BTRFS RAID10 doesn't work how I would've expected.
>>>
>>> Wondering what made you choose your configuration.
>>>
>>> Thanks!
>>> Sure,
>>
>>
>> The "RAID"1 profile for data was chosen to maximize disk space utilization
>> since I got a lot of mixed size devices.
>>
>> The "RAID"10 profile for metadata was chosen simply because it *feels* a
>> bit faster for some of my (previous) workload which was reading a lot of
>> small files (which I guess was embedded in the metadata). While I never
>> remembered that I got any measurable performance increase the system simply
>> felt smoother (which is strange since "RAID"10 should hog more disks at
>> once).
>>
>> I would love to try "RAID"10 for both data and metadata, but I have to
>> delete some files first (or add yet another drive).
>>
>> Would you like to elaborate a bit more yourself about how BTRFS "RAID"10
>> does not work as you expected?
>>
>> As far as I know BTRFS' version of "RAID"10 means it ensure 2 copies (1
>> replica) is striped over as many disks it can (as long as there is free
>> space).
>>
>> So if I am not terribly mistaking a "RAID"10 with 20 devices will stripe
>> over (20/2) x 2 and if you run out of space on 10 of the devices it will
>> continue to stripe over (5/2) x 2. So your stripe width vary with the
>> available space essentially... I may be terribly wrong about this (until
>> someones corrects me that is...)
>
> He's probably referring to the fact that instead of there being a roughly
> 50% chance of it surviving the failure of at least 2 devices like classical
> RAID10 is technically able to do, it's currently functionally 100% certain
> it won't survive more than one device failing.

Right. Classic RAID10 is *two block device* copies, where you have
mirror1 drives and mirror2 drives, and each mirror pair becomes a
single virtual block device that are then striped across. If you lose
a single mirror1 drive, its mirror2 data is available and
statistically unlikely to also go away.

Whereas with Btrfs raid10, it's *two block group* copies. And it is
the block group that's striped. That means block group copy 1 is
striped across 1/2 the available drives (at the time the bg is
allocated), and block group copy 2 is striped across the other drives.
When a drive dies, there is no single remaining drive that contains
all the missing copies, they're distributed. Which means you've got a
very good chance in a 2 drive failure of losing two copies of either
metadata or data or both. While I'm not certain it's 100% not
survivable, the real gotcha is it's possible maybe even likely that
it'll mount and seem to work fine but as soon as it runs into two
missing bg's, it'll face plant.


-- 
Chris Murphy
