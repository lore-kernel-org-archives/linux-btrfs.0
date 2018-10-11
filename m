Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA83C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0F4B2077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:15:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="r3bLBgJg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0F4B2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbeJKLkn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:40:43 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:38335 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbeJKLkm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:40:42 -0400
Received: by mail-lf1-f49.google.com with SMTP id g89-v6so5602384lfl.5
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 21:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=l7qOL0rbBqkY4/ubWH2OMUAcy9hZrglULSgwUZbPKfs=;
        b=r3bLBgJgIIldTcZY0BvYZfIJAgrkj/DmkNJ4qwVkCvUCKVyuyin7AYesFvaD6MkUyA
         k43WBiKCooN7n9KDJnH8vpdIgKzn/bJV0qZg8s/daS2zeyy0/iz975jSMzlQuijKkEsL
         5w1va9WDFAlPngrGIPnqWbEP8JFE4TXYLDmNdh3BfuyweEsTJHoMVg+AQ0B+sPK91xvn
         kqULdg5BXdpob82pPnD7jRwo1O9uI9cNkt3L0u/3Uc5vaNwsj5zouwdwMf1WWfgLIk/C
         9NDirv7ME1+XYj1w4j5DotQxl3OCuiMZ6Rd5NQ6xIlLuoPa8m1SEM0iH15IRiZse1zfb
         /1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=l7qOL0rbBqkY4/ubWH2OMUAcy9hZrglULSgwUZbPKfs=;
        b=Nxpi0EGCAgyTIKOIajzfVCODYh85IoQSfyIeKBZ8B0bWrDIct5z/9NL7RAMiyvgyIR
         yH8RVX9Bgw6yx3jO+Bv883MgfFiiwhZgcqimoaYXsqVgsDKusJZ4BVsFmNBQ1bVDBcUq
         A1KnLWqvotjH86tRNPL0LS1I41LwaDMjQD4FCJWj2SuH6m2BvxUdHI7+IVuqO6RI0i8v
         WKv1iDoT/Muz9Xmu4FCSfmGZl43/z5nejvRgEyHLJAxrF3K7rDZM2P2vmz7I7DkXMmtM
         LOc9uYHxRv/GnD8HsnWF4DnNnpPWf7f8SNz1DRHCxM4PIO93Y+pNoKGyfvAxvIeYIBOL
         NRDQ==
X-Gm-Message-State: ABuFfog8r6neUY6DdqkUEN1hbsh9Vm3l4BVWRHqdblq6TK1bE70qMIht
        ENebIMCy3P2RaVRvewg4gqEkNzczvYbI+RkKqeu3gA==
X-Google-Smtp-Source: ACcGV613PjpP2qtivp0SHe6d8YcSVm7R6DtQuhLPzdguiq6Au94W/RRKdY2DVvMSdviY19+Ytc6EiMCE0z9WN9UmmGo=
X-Received: by 2002:a19:1853:: with SMTP id o80-v6mr19524830lfi.10.1539231318957;
 Wed, 10 Oct 2018 21:15:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 21:15:18
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com> <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com> <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com> <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com> <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
 <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
 <3f3020c0-2643-074d-b88d-02123ece911c@nuclearwinter.com> <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Oct 2018 22:15:18 -0600
X-Google-Sender-Auth: Vt_rjlCOZpM6rBMbTjBOg-u2ut4
Message-ID: <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 10:00 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Oct 10, 2018 at 9:07 PM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
>> On 10/10/2018 10:51 PM, Chris Murphy wrote:
>>>
>>> On Wed, Oct 10, 2018 at 8:12 PM, Larkin Lowrey
>>> <llowrey@nuclearwinter.com> wrote:
>>>>
>>>> On 10/10/2018 7:55 PM, Hans van Kranenburg wrote:
>>>>>
>>>>> On 10/10/2018 07:44 PM, Chris Murphy wrote:
>>>>>>
>>>>>>
>>>>>> I'm pretty sure you have to umount, and then clear the space_cache
>>>>>> with 'btrfs check --clear-space-cache=v1' and then do a one time mount
>>>>>> with -o space_cache=v2.
>>>>>
>>>>> The --clear-space-cache=v1 is optional, but recommended, if you are
>>>>> someone who do not likes to keep accumulated cruft.
>>>>>
>>>>> The v2 mount (rw mount!!!) does not remove the v1 cache. If you just
>>>>> mount with v2, the v1 data keeps being there, doing nothing any more.
>>>>
>>>>
>>>> Theoretically I have the v2 space_cache enabled. After a clean umount...
>>>>
>>>> # mount -onospace_cache /backups
>>>> [  391.243175] BTRFS info (device dm-3): disabling free space tree
>>>> [  391.249213] BTRFS error (device dm-3): cannot disable free space tree
>>>> [  391.255884] BTRFS error (device dm-3): open_ctree failed
>>>
>>> "free space tree" is the v2 space cache, and once enabled it cannot be
>>> disabled with nospace_cache mount option. If you want to run with
>>> nospace_cache you'll need to clear it.
>>>
>>>
>>>> # mount -ospace_cache=v1 /backups/
>>>> mount: /backups: wrong fs type, bad option, bad superblock on
>>>> /dev/mapper/Cached-Backups, missing codepage or helper program, or other
>>>> error
>>>> [  983.501874] BTRFS info (device dm-3): enabling disk space caching
>>>> [  983.508052] BTRFS error (device dm-3): cannot disable free space tree
>>>> [  983.514633] BTRFS error (device dm-3): open_ctree failed
>>>
>>> You cannot go back and forth between v1 and v2. Once v2 is enabled,
>>> it's always used regardless of any mount option. You'll need to use
>>> btrfs check to clear the v2 cache if you want to use v1 cache.
>>>
>>>
>>>> # btrfs check --clear-space-cache v1 /dev/Cached/Backups
>>>> Opening filesystem to check...
>>>> couldn't open RDWR because of unsupported option features (3).
>>>> ERROR: cannot open file system
>>>
>>> You're missing the '=' symbol for the clear option, that's why it fails.
>>>
>>
>> # btrfs check --clear-space-cache=v2 /dev/Cached/Backups
>> Opening filesystem to check...
>> Checking filesystem on /dev/Cached/Backups
>> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
>> Clear free space cache v2
>> Segmentation fault (core dumped)
>>
>> [  109.686188] btrfs[2429]: segfault at 68 ip 0000555ff6394b1c sp
>> 00007ffcc4733ab0 error 4 in btrfs[555ff637c000+ca000]
>> [  109.696732] Code: ff e8 68 ed ff ff 8b 4c 24 58 4d 8b 8f c7 01 00 00 4c
>> 89 fe 85 c0 0f 44 44 24 40 45 31 c0 89 44 24 40 48 8b 84 24 90 00 00 00 <8b>
>> 40 68 49 29 87 d0 00 00 00 6a 00 55 48 8b 54 24 18 48 8b 7c 24
>>
>> That's btrfs-progs v4.17.1 on 4.18.12-200.fc28.x86_64.
>>
>> I appreciate the help and advice from everyone who has contributed to this
>> thread. At this point, unless there is something for the project to gain
>> from tracking down this trouble, I'm just going to nuke the fs and start
>> over.
>
> Is this a 68T file system? Seems excessive.

Haha, by excessive I mean nuking such a big fs just for being unable
to remove the space tree. I'm quite sure the devs would like to get
that crashing bug fixed, anyway.


-- 
Chris Murphy
