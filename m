Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D66C0044C
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 21:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 109262081F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 21:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RlNGohA+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 109262081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbeKDGhp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 01:37:45 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35650 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbeKDGhp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 01:37:45 -0500
Received: by mail-qk1-f195.google.com with SMTP id v68-v6so8831332qka.2;
        Sat, 03 Nov 2018 14:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=/4QSxRfWA4eUmLWjxNBtXcxsBRsNWL9AR5jtvVrGzgA=;
        b=RlNGohA+DjjthJztExxEu36L3Dn3VQC/3Koz90euBfgoCRGJM6U8D4wutbSizs9boz
         vTNrZ6al/ICEjSMFbOoENzkCFlRSE41Tyq1S+yHOI/qdUzDX+HUaOw7tLpCBV3iPCztJ
         CnDdorhZwhWQKvY56Btx6P9M3TGlqwriCNrKe0dvlc8ErLixGTW14fVj2Z3/H8q/8OQx
         TUmZu5nqe9hdHLTCcQ1IPdQ8EyiASy1kaJFn/OKvVS1slI1VzP8Z0x8d7RThPjfQc1AH
         XWS7vSWiMe05poS58IS1Sb1n/h+vUasiAy4HPI3XEhkYayKEtk9s82HQWWGky2269l9b
         QpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc:content-transfer-encoding;
        bh=/4QSxRfWA4eUmLWjxNBtXcxsBRsNWL9AR5jtvVrGzgA=;
        b=Y6yAYmY6OhK26rTQlgLRfcxQBGjapx7eRsmRDalQETRut3xH7k8hvsw+Ylp+5b5Hsu
         VDGseWkeqdVunQNVlCFHbtun3Ooplksy+VvtbdwMJ5VbYRVt2XZOR0iahdtRx7WGu+Ip
         CXnXjOhcLaMl6fmCYLAIK+PYkLJLTJ4m96LUJxATwOwUcYSJo/ZntDMEKr+1JjUmEnqy
         CX7g9oNw/N+IcLbd9Q7/VQex/p+Bwu+MWY2uV+IWmdLbq6fcpSJAZYhzl+TTcDvjFvFS
         wDhk1ydggAn+cqvMvXQ4HZ1Ltg4VWMlGBccpRNL3GAMzaZS1NbRFD98O8YfxhIruFXHd
         3JqA==
X-Gm-Message-State: AGRZ1gIYSgl9ZfeLS9yNldXyAgC5bqEWQBasIhtWzoww5Pl/aUu9xEBB
        o8DTV0fMCYR1NilXBkYIPUEAtoWBF9IvFJg9oDg=
X-Google-Smtp-Source: AJdET5dLPukNDR5tHnMMW9dn1z+z9sQiMGVfb6jIUWS0fcMc4pFx/rpaIBF00AVqXpWdSkeH3N//NF3EpyeIYZrceCY=
X-Received: by 2002:ae9:e102:: with SMTP id g2mr14482787qkm.343.1541280315523;
 Sat, 03 Nov 2018 14:25:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:9881:0:0:0:0:0 with HTTP; Sat, 3 Nov 2018 14:25:14 -0700 (PDT)
In-Reply-To: <8e3a668d-79d2-6fc0-6291-b3d19b793d6f@suse.com>
References: <20181103153941.1881966-1-arnd@arndb.de> <8e3a668d-79d2-6fc0-6291-b3d19b793d6f@suse.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 3 Nov 2018 22:25:14 +0100
X-Google-Sender-Auth: ve6jy82uvd1kCmlkfSJA5D84mEs
Message-ID: <CAK8P3a0FnpZ4pOyvXiQbhw5F116SqjwiYMY5Ry1k4J+Cvh=_nw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Changbin Du <changbin.du@gmail.com>,
        Anand Jain <anand.jain@oracle.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/3/18, Nikolay Borisov <nborisov@suse.com> wrote:
> On 3.11.18 =D0=B3. 17:39 =D1=87., Arnd Bergmann wrote:
>> On 32-bit ARM with gcc-8, I see a link error with the addition of the
>> CONFIG_NO_AUTO_INLINE option:
>>
>> fs/btrfs/super.o: In function `btrfs_statfs':
>> super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
>> fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to
>> `__aeabi_uldivmod' follow
>>
>> So far this is the only file that shows the behavior, so I'd propose
>> to just work around it by marking the functions as 'static inline'
>> that normally get inlined here.
>>
>> The reference to __aeabi_uldivmod comes from a div_u64() which has an
>> optimization for a constant division that uses a straight '/' operator
>> when the result should be known to the compiler. My interpretation is
>> that as we turn off inlining, gcc still expects the result to be constan=
t
>> but fails to use that constant value.
>
> I read this as "this is a compiler bug", no ? So you are providing a
> hack around a compiler bug?

Mostly, yes. The do_div() macro is really pushing the boundaries
of what we can expect the compiler to do in terms of optimizations,
and we've had problems with it in the past.

IIRC the gcc developers would not classify this as a bug because
the result of __builtin_constant_p() is not guaranteed to work the
way we expect, it just does so most of the time.

        Arnd
