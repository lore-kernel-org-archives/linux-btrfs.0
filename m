Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6E7C5ACC6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 20:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA6802098A
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 20:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="RNj9NRyv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA6802098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbeJQETK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 00:19:10 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:43657 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbeJQETK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 00:19:10 -0400
Received: by mail-lf1-f44.google.com with SMTP id p34-v6so18020116lfg.10
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 13:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=MFVk6gwcSLwGRFAk0UijauIJRReXhEbUSWXh7Wu2rSw=;
        b=RNj9NRyvzR6vLVdZu3OO5RdwfjulFWzr/qX4aIP2VGFKv78zpVura6lGTS479KjdL9
         gCvlT+/52ODSaPjjIp7Oboy0KJ1H/gucYoVsHWxP3HqA3eD8A+eD4CGgSa1gC5uhvd20
         OHIj3RdM9UBZOPnODutvb5tqw/ykoB6df/4Qm0vNRncUgG/JX79yhKMhc5JxYvG8RYos
         Venz4Mv6IsfVQ0wzQfx51gt/TkHD458bIVWX1UtkHbQCAaJ5Z8jYQ8St/BPUTgyA8Unq
         FbAgRE3GqOcdQ6Ptv816uTvmvAEWjeEa1B/OPtoeFkFNMnpNIrb5TBl4jCcOmC5uM2eb
         tCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=MFVk6gwcSLwGRFAk0UijauIJRReXhEbUSWXh7Wu2rSw=;
        b=Vm8j3N4RJ7+ufEvtneYsFfPNvQcMGBTP4WONh4b69KED1NasPaNMKuSwZolAZ56k7S
         F5YXslzC7yXRercHWUxEzMnkst9udcIQylCOs6UwJHZMTVyqVcR1+BOdBuf0gSWicwHT
         hDCEf40xn+GFWMsdlLINzVhn5aM0rZjAS5JNn1xGqBAJiYIRInR7VUePACY2Hp81FKf3
         5aNY8F0ySrwa2x5oLxUAZCkpBGjsH4mN7NOBkmeL8x87ZUoQVDYL0HHA1JOWn34wQmk5
         ZfhffF0Ju1jo0dYIxuD7pfmIQ+7ceHS6ig0wpnUaZ2pA79jvgyV2nmDlpC8jj/c45Vnm
         jE5Q==
X-Gm-Message-State: ABuFfoieBCoCoYxuKiUhYDe/lij75OTzLQmYflzDFxrEfGi5BAy6IAq3
        TUQACkdtOMpdC3eTCc+9JMptrxJKZvc9Ett5RJ4wpg==
X-Google-Smtp-Source: ACcGV63fUqOOzcbR+wBcUctlpJZjtk4fwrJ6IcZ5D88M5dn6z0jNvqEQjG7CBdF0x+/TNKqb8jNz3RQ6iVmPhtg3DdQ=
X-Received: by 2002:a19:98c1:: with SMTP id a184-v6mr13206975lfe.94.1539721621969;
 Tue, 16 Oct 2018 13:27:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Tue, 16 Oct 2018 13:27:01
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <f2df5862-ae3e-5808-4f00-e153f604df60@gmail.com>
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com> <f2df5862-ae3e-5808-4f00-e153f604df60@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 16 Oct 2018 14:27:01 -0600
X-Google-Sender-Auth: ADrfXfCrPM_Mi7y0jjUTf66XFu0
Message-ID: <CAJCQCtRrqOf+AzkH+-z++GTx9+Mh0-wA5PqQB9g0kDhBBCJ2qQ@mail.gmail.com>
Subject: Re: CRC mismatch
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Anton Shepelev <anton.txt@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 16, 2018 at 9:42 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2018-10-16 11:30, Anton Shepelev wrote:
>>
>> Hello, all
>>
>> What may be the reason of a CRC mismatch on a BTRFS file in
>> a virutal machine:
>>
>>     csum failed ino 175524 off 1876295680 csum 451760558
>>     expected csum 1446289185
>>
>> Shall I seek the culprit in the host machine on in the guest
>> one?  Supposing the host machine healty, what operations on
>> the gueest might have caused a CRC mismatch?
>>
> Possible causes include:
>
> * On the guest side:
>   - Unclean shutdown of the guest system (not likely even if this did
> happen).
>   - A kernel bug on in the guest.
>   - Something directly modifying the block device (also not very likely).
>
> * On the host side:
>   - Unclean shutdown of the host system without properly flushing data from
> the guest.  Not likely unless you're using an actively unsafe caching mode
> for the guest's storage back-end.
>   - At-rest data corruption in the storage back-end.
>   - A bug in the host-side storage stack.
>   - A transient error in the host-side storage stack.
>   - A bug in the hypervisor.
>   - Something directly modifying the back-end storage.
>
> Of these, the statistically most likely location for the issue is probably
> the storage stack on the host.

Is there still that O_DIRECT related "bug" (or more of a limitation)
if the guest is using cache=none on the block device?

Anton what virtual machine tech are you using? qemu/kvm managed with
virt-manager? The configuration affects host behavior; but the
negative effect manifests inside the guest as corruption. If I
remember correctly.

-- 
Chris Murphy
